import 'package:injectable/injectable.dart';

@singleton
class TranslationService {
  // 실시간 텍스트/음성 번역 (Google Translate API 연동 가정)
  Future<String> translate(String text, String targetLanguage) async {
    // TODO: Google Cloud Translation API 연동
    return "Translated: $text to $targetLanguage";
  }
}
