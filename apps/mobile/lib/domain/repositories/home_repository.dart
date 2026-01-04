import '../entities/health_data.dart';

/// 홈 레포지토리 인터페이스
abstract class HomeRepository {
  /// 대시보드 데이터 로드
  Future<DashboardData> loadDashboardData(String userId);

  /// 건강 점수 조회
  Future<HealthScore> getHealthScore(String userId);

  /// 환경 데이터 조회
  Future<EnvironmentData> getEnvironmentData(String userId);

  /// 추세 데이터 조회
  Future<List<TrendData>> getTrendData(String userId);

  /// AI 인사이트 조회
  Future<List<AIInsight>> getAIInsights(String userId);

  /// 대시보드 데이터 새로고침
  Future<DashboardData> refreshDashboardData(String userId);
}

/// 데이터 허브 레포지토리 인터페이스
abstract class DataHubRepository {
  /// 추세 데이터 조회
  Future<List<TrendData>> getTrendData({
    required String userId,
    required String dataType,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// 리포트 생성
  Future<String> generateReport({
    required String userId,
    required String reportType,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// 데이터 내보내기
  Future<String> exportData({
    required String userId,
    required String format,  // pdf, csv, json
    required List<String> dataTypes,
  });

  /// 데이터 공유
  Future<void> shareData({
    required String userId,
    required String targetUserId,
    required List<String> dataTypes,
    required DateTime expiresAt,
  });

  /// 공유된 데이터 조회
  Future<List<DashboardData>> getSharedData(String userId);
}
