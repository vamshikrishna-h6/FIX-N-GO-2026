import 'api_service.dart';

class OrderService {
  static Future<Map<String, dynamic>> getOrders() async {
    return await ApiService.get('/orders');
  }

  static Future<Map<String, dynamic>> createOrder(Map<String, dynamic> data) async {
    return await ApiService.post('/orders', data);
  }

  static Future<Map<String, dynamic>> updateStatus(String orderId, String status) async {
    return await ApiService.patch('/orders/$orderId/status', {'status': status});
  }
}
