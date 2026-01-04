import 'package:dio/dio.dart';

class TranslationService {
  final Dio _dio;

  TranslationService(this._dio);

  Future<String> translate({
    required String text,
    required String targetLanguage,
    String sourceLanguage = 'auto',
  }) async {
    try {
      final response = await _dio.post(
        '/translation/translate',
        data: {
          'text': text,
          'source_language': sourceLanguage,
          'target_language': targetLanguage,
        },
      );
      return response.data['translated_text'] ?? text;
    } catch (e) {
      return text;
    }
  }
}
