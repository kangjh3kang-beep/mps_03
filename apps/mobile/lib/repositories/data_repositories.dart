import 'package:hive/hive.dart';
import '../config/mvp_config.dart';
import '../models/measurement_model.dart';

import '../services/offline_mode_manager.dart';
import '../services/http_client_service.dart';

/// 홈 화면 데이터 저장소
class HomeRepository {
  final OfflineModeManager _offlineManager;
  final HttpClientService _httpClient;
  late Box<Map> _homeCache;

  HomeRepository({
    required OfflineModeManager offlineManager,
    required HttpClientService httpClient,
  })  : _offlineManager = offlineManager,
        _httpClient = httpClient;

  Future<void> init() async {
    _homeCache = await Hive.openBox<Map>('home_cache');
  }

  /// 사용자 건강 점수 조회
  Future<HealthScore> getHealthScore(String userId) async {
    // 오프라인 모드 확인
    if (!_offlineManager.isOnline) {
      final cached = await _offlineManager.getOfflineData('health_score_$userId');
      if (cached != null) {
        return HealthScore.fromJson(cached);
      }
    }

    try {
      final response = await _httpClient.get('/api/health/score/$userId');
      final healthScore = HealthScore.fromJson(response);

      // 캐시에 저장
      await _offlineManager.saveOfflineData(
        'health_score_$userId',
        response,
      );

      return healthScore;
    } catch (e) {
      // 오프라인 폴백
      final cached = await _offlineManager.getOfflineData('health_score_$userId');
      if (cached != null) {
        return HealthScore.fromJson(cached);
      }
      rethrow;
    }
  }

  /// 최근 측정 데이터 조회
  Future<List<MeasurementData>> getRecentMeasurements(String userId, {int limit = 10}) async {
    if (!_offlineManager.isOnline) {
      final cached = await _offlineManager.getOfflineData('recent_measurements_$userId');
      if (cached is List) {
        return cached.map((m) => MeasurementData.fromJson(m)).toList();
      }
      return [];
    }

    try {
      final response = await _httpClient.get(
        '/api/measurements/$userId',
        queryParameters: {'limit': limit},
      );

      final measurements = (response as List)
          .map((m) => MeasurementData.fromJson(m))
          .toList();

      // 캐시
      await _offlineManager.saveOfflineData(
        'recent_measurements_$userId',
        response,
      );

      return measurements;
    } catch (e) {
      final cached = await _offlineManager.getOfflineData('recent_measurements_$userId');
      if (cached is List) {
        return cached.map((m) => MeasurementData.fromJson(m)).toList();
      }
      return [];
    }
  }

  /// 환경 정보 조회
  Future<EnvironmentInfo> getEnvironmentInfo() async {
    if (!_offlineManager.isOnline) {
      final cached = await _offlineManager.getOfflineData('environment_info');
      if (cached != null) {
        return EnvironmentInfo.fromJson(cached);
      }
    }

    try {
      final response = await _httpClient.get('/api/environment/current');
      final envInfo = EnvironmentInfo.fromJson(response);

      await _offlineManager.saveOfflineData('environment_info', response);
      return envInfo;
    } catch (e) {
      final cached = await _offlineManager.getOfflineData('environment_info');
      if (cached != null) {
        return EnvironmentInfo.fromJson(cached);
      }
      return EnvironmentInfo.empty();
    }
  }

  /// 데이터 새로고침
  Future<void> refreshHomeData(String userId) async {
    if (_offlineManager.isOnline) {
      await Future.wait([
        getHealthScore(userId),
        getRecentMeasurements(userId),
        getEnvironmentInfo(),
      ]);
    }
  }
}

/// 측정 데이터 저장소
class MeasurementRepository {
  final OfflineModeManager _offlineManager;
  final HttpClientService _httpClient;

  MeasurementRepository({
    required OfflineModeManager offlineManager,
    required HttpClientService httpClient,
  })  : _offlineManager = offlineManager,
        _httpClient = httpClient;

