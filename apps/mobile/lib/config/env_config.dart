/// 환경 설정
/// 기획안: 개발/스테이징/프로덕션 환경 분리
class EnvConfig {
  // ============================================
  // Supabase 설정
  // ============================================
  
  /// Supabase 프로젝트 URL
  /// 설정 방법: Supabase Dashboard > Settings > API > Project URL
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-project-id.supabase.co',
  );
  
  /// Supabase Anonymous Key
  /// 설정 방법: Supabase Dashboard > Settings > API > anon public
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'your-supabase-anon-key',
  );
  
  /// Supabase Service Role Key (백엔드용, 앱에서는 사용하지 않음)
  static const String supabaseServiceKey = String.fromEnvironment(
    'SUPABASE_SERVICE_KEY',
    defaultValue: '',
  );

  // ============================================
  // Agora RTC 설정
  // ============================================
  
  /// Agora App ID
  /// 설정 방법: Agora Console > Project Management > App ID
  static const String agoraAppId = String.fromEnvironment(
    'AGORA_APP_ID',
    defaultValue: 'your-agora-app-id',
  );
  
  /// Agora App Certificate (토큰 생성에 필요)
  /// 설정 방법: Agora Console > Project Management > App Certificate
  static const String agoraAppCertificate = String.fromEnvironment(
    'AGORA_APP_CERTIFICATE',
    defaultValue: '',
  );

  // ============================================
  // AI 서비스 설정
  // ============================================
  
  /// AI 서비스 URL
  static const String aiServiceUrl = String.fromEnvironment(
    'AI_SERVICE_URL',
    defaultValue: 'http://localhost:8000',
  );
  
  /// AI 서비스 API Key
  static const String aiServiceApiKey = String.fromEnvironment(
    'AI_SERVICE_API_KEY',
    defaultValue: '',
  );

  // ============================================
  // Firebase 설정 (푸시 알림용)
  // ============================================
  
  /// Firebase 프로젝트 설정은 google-services.json (Android)
  /// 및 GoogleService-Info.plist (iOS)에서 관리

  // ============================================
  // 앱 설정
  // ============================================
  
  /// 환경 모드
  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'development',
  );
  
  /// 개발 환경 여부
  static bool get isDevelopment => environment == 'development';
  
  /// 스테이징 환경 여부
  static bool get isStaging => environment == 'staging';
  
  /// 프로덕션 환경 여부
  static bool get isProduction => environment == 'production';

  /// API 기본 URL
  static String get apiBaseUrl {
    switch (environment) {
      case 'production':
        return 'https://api.manpasik.com';
      case 'staging':
        return 'https://api-staging.manpasik.com';
      default:
        return 'http://localhost:3000';
    }
  }

  /// 디버그 모드 활성화
  static bool get enableDebugMode => isDevelopment;

  /// 로깅 활성화
  static bool get enableLogging => !isProduction;

  /// 분석 활성화
  static bool get enableAnalytics => isProduction || isStaging;

  // ============================================
  // 기능 플래그
  // ============================================

  /// 화상진료 기능 활성화
  static const bool enableTelemedicine = bool.fromEnvironment(
    'ENABLE_TELEMEDICINE',
    defaultValue: true,
  );

  /// 글로벌 채팅 기능 활성화
  static const bool enableGlobalChat = bool.fromEnvironment(
    'ENABLE_GLOBAL_CHAT',
    defaultValue: true,
  );

  /// AI 코치 기능 활성화
  static const bool enableAICoach = bool.fromEnvironment(
    'ENABLE_AI_COACH',
    defaultValue: true,
  );

  /// 오프라인 모드 지원
  static const bool enableOfflineMode = bool.fromEnvironment(
    'ENABLE_OFFLINE_MODE',
    defaultValue: true,
  );

  // ============================================
  // 검증
  // ============================================

  /// 필수 설정 검증
  static bool validateConfig() {
    final errors = <String>[];

    if (supabaseUrl.contains('your-project-id')) {
      errors.add('SUPABASE_URL이 설정되지 않았습니다');
    }

    if (supabaseAnonKey.contains('your-supabase')) {
      errors.add('SUPABASE_ANON_KEY가 설정되지 않았습니다');
    }

    if (enableTelemedicine && agoraAppId.contains('your-agora')) {
      errors.add('화상진료 기능에 AGORA_APP_ID가 필요합니다');
    }

    if (errors.isNotEmpty) {
      print('[EnvConfig] 설정 오류:');
      for (final error in errors) {
        print('  - $error');
      }
      return false;
    }

    print('[EnvConfig] 모든 설정이 유효합니다');
    return true;
  }

  /// 설정 정보 출력 (디버깅용)
  static void printConfig() {
    if (!enableLogging) return;

    print('=== EnvConfig ===');
    print('Environment: $environment');
    print('API Base URL: $apiBaseUrl');
    print('Supabase URL: ${supabaseUrl.substring(0, 30)}...');
    print('Agora App ID: ${agoraAppId.substring(0, 10)}...');
    print('AI Service URL: $aiServiceUrl');
    print('Features:');
    print('  - Telemedicine: $enableTelemedicine');
    print('  - Global Chat: $enableGlobalChat');
    print('  - AI Coach: $enableAICoach');
    print('  - Offline Mode: $enableOfflineMode');
    print('=================');
  }
}
