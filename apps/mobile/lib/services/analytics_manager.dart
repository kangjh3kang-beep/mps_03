import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../config/mvp_config.dart';

/// Firebase Analytics 및 A/B 테스팅 관리자
class AnalyticsManager {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  late String _userVariant; // 사용자에게 할당된 테스트 변형

  Future<void> init() async {
    // Firebase Remote Config 초기화
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    // 기본값 설정
    await _remoteConfig.setDefaults({
      // A/B 테스트 설정
      'coaching_ui_variant': 'control',
      'onboarding_flow': 'simple',
      'api_cache_duration': 3600,
      'enable_offline_mode': true,
      'enable_ab_testing': true,
    });

    // 원격 설정 가져오기
    await _remoteConfig.fetchAndActivate();

    // 사용자 변형 할당
    _assignUserVariant();
  }

  // ===== A/B 테스팅 =====

  void _assignUserVariant() {
    // Firebase Remote Config에서 현재 테스트 설정 조회
    final coachingVariant = _remoteConfig.getString('coaching_ui_variant');
    _userVariant = coachingVariant.isNotEmpty ? coachingVariant : 'control';

    // 사용자 속성 설정
    _analytics.setUserProperty(
      name: 'ab_test_variant',
      value: _userVariant,
    );
  }

  /// 현재 사용자의 A/B 테스트 변형 조회
  String getUserVariant() => _userVariant;

  /// 특정 A/B 테스트의 변형 조회
  String getTestVariant(String testName) {
    final key = testName.replaceAll('_', '_variant_');
    return _remoteConfig.getString(key);
  }

  // ===== 이벤트 추적 =====