  /// 측정 데이터 저장
  Future<MeasurementData> saveMeasurement(MeasurementData measurement) async {
    // 오프라인 모드면 큐에 추가
    if (!_offlineManager.isOnline) {
      await _offlineManager.saveOfflineData(
        'measurement_${measurement.id}',
        measurement.toJson(),
        syncRequired: true,
      );
      return measurement;
    }

    try {
      final response = await _httpClient.post(
        '/api/measurements',
        data: measurement.toJson(),
      );

      final savedMeasurement = MeasurementData.fromJson(response);

      // 로컬 저장
      await _offlineManager.saveOfflineData(
        'measurement_${savedMeasurement.id}',
        response,
      );

      return savedMeasurement;
    } catch (e) {
      // 실패하면 큐에 추가
      await _offlineManager.saveOfflineData(
        'measurement_${measurement.id}',
        measurement.toJson(),
        syncRequired: true,
      );
      rethrow;
    }
  }

  /// 측정 데이터 조회
  Future<MeasurementData?> getMeasurement(String measurementId) async {
    final cached = await _offlineManager.getOfflineData('measurement_$measurementId');
    if (cached != null) {
      return MeasurementData.fromJson(cached);
    }

    if (!_offlineManager.isOnline) {
      return null;
    }

    try {
      final response = await _httpClient.get('/api/measurements/$measurementId');
      final measurement = MeasurementData.fromJson(response);

      await _offlineManager.saveOfflineData(
        'measurement_$measurementId',
        response,
      );

      return measurement;
    } catch (e) {
      return null;
    }
  }

  /// 측정 이력 조회
  Future<List<MeasurementData>> getMeasurementHistory(
    String userId, {
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final cacheKey = 'measurements_history_${userId}_${startDate.toIso8601String()}';
    final cached = await _offlineManager.getOfflineData(cacheKey);

    if (cached is List && !_offlineManager.isOnline) {
      return cached.map((m) => MeasurementData.fromJson(m)).toList();
    }

    try {
      final response = await _httpClient.get(
        '/api/measurements/history/$userId',
        queryParameters: {
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
        },
      );

      final measurements = (response as List)
          .map((m) => MeasurementData.fromJson(m))
          .toList();

      await _offlineManager.saveOfflineData(cacheKey, response);

      return measurements;
    } catch (e) {
      if (cached is List) {
        return cached.map((m) => MeasurementData.fromJson(m)).toList();
      }
      return [];
    }
  }

  /// 동기화 필요한 측정 데이터 조회
  Future<List<MeasurementData>> getUnsyncedMeasurements() async {
    final unsynced = await _offlineManager.getUnsyncedData();
    return unsynced
        .where((data) => data['type'] == 'measurement')
        .map((data) => MeasurementData.fromJson(data['data']))
        .toList();
  }
}

/// 데이터 허브 저장소
class DataHubRepository {
  final OfflineModeManager _offlineManager;
  final HttpClientService _httpClient;

  DataHubRepository({
    required OfflineModeManager offlineManager,
    required HttpClientService httpClient,
  })  : _offlineManager = offlineManager,
        _httpClient = httpClient;

  /// 트렌드 데이터 조회
  Future<TrendData> getTrendData(
    String userId, {
    required String metricType,
    required int daysBack,
  }) async {
    final cacheKey = 'trend_${userId}_${metricType}_${daysBack}d';
    final cached = await _offlineManager.getOfflineData(cacheKey);

    if (cached != null && !_offlineManager.isOnline) {
      return TrendData.fromJson(cached);
    }

    try {
      final response = await _httpClient.get(
        '/api/trends/$userId',
        queryParameters: {
          'metric': metricType,
          'days': daysBack,
        },
      );

      final trendData = TrendData.fromJson(response);
      await _offlineManager.saveOfflineData(cacheKey, response);
      return trendData;
    } catch (e) {
      if (cached != null) {
        return TrendData.fromJson(cached);
      }
      return TrendData.empty();
    }
  }

