import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  bool _isAuthenticated = false;
  Map<String, dynamic>? _userProfile;

  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get userProfile => _userProfile;

  Future<bool> tryAutoLogin() async {
    try {
      final user = await _storageService.getUser();
      if (user != null && user['token'] != null && user['token']!.isNotEmpty) {
        _apiService.setToken(user['token']);
        _isAuthenticated = true;
        await fetchProfile();
        notifyListeners();
        return true;
      }
    } catch (e) {
      // ignore
    }
    return false;
  }

  Future<bool> login(String email, String password) async {
    try {
      final data = await _apiService.login(email, password);
      final token = data['token'] as String;
      final userMap = data['data'] ?? {};
      final name = userMap['name'] as String? ?? '';
      
      await _storageService.saveSession(token: token, name: name, email: email);
      _apiService.setToken(token);
      _isAuthenticated = true;
      await fetchProfile();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final data = await _apiService.register(name, email, password);
      final token = data['token'] as String;
      
      await _storageService.saveSession(token: token, name: name, email: email);
      _apiService.setToken(token);
      _isAuthenticated = true;
      await fetchProfile();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateProfile({
    String? name,
    String? phone,
    String? address,
    String? city,
    String? pincode,
  }) async {
    try {
      await _apiService.updateProfile(
        name: name,
        phone: phone,
        address: address,
        city: city,
        pincode: pincode,
      );
      await fetchProfile();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await _storageService.clear();
    _apiService.setToken(null);
    _isAuthenticated = false;
    _userProfile = null;
    notifyListeners();
  }

  Future<void> fetchProfile() async {
    try {
      final response = await _apiService.getProfile();
      _userProfile = response['data'] as Map<String, dynamic>?;
      notifyListeners();
    } catch (e) {
      // ignore
    }
  }
}

