import 'api_service.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(String email, String password) async {
    return await ApiService.post('/auth/login', {'email': email, 'password': password});
  }

  static Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    return await ApiService.post('/auth/register', data);
  }

  static Future<Map<String, dynamic>> getProfile(String token) async {
    return await ApiService.get('/auth/profile');
  }
}