  /// 상관관계 분석
  Future<CorrelationData> getCorrelationAnalysis(
    String userId, {
    required String metric1,
    required String metric2,
  }) async {
    final cacheKey = 'correlation_${userId}_${metric1}_${metric2}';
    final cached = await _offlineManager.getOfflineData(cacheKey);

    if (cached != null && !_offlineManager.isOnline) {
      return CorrelationData.fromJson(cached);
    }

    try {
      final response = await _httpClient.get(
        '/api/correlations/$userId',
        queryParameters: {
          'metric1': metric1,
          'metric2': metric2,
        },
      );

      final correlationData = CorrelationData.fromJson(response);
      await _offlineManager.saveOfflineData(cacheKey, response);
      return correlationData;
    } catch (e) {
      if (cached != null) {
        return CorrelationData.fromJson(cached);
      }
      return CorrelationData.empty();
    }
  }

  /// 보고서 생성
  Future<ReportData> generateReport(
    String userId, {
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _httpClient.post(
        '/api/reports/generate',
        data: {
          'userId': userId,
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
        },
      );

      final reportData = ReportData.fromJson(response);
      return reportData;
    } catch (e) {
      // 보고서 생성 실패 - 캐시된 데이터로 구성
      final measurements = await _offlineManager.getOfflineData('recent_measurements_$userId');
      return ReportData.fromMeasurements(measurements ?? []);
    }
  }

  /// 외부 서비스와 동기화
  Future<void> syncWithExternalService(
    String userId, {
    required String serviceName,
    required Map<String, dynamic> credentials,
  }) async {
    await _offlineManager.saveOfflineData(
      'sync_external_${userId}_$serviceName',
      {
        'serviceName': serviceName,
        'credentials': credentials,
        'timestamp': DateTime.now().toIso8601String(),
      },
      syncRequired: true,
    );

    if (!_offlineManager.isOnline) {
      return;
    }

    try {
      await _httpClient.post(
        '/api/external-sync',
        data: {
          'userId': userId,
          'serviceName': serviceName,
          'credentials': credentials,
        },
      );
    } catch (e) {
      // 큐에 이미 추가됨
      rethrow;
    }
  }

  /// 가족 멤버 데이터 조회
  Future<List<FamilyMemberData>> getFamilyMembersData(String userId) async {
    final cacheKey = 'family_members_$userId';
    final cached = await _offlineManager.getOfflineData(cacheKey);

    if (cached is List && !_offlineManager.isOnline) {
      return cached.map((m) => FamilyMemberData.fromJson(m)).toList();
    }

    try {
      final response = await _httpClient.get('/api/family/$userId');
      final familyMembers = (response as List)
          .map((m) => FamilyMemberData.fromJson(m))
          .toList();

      await _offlineManager.saveOfflineData(cacheKey, response);
      return familyMembers;
    } catch (e) {
      if (cached is List) {
        return cached.map((m) => FamilyMemberData.fromJson(m)).toList();
      }
      return [];
    }
  }
}

// ===== 모델 클래스 =====

class HealthScore {
  final int score;
  final String status;
  final String category;
  final DateTime lastUpdated;

  HealthScore({
    required this.score,
    required this.status,
    required this.category,
    required this.lastUpdated,
  });

