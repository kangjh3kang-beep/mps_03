/// MVP 모드 설정 및 기능 플래그
/// 
/// 과도한 스코프 문제 해결:
/// - MVP (최소 기능 제품): 기본 측정 + 홈 화면만 활성화
/// - Full: 모든 기능 활성화
class MVPConfig {
  /// MVP 모드 활성화 여부 (기본값: true)
  /// - true: 측정 + 홈 + 데이터 분석만 활성화 (150 경로 → 30 경로)
  /// - false: 모든 기능 활성화
  static const bool enableMVPMode = true;

  /// 활성화할 기능들
  static const Features enabledFeatures = Features(
    // Phase 1: 핵심 기능
    measurement: true, // 5단계 측정 프로세스
    home: true, // 대시보드
    auth: true, // 인증

    // Phase 2: 데이터 분석 (MVP에서 포함)
    dataHub: true, // 트렌드 분석만

    // Phase 2+: 선택적 기능 (MVP에서는 비활성화)
    coaching: false, // AI 코칭 (ML은 2차)
    marketplace: false, // 마켓플레이스
    telemedicine: false, // 원격진료
    community: false, // 커뮤니티
    settings: true, // 기본 설정만

    // 기술 지원 기능
    offlineMode: true, // Hive 기반 오프라인
    analyticsTracking: true, // Firebase Analytics
    abTesting: false, // A/B 테스팅 (2차)
  );

  /// 백엔드 간단화
  static const BackendConfig backendConfig = BackendConfig(
    // MVP: 단순한 REST API만
    useGRPC: false,
    useWebSocket: false,
    mockBackend: true, // 개발 단계에서는 모의 백엔드 사용

    // 서비스 수 축소: 9개 → 3개
    enabledMicroservices: ['auth', 'measurement', 'ai-simple'],
  );

  /// 펌웨어 시뮬레이션 모드 (실제 하드웨어 없이 개발)
  static const HardwareConfig hardwareConfig = HardwareConfig(
    // 실제 STM32 대신 시뮬레이션
    simulateNFC: true, // NFC 모킹
    simulateBLE: true, // BLE 모킹
    simulateADC: true, // 24비트 ADC 시뮬레이션
    mockMeasurementData: true, // 실제 측정값 대신 모의 데이터
  );

  /// AI 모델 간단화 (규칙 기반 → ML은 2차)
  static const AIConfig aiConfig = AIConfig(
    useRuleBasedCoaching: true, // 초기: 규칙 기반
    useMLPrediction: false, // 2차: ML 예측
    enableAdvancedAnalysis: false, // 고급 분석 비활성화
    cacheAIPredictions: true, // 성능 최적화
  );
}

/// 활성화할 기능 정의
class Features {
  final bool measurement;
  final bool home;
  final bool auth;
  final bool dataHub;
  final bool coaching;
  final bool marketplace;
  final bool telemedicine;
  final bool community;
  final bool settings;
  final bool offlineMode;
  final bool analyticsTracking;
  final bool abTesting;

  const Features({
    required this.measurement,
    required this.home,
    required this.auth,
    required this.dataHub,
    required this.coaching,
    required this.marketplace,
    required this.telemedicine,
    required this.community,
    required this.settings,
    required this.offlineMode,
    required this.analyticsTracking,
    required this.abTesting,
  });

  /// MVP 모드의 라우팅 경로 수: 150+ → 30
  List<String> getMVPRoutes() {
    final routes = [
      '/splash',
      '/login',
      '/signup',
      '/home',
      '/measurement',
      '/measurement/process/:type',
      '/data-hub',
      '/data-hub/trend',
      '/data-hub/correlation',
      '/data-hub/report',
      '/settings',
      '/settings/profile',
      '/settings/notifications',
      '/settings/privacy',
      // 추가 기본 라우트만
    ];
    return routes;
  }

  /// 전체 기능의 라우팅 경로 수: 150+
  List<String> getFullRoutes() {
    return getMVPRoutes() +
        [
          // Coaching (25+)
          '/ai-coach',
          '/ai-coach/exercise',
          '/ai-coach/nutrition',
          '/ai-coach/mindfulness',
          // Marketplace (20+)
          '/marketplace',
          '/marketplace/cart',
          '/marketplace/orders',
          // Telemedicine (15+)
          '/telemedicine',
          '/telemedicine/doctors',
          '/telemedicine/video/:sessionId',
          // Community (20+)
          '/community',
          '/community/forum',
          '/community/qa',
          // 등등...
        ];
  }
}

