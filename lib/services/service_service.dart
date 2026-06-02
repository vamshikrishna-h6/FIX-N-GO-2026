import 'api_service.dart';

class ServiceService {
  static Future<Map<String, dynamic>> getIssues() async {
    return await ApiService.get('/services/issues');
  }
}
