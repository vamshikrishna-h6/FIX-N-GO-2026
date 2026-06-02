import 'api_service.dart';

class TechnicianService {
  static Future<Map<String, dynamic>> getNearbyOrders() async {
    return await ApiService.get('/technician/orders/nearby');
  }

  static Future<Map<String, dynamic>> acceptOrder(String orderId) async {
    return await ApiService.post('/technician/orders/$orderId/accept', {});
  }

  static Future<Map<String, dynamic>> updateStatus(String status) async {
    return await ApiService.patch('/technician/status', {'status': status});
  }

  static Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    return await ApiService.patch('/technician/profile', data);
  }
}
