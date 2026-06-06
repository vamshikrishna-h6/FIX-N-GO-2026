import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:5000/api';
    if (Platform.isAndroid) return 'http://10.0.2.2:5000/api';
    return 'http://localhost:5000/api';
  } 
  
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password, 'role': 'technician'}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await saveToken(data['token']);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Use the new standardized /api/tech endpoints
  Future<List<dynamic>> getIncomingOffers() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/tech/jobs/offers'), headers: await _getHeaders());
      return jsonDecode(res.body);
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getAvailableJobs() async {
    return getIncomingOffers();
  }

  Future<bool> acceptJob(String orderId) async {
    try {
      final res = await http.post(Uri.parse('$baseUrl/tech/jobs/$orderId/accept'), headers: await _getHeaders());
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> getDashboard() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/tech/dashboard'), headers: await _getHeaders());
      return jsonDecode(res.body);
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getStats() async {
    final dashboard = await getDashboard();
    if (dashboard == null) return null;
    return {
      'walletBalance': dashboard['walletBalance'],
      'totalEarnings': (dashboard['walletBalance'] ?? 0) + (dashboard['pendingEarnings'] ?? 0),
      'completedOrdersCount': dashboard['jobsDone'],
    };
  }

  Future<bool> updateLocation(double lat, double lng, [bool? isOnline]) async {
    try {
      if (isOnline != null) {
        await setOnline(isOnline);
      }
      final res = await http.patch(
        Uri.parse('$baseUrl/tech/location'), 
        headers: await _getHeaders(),
        body: jsonEncode({'lat': lat, 'lng': lng})
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> setOnline(bool isOnline) async {
    try {
      final res = await http.patch(
        Uri.parse('$baseUrl/tech/availability'), 
        headers: await _getHeaders(),
        body: jsonEncode({'isOnline': isOnline})
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> getWallet() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/tech/wallet'), headers: await _getHeaders());
      return jsonDecode(res.body);
    } catch (e) {
      return null;
    }
  }

  Future<bool> requestWithdrawal(int amount, String bankAccount) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/payments/withdraw'), 
        headers: await _getHeaders(),
        body: jsonEncode({'amount': amount, 'bankAccount': bankAccount})
      );
      return res.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<List<dynamic>> getMyJobs() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/tech/jobs?status=active'), headers: await _getHeaders());
      return jsonDecode(res.body);
    } catch (e) {
      return [];
    }
  }

  Future<bool> startJob(String orderId) async {
    try {
      final res = await http.post(Uri.parse('$baseUrl/tech/jobs/$orderId/start'), headers: await _getHeaders());
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> completeJob(String orderId) async {
    try {
      final res = await http.post(Uri.parse('$baseUrl/tech/jobs/$orderId/complete'), headers: await _getHeaders());
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateOrderStatus(String orderId, String status) async {
    if (status == 'completed') {
      return completeJob(orderId);
    } else if (status == 'in_progress' || status == 'started') {
      return startJob(orderId);
    }
    return false;
  }
}