/// 백엔드 설정
class BackendConfig {
  final bool useGRPC;
  final bool useWebSocket;
  final bool mockBackend;
  final List<String> enabledMicroservices;

  const BackendConfig({
    required this.useGRPC,
    required this.useWebSocket,
    required this.mockBackend,
    required this.enabledMicroservices,
  });
}

/// 하드웨어 설정 (시뮬레이션 모드)
class HardwareConfig {
  final bool simulateNFC;
  final bool simulateBLE;
  final bool simulateADC;
  final bool mockMeasurementData;

  const HardwareConfig({
    required this.simulateNFC,
    required this.simulateBLE,
    required this.simulateADC,
    required this.mockMeasurementData,
  });

  /// NFC 읽기 시뮬레이션
  Future<String> simulateNFCRead() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 'NFC_CARTRIDGE_001_GLUCOSE_PREMIUM';
  }

  /// BLE 연결 시뮬레이션
  Future<bool> simulateBLEConnect() async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  /// ADC 데이터 시뮬레이션 (24비트)
  Future<List<int>> simulateADCRead(int samples) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // 혈당 측정값 범위: 70-200 mg/dL를 24비트로 변환
    final random = DateTime.now().millisecondsSinceEpoch % 100;
    return List.generate(samples, (i) => 120 + random);
  }

  /// 측정값 시뮬레이션 (실제 NFC + ADC 대신)
  Map<String, dynamic> generateMockMeasurementData(String measurementType) {
    switch (measurementType) {
      case 'glucose':
        return {
          'type': 'glucose',
          'value': 115,
          'unit': 'mg/dL',
          'range': [70, 100], // 정상 범위
          'timestamp': DateTime.now(),
          'confidence': 0.98,
        };
      case 'cholesterol':
        return {
          'type': 'total_cholesterol',
          'value': 185,
          'unit': 'mg/dL',
          'range': [0, 200],
          'timestamp': DateTime.now(),
          'confidence': 0.96,
        };
      case 'radon':
        return {
          'type': 'radon',
          'value': 2.5,
          'unit': 'pCi/L',
          'range': [0, 4], // EPA 권장
          'timestamp': DateTime.now(),
          'confidence': 0.92,
        };
      default:
        return {};
    }
  }
}

/// AI 설정 (규칙 기반 우선, ML은 2차)
class AIConfig {
  final bool useRuleBasedCoaching;
  final bool useMLPrediction;
  final bool enableAdvancedAnalysis;
  final bool cacheAIPredictions;

  const AIConfig({
    required this.useRuleBasedCoaching,
    required this.useMLPrediction,
    required this.enableAdvancedAnalysis,
    required this.cacheAIPredictions,
  });

  /// 규칙 기반 코칭 추천
  List<String> generateRuleBasedRecommendations(Map<String, dynamic> userHealth) {
    final recommendations = <String>[];

    // 혈당 기반 규칙
    if (userHealth['glucose'] != null) {
      if (userHealth['glucose'] > 140) {
        recommendations.add('혈당이 높습니다. 탄수화물 섭취를 줄이세요.');
        recommendations.add('30분 이상 운동을 추천합니다.');
      } else if (userHealth['glucose'] < 100) {
        recommendations.add('혈당이 낮습니다. 가벼운 간식을 섭취하세요.');
      }
    }

    // 운동 기반 규칙
    if (userHealth['weeklyExercise'] != null) {
      if (userHealth['weeklyExercise'] < 150) {
        recommendations.add('주 150분 이상 운동이 권장됩니다.');
      }
    }

    // 수면 기반 규칙
    if (userHealth['sleepHours'] != null) {
      if (userHealth['sleepHours'] < 7) {
        recommendations.add('충분한 수면이 중요합니다. 밤 11시 이전에 취침하세요.');
      }
    }

    return recommendations;
  }

