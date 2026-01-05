/// API Gateway 서버 설정
/// 
/// 이 파일은 API Gateway를 통한 백엔드 연결 설정을 관리합니다.
/// 모든 API 요청은 API Gateway(포트 8080)를 통해 라우팅됩니다.

class ApiConfig {
  /// API 서버 기본 주소
  /// 
  /// 개발: http://localhost:8080 (API Gateway)
  /// 스테이징: https://staging-api.manpasik.com
  /// 프로덕션: https://api.manpasik.com (실제 서버)
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );
  
  /// API 버전 접두사
  static const String apiPrefix = '/api/v1';

  /// 전체 API URL 생성
  /// endpoint가 /api/v1로 시작하지 않으면 자동으로 접두사 추가
  static String getApiUrl(String endpoint) {
    if (endpoint.startsWith('/api/')) {
      return '$baseUrl$endpoint';
    }
    return '$baseUrl$apiPrefix$endpoint';
  }

  /// API 타임아웃 설정 (밀리초)
  static const int connectionTimeoutMs = 10000;
  static const int receiveTimeoutMs = 10000;

  /// HTTP 헤더 기본값
  static Map<String, String> getDefaultHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'User-Agent': 'Manpasik-Mobile/1.0.0',
    };
  }

  /// API 환경 설정
  static enum Environment {
    development, // Mock 서버
    staging,     // 스테이징 서버
    production,  // 프로덕션 서버
  }

  /// 현재 환경 (기본값: development)
  static const Environment currentEnvironment = Environment.development;

  /// 환경별 API 기본 주소
  static String getBaseUrlForEnvironment(Environment env) {
    switch (env) {
      case Environment.development:
        return 'http://localhost:8080';  // API Gateway
      case Environment.staging:
        return 'https://staging-api.manpasik.com';
      case Environment.production:
        return 'https://api.manpasik.com';
    }
  }

  /// Mock 서버 상태 확인
  /// 
  /// 개발 환경에서 Mock API 서버가 정상 작동하는지 확인합니다.
  static Future<bool> isHealthy() async {
    try {
      // TODO: HttpClientService를 사용하여 /health 엔드포인트 호출
      return true;
    } catch (e) {
      print('[ApiConfig] Health check failed: $e');
      return false;
    }
  }
}
