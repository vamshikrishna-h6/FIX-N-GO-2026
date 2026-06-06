import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../services/api_service.dart';

class PaymentService {
  final ApiService _apiService = ApiService();

  Future<bool> processPayment(String orderId, int amount) async {
    try {
      // 1. Create Payment Intent on the backend
      final response = await _apiService.post('/api/payments/create-intent', {
        'orderId': orderId,
        'amount': amount,
      });

      final data = response['data'] ?? {};
      final clientSecret = data['clientSecret'] as String?;
      final paymentId = data['paymentId'] as String?;

      if (clientSecret == null || paymentId == null) {
        return false;
      }

      // 2. Initialize Stripe Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Fix-N-Go Services',
          style: ThemeMode.dark,
        ),
      );

      // 3. Present Payment Sheet to user
      await Stripe.instance.presentPaymentSheet();

      // 4. Extract Payment Intent ID from Client Secret and confirm with backend
      final paymentIntentId = clientSecret.split('_secret')[0];
      final confirmResponse = await _apiService.post('/api/payments/confirm', {
        'paymentIntentId': paymentIntentId,
        'paymentId': paymentId,
        'orderId': orderId,
      });

      return confirmResponse['success'] == true;
    } catch (e) {
      debugPrint('Payment error: $e');
      // In case Stripe fails or is not configured with keys on backend, return false
      return false;
    }
  }
}
