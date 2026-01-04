import '../entities/health_data.dart';

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

  /// 상관관계 분석
  Future<Map<String, dynamic>> getCorrelationAnalysis({
    required String userId,
    required List<String> dataTypes,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// 예측 분석
  Future<List<TrendPoint>> getPrediction({
    required String userId,
    required String dataType,
    required int daysAhead,
  });
}
