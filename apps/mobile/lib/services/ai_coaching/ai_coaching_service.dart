import 'package:dio/dio.dart';

class AICoachingService {
  final Dio _dio;
  final String _baseUrl;

  AICoachingService(this._dio, this._baseUrl);

  Future<Map<String, dynamic>> generateHealthInsight({
    required List<Map<String, dynamic>> measurements,
    required Map<String, dynamic> profile,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/api/v1/coaching/health-insight',
        data: {
          'measurements': measurements,
          'profile': profile,
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to generate health insight: $e');
    }
  }

  Future<Map<String, dynamic>> chat({
    required String message,
    required List<Map<String, dynamic>> history,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/api/v1/coaching/chat',
        data: {
          'message': message,
          'history': history,
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to chat with AI: $e');
    }
  }
}