  /// 앱 오픈 이벤트
  Future<void> logAppOpen() async {
    await _analytics.logAppOpen();
    await _trackEvent('app_open', {
      'variant': _userVariant,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// 측정 완료 이벤트
  Future<void> logMeasurementCompleted({
    required String measurementType,
    required double value,
    required int durationSeconds,
  }) async {
    await _trackEvent('measurement_completed', {
      'measurement_type': measurementType,
      'value': value,
      'duration_seconds': durationSeconds,
      'variant': _userVariant,
    });
  }

  /// 코칭 수행 이벤트
  Future<void> logCoachingFollowed({
    required String recommendationType,
    required String category,
  }) async {
    await _trackEvent('coaching_followed', {
      'recommendation_type': recommendationType,
      'category': category,
      'variant': _userVariant,
    });
  }

  /// 데이터 조회 이벤트
  Future<void> logDataViewed({
    required String dataType,
    required String period,
  }) async {
    await _trackEvent('data_viewed', {
      'data_type': dataType,
      'period': period,
      'variant': _userVariant,
    });
  }

  /// 소셜 공유 이벤트
  Future<void> logSocialShare({
    required String contentType,
    required String method,
  }) async {
    await _analytics.logShare(
      contentType: contentType,
      itemId: '',
      method: method,
    );
  }

  /// 구매 이벤트
  Future<void> logPurchase({
    required String productId,
    required double value,
    required String currency,
  }) async {
    await _analytics.logPurchase(
      value: value,
      currency: currency,
      transactionId: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      items: [
        AnalyticsEventItem(
          itemId: productId,
          itemName: productId,
          value: value,
        ),
      ],
    );
  }

  /// 화면 이동 이벤트
  Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  /// 커스텀 이벤트
  Future<void> _trackEvent(String eventName, Map<String, dynamic> parameters) async {
    try {
      await _analytics.logEvent(
        name: eventName,
        parameters: _sanitizeParameters(parameters),
      );
    } catch (e) {
      print('[Analytics] 이벤트 기록 실패: $eventName, $e');
    }
  }

  /// 매개변수 정제 (Firebase 제한에 따라)
  Map<String, Object> _sanitizeParameters(Map<String, dynamic> params) {
    final sanitized = <String, Object>{};
    params.forEach((key, value) {
      if (value == null) return;

      // Firebase 제한: 문자열 최대 100자
      if (value is String) {
        sanitized[key] = value.length > 100 ? value.substring(0, 100) : value;
      } else if (value is num) {
        sanitized[key] = value;
      } else if (value is bool) {
        sanitized[key] = value;
      } else {
        sanitized[key] = value.toString();
      }
    });
    return sanitized;
  }

  // ===== 사용자 세그멘테이션 =====

  /// 사용자를 세그먼트에 할당
  Future<void> setUserSegment(String segmentName) async {
    await _analytics.setUserProperty(
      name: 'user_segment',
      value: segmentName,
    );
  }

  /// 사용자 ID 설정
  Future<void> setUserId(String userId) async {
    await _analytics.setUserId(userId);
  }

  /// 사용자 속성 설정
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  // ===== 분석 쿼리 =====

  /// 사용자 구성 분석
  Map<String, dynamic> getUserDemographics() {
    return {
      'currentVariant': _userVariant,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// 코칭 효과 측정 (A/B 테스트 메트릭)
  Future<Map<String, dynamic>> getCoachingMetrics() async {
    return {
      'testName': 'coaching_ui_variant',
      'variant': _userVariant,
      'expectedMetric': 'coaching_completion_rate',
      'targetLift': '15%',
      'trackingStarted': true,
    };
  }
}

/// 성능 모니터링 및 최적화
class PerformanceMonitor {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// 화면 로딩 시간 측정
  Future<void> logScreenLoadTime(
    String screenName,
    Duration loadTime,
  ) async {
    await _analytics.logEvent(
      name: 'screen_load_time',
      parameters: {
        'screen_name': screenName,
        'load_time_ms': loadTime.inMilliseconds,
        'is_slow': loadTime.inMilliseconds > 1000,
      },
    );
  }

  /// API 응답 시간 추적
  Future<void> logApiResponseTime(
    String endpoint,
    Duration responseTime,
  ) async {
    final isSlow = responseTime.inMilliseconds > 200;
    if (isSlow) {
      await _analytics.logEvent(
        name: 'slow_api_response',
        parameters: {
          'endpoint': endpoint,
          'response_time_ms': responseTime.inMilliseconds,
        },
      );
    }
  }

  /// 메모리 사용량 추적
  Future<void> logMemoryUsage(int memoryMB) async {
    if (memoryMB > 200) {
      // 200MB 초과 시에만 기록
      await _analytics.logEvent(
        name: 'high_memory_usage',
        parameters: {
          'memory_mb': memoryMB,
        },
      );
    }
  }

  /// 배터리 소비 추적
  Future<void> logBatteryDrain(int drainPercent) async {
    if (drainPercent > 10) {
      // 10% 이상 소비 시에만 기록
      await _analytics.logEvent(
        name: 'high_battery_drain',
        parameters: {
          'drain_percent': drainPercent,
        },
      );
    }
  }
}

/// 코칭 효과 검증 (A/B 테스트 결과)
class CoachingEffectValidator {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// 코칭 완료율 측정
  Future<void> trackCoachingCompletion({
    required String coachingType,
    required bool completed,
    required int durationMinutes,
  }) async {
    await _analytics.logEvent(
      name: 'coaching_completion',
      parameters: {
        'coaching_type': coachingType,
        'completed': completed,
        'duration_minutes': durationMinutes,
      },
    );
  }

  /// 건강 지표 개선 측정
  Future<void> trackHealthMetricImprovement({
    required String metricType,
    required double initialValue,
    required double currentValue,
    required int daysTracked,
  }) async {
    final improvement = ((currentValue - initialValue) / initialValue * 100).toStringAsFixed(1);

    await _analytics.logEvent(
      name: 'health_metric_improvement',
      parameters: {
        'metric_type': metricType,
        'initial_value': initialValue,
        'current_value': currentValue,
        'improvement_percent': improvement,
        'days_tracked': daysTracked,
      },
    );
  }

  /// 사용자 만족도 조사
  Future<void> trackUserSatisfaction({
    required String feature,
    required int rating, // 1-5
    required String feedback,
  }) async {
    await _analytics.logEvent(
      name: 'user_satisfaction',
      parameters: {
        'feature': feature,
        'rating': rating,
        'feedback': feedback.length > 100 ? feedback.substring(0, 100) : feedback,
      },
    );
  }

  /// 코칭 권장사항 실행율
  Future<void> trackRecommendationAdherence({
    required String recommendationType,
    required bool followed,
    required int followDays,
  }) async {
    await _analytics.logEvent(
      name: 'recommendation_adherence',
      parameters: {
        'recommendation_type': recommendationType,
        'followed': followed,
        'follow_days': followDays,
      },
    );
  }
}

/// 에러 추적 및 보고
class ErrorTracker {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// 측정 오류 기록
  Future<void> logMeasurementError({
    required String errorType,
    required String errorMessage,
    required String measurementType,
  }) async {
    await _analytics.logEvent(
      name: 'measurement_error',
      parameters: {
        'error_type': errorType,
        'error_message': errorMessage.length > 100
            ? errorMessage.substring(0, 100)
            : errorMessage,
        'measurement_type': measurementType,
      },
    );
  }

  /// 오프라인 모드 오류
  Future<void> logOfflineSyncError({
    required String dataType,
    required String errorMessage,
  }) async {
    await _analytics.logEvent(
      name: 'offline_sync_error',
      parameters: {
        'data_type': dataType,
        'error_message':
            errorMessage.length > 100 ? errorMessage.substring(0, 100) : errorMessage,
      },
    );
  }

  /// API 오류
  Future<void> logApiError({
    required String endpoint,
    required int statusCode,
    required String errorMessage,
  }) async {
    await _analytics.logEvent(
      name: 'api_error',
      parameters: {
        'endpoint': endpoint,
        'status_code': statusCode,
        'error_message':
            errorMessage.length > 100 ? errorMessage.substring(0, 100) : errorMessage,
      },
    );
  }
}