  factory HealthScore.fromJson(Map<String, dynamic> json) {
    return HealthScore(
      score: json['score'] ?? 0,
      status: json['status'] ?? 'normal',
      category: json['category'] ?? 'general',
      lastUpdated: DateTime.parse(json['lastUpdated'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
        'score': score,
        'status': status,
        'category': category,
        'lastUpdated': lastUpdated.toIso8601String(),
      };
}

class EnvironmentInfo {
  final double temperature;
  final double humidity;
  final int airQuality;
  final String lightLevel;

  EnvironmentInfo({
    required this.temperature,
    required this.humidity,
    required this.airQuality,
    required this.lightLevel,
  });

  factory EnvironmentInfo.empty() {
    return EnvironmentInfo(
      temperature: 0,
      humidity: 0,
      airQuality: 0,
      lightLevel: 'unknown',
    );
  }

  factory EnvironmentInfo.fromJson(Map<String, dynamic> json) {
    return EnvironmentInfo(
      temperature: (json['temperature'] ?? 0).toDouble(),
      humidity: (json['humidity'] ?? 0).toDouble(),
      airQuality: json['airQuality'] ?? 0,
      lightLevel: json['lightLevel'] ?? 'unknown',
    );
  }

  Map<String, dynamic> toJson() => {
        'temperature': temperature,
        'humidity': humidity,
        'airQuality': airQuality,
        'lightLevel': lightLevel,
      };
}

class TrendData {
  final List<double> values;
  final List<DateTime> timestamps;
  final double average;
  final double trend;

  TrendData({
    required this.values,
    required this.timestamps,
    required this.average,
    required this.trend,
  });

  factory TrendData.empty() {
    return TrendData(
      values: [],
      timestamps: [],
      average: 0,
      trend: 0,
    );
  }

  factory TrendData.fromJson(Map<String, dynamic> json) {
    final values = (json['values'] as List?)?.cast<double>() ?? [];
    final timestamps = (json['timestamps'] as List?)
            ?.map((t) => DateTime.parse(t))
            .toList() ??
        [];

    return TrendData(
      values: values,
      timestamps: timestamps,
      average: (json['average'] ?? 0).toDouble(),
      trend: (json['trend'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'values': values,
        'timestamps': timestamps.map((t) => t.toIso8601String()).toList(),
        'average': average,
        'trend': trend,
      };
}

class CorrelationData {
  final String metric1;
  final String metric2;
  final double correlationCoefficient;
  final String correlation;

  CorrelationData({
    required this.metric1,
    required this.metric2,
    required this.correlationCoefficient,
    required this.correlation,
  });

  factory CorrelationData.empty() {
    return CorrelationData(
      metric1: '',
      metric2: '',
      correlationCoefficient: 0,
      correlation: 'none',
    );
  }

  factory CorrelationData.fromJson(Map<String, dynamic> json) {
    return CorrelationData(
      metric1: json['metric1'] ?? '',
      metric2: json['metric2'] ?? '',
      correlationCoefficient: (json['correlationCoefficient'] ?? 0).toDouble(),
      correlation: json['correlation'] ?? 'none',
    );
  }

  Map<String, dynamic> toJson() => {
        'metric1': metric1,
        'metric2': metric2,
        'correlationCoefficient': correlationCoefficient,
        'correlation': correlation,
      };
}

class ReportData {
  final String reportId;
  final DateTime generatedAt;
  final Map<String, dynamic> summary;
  final List<Map<String, dynamic>> details;

  ReportData({
    required this.reportId,
    required this.generatedAt,
    required this.summary,
    required this.details,
  });

  factory ReportData.fromMeasurements(List<dynamic> measurements) {
    return ReportData(
      reportId: 'report_${DateTime.now().millisecondsSinceEpoch}',
      generatedAt: DateTime.now(),
      summary: {'measurementCount': measurements.length},
      details: [],
    );
  }

  factory ReportData.fromJson(Map<String, dynamic> json) {
    return ReportData(
      reportId: json['reportId'] ?? '',
      generatedAt: DateTime.parse(json['generatedAt'] ?? DateTime.now().toIso8601String()),
      summary: json['summary'] ?? {},
      details: (json['details'] as List?)?.cast<Map<String, dynamic>>() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'reportId': reportId,
        'generatedAt': generatedAt.toIso8601String(),
        'summary': summary,
        'details': details,
      };
}

class FamilyMemberData {
  final String memberId;
  final String name;
  final String relationship;
  final String medicalId;

  FamilyMemberData({
    required this.memberId,
    required this.name,
    required this.relationship,
    required this.medicalId,
  });

  factory FamilyMemberData.fromJson(Map<String, dynamic> json) {
    return FamilyMemberData(
      memberId: json['memberId'] ?? '',
      name: json['name'] ?? '',
      relationship: json['relationship'] ?? '',
      medicalId: json['medicalId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'memberId': memberId,
        'name': name,
        'relationship': relationship,
        'medicalId': medicalId,
      };
}