  /// 간단한 72시간 예측 (ML 없이 추세 분석)
  Map<String, dynamic> predictHealthTrend(List<double> historyData) {
    if (historyData.isEmpty) return {'trend': 'stable', 'forecast': []};

    // 간단한 이동 평균
    final average = historyData.reduce((a, b) => a + b) / historyData.length;
    final recent =
        historyData.sublist((historyData.length * 0.7).toInt()).reduce((a, b) => a + b) /
            historyData.sublist((historyData.length * 0.7).toInt()).length;

    final trend = recent > average ? 'up' : recent < average ? 'down' : 'stable';

    // 간단한 선형 외삽
    final forecast = [average, average, average]; // 72시간 예측값

    return {
      'trend': trend,
      'forecast': forecast,
      'confidence': 0.65, // 규칙 기반은 낮은 신뢰도
    };
  }
}

/// 성능 최적화 설정 (API 응답 < 200ms)
class PerformanceConfig {
  /// HTTP 캐싱 전략
  static const httpCacheConfig = {
    'enabled': true,
    'maxAge': Duration(hours: 1),
    'maxStale': Duration(days: 7),
    'targetResponseTime': Duration(milliseconds: 200),
  };

  /// Hive 캐싱 전략 (오프라인 모드)
  static const hiveCacheConfig = {
    'enabled': true,
    'compactionInterval': 100, // 100개 읽기 후 압축
    'cacheDuration': Duration(days: 30),
  };

  /// 이미지 캐싱
  static const imageCacheConfig = {
    'maxSizeBytes': 100 * 1024 * 1024, // 100MB
    'maxNumberOfCachedImages': 100,
  };

  /// 데이터베이스 쿼리 캐싱
  static const dbCacheConfig = {
    'enabled': true,
    'cacheDuration': Duration(minutes: 5),
    'invalidateOnWrite': true,
  };
}

/// 오프라인 모드 설정
class OfflineModeConfig {
  /// Hive를 주 저장소로 사용
  static const bool useHiveAsMainStore = true;

  /// 온라인 복귀 시 동기화 전략
  static const SyncStrategy syncStrategy = SyncStrategy(
    // 충돌 해결: 로컬 최신 버전 우선
    conflictResolution: 'local-wins',
    // 배치 동기화 (한 번에 100개)
    batchSize: 100,
    // 재시도 정책: 최대 3회
    maxRetries: 3,
    // 지수 백오프: 1s, 2s, 4s
    exponentialBackoff: true,
    // 대역폭 절약: 차분만 동기화
    deltaSync: true,
  );

  /// 로컬 데이터 유지 기간
  static const Duration localDataRetention = Duration(days: 90);

  /// 동기화 대기열 크기
  static const int maxSyncQueueSize = 1000;
}

class SyncStrategy {
  final String conflictResolution;
  final int batchSize;
  final int maxRetries;
  final bool exponentialBackoff;
  final bool deltaSync;

  const SyncStrategy({
    required this.conflictResolution,
    required this.batchSize,
    required this.maxRetries,
    required this.exponentialBackoff,
    required this.deltaSync,
  });
}

/// A/B 테스팅 설정 (Firebase Remote Config)
class ABTestingConfig {
  /// A/B 테스트 정의
  static const Map<String, ABTest> activeTests = {
    'coaching_ui_variant': ABTest(
      name: '코칭 UI 변형',
      variants: ['control', 'variant_a', 'variant_b'],
      distribution: {'control': 50, 'variant_a': 25, 'variant_b': 25},
      metric: 'coaching_completion_rate',
      targetLiftPercent: 15,
    ),
    'onboarding_flow': ABTest(
      name: '온보딩 플로우',
      variants: ['simple', 'detailed'],
      distribution: {'simple': 50, 'detailed': 50},
      metric: 'sign_up_completion',
      targetLiftPercent: 20,
    ),
  };

  /// 사용자 세그멘테이션 (Firebase Analytics)
  static const Map<String, dynamic> userSegments = {
    'power_users': {'measurementFrequency': 'daily', 'dataPoints': 100},
    'casual_users': {'measurementFrequency': 'weekly', 'dataPoints': 10},
    'new_users': {'accountAge': Duration(days: 30)},
  };

  /// 추적 이벤트
  static const List<String> trackedEvents = [
    'app_open',
    'measurement_completed',
    'coaching_followed',
    'data_viewed',
    'social_shared',
  ];
}

class ABTest {
  final String name;
  final List<String> variants;
  final Map<String, int> distribution; // variant -> percentage
  final String metric;
  final int targetLiftPercent;

  const ABTest({
    required this.name,
    required this.variants,
    required this.distribution,
    required this.metric,
    required this.targetLiftPercent,
  });
}
