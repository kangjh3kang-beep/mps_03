import 'package:dio/dio.dart';

class PaymentService {
  final Dio _dio;

  PaymentService(this._dio);

  Future<Map<String, dynamic>> createPaymentIntent({
    required String itemId,
    required double amount,
    required String currency,
  }) async {
    try {
      final response = await _dio.post(
        '/payment/create-intent',
        data: {
          'item_id': itemId,
          'amount': amount,
          'currency': currency,
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to create payment intent: $e');
    }
  }

  Future<Map<String, dynamic>> confirmPayment({
    required String paymentIntentId,
    required String paymentMethodId,
  }) async {
    try {
      final response = await _dio.post(
        '/payment/confirm',
        data: {
          'payment_intent_id': paymentIntentId,
          'payment_method_id': paymentMethodId,
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to confirm payment: $e');
    }
  }
}
