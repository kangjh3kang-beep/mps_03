# Firebase 설정 및 통합 가이드

## 1. Firebase 프로젝트 설정

### 1.1 Firebase Console 설정
1. [Firebase Console](https://console.firebase.google.com)에 접속
2. 새 프로젝트 생성 또는 기존 프로젝트 선택
3. Flutter 앱 추가
4. `google-services.json` (Android) 및 `GoogleService-Info.plist` (iOS) 다운로드

### 1.2 파일 배치
```
apps/mobile/
├── android/app/
│   └── google-services.json
└── ios/
    └── GoogleService-Info.plist
```

## 2. 패키지 설치

```bash
cd apps/mobile

# Firebase 필수 패키지
flutter pub add firebase_core
flutter pub add firebase_analytics
flutter pub add firebase_remote_config

# 선택사항 (A/B 테스팅)
flutter pub add firebase_ab_testing  # Firebase ML용
```

### pubspec.yaml 업데이트
```yaml
dependencies:
  firebase_core: ^2.24.0
  firebase_analytics: ^10.4.0
  firebase_remote_config: ^4.3.0
  get_it: ^7.5.0
  dio: ^5.3.0
  hive_flutter: ^1.1.0
```

## 3. 초기화 순서

### lib/main.dart (이미 업데이트됨)
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase 초기화 (service_locator.dart에서 수행)
  await setupDependencies();
  
  runApp(const ManpasikApp());
}
```

### lib/config/service_locator.dart의 setupDependencies()
```dart
Future<void> setupDependencies() async {
  // 1. Firebase 초기화
  await Firebase.initializeApp();
  
  // 2. Analytics 및 Remote Config 초기화
  final analyticsManager = AnalyticsManager();
  await analyticsManager.init();
  
  // ... 기타 서비스
}
```

## 4. A/B 테스팅 설정

### 4.1 Firebase Console에서 Remote Config 설정
1. Firebase Console → Remote Config 선택
2. 새 매개변수 생성:

```
Parameter Name: coaching_ui_variant
Default Value: "control"
Description: "코칭 UI A/B 테스트 변형"

Parameter Name: onboarding_flow
Default Value: "simple"
Description: "온보딩 플로우 테스트"

Parameter Name: api_cache_duration
Default Value: 3600
Description: "API 캐시 시간 (초)"

Parameter Name: enable_offline_mode
Default Value: true
Description: "오프라인 모드 활성화"
```

### 4.2 조건부 타겟팅 (예시)
```
Parameter: coaching_ui_variant
- Condition: "Android" → "treatment"
- Condition: "iOS" → "control"
- Condition: "User Country" = "KR" → "variant_ko"
```

### 4.3 A/B 테스트 생성 (Google Analytics 필요)
1. Analytics → Experiments
2. Create experiment
3. Metric: "coaching_completion_rate"
4. Duration: 4 weeks
5. Sample size: 50%

## 5. Analytics 이벤트 추적

### 5.1 자동 추적 이벤트 (Firebase 기본)
- app_open
- first_open
- app_update
- app_remove
- app_clear_data

### 5.2 커스텀 이벤트 (AnalyticsManager에서 추적)

```dart
// 측정 완료
await analyticsManager.logMeasurementCompleted(
  measurementType: 'blood_glucose',
  value: 120.5,
  durationSeconds: 30,
);

// 코칭 수행
await analyticsManager.logCoachingFollowed(
  recommendationType: 'exercise',
  category: 'daily_activity',
);

// 데이터 조회
await analyticsManager.logDataViewed(
  dataType: 'trends',
  period: 'weekly',
);

// 구매
await analyticsManager.logPurchase(
  productId: 'premium_subscription',
  value: 99.99,
  currency: 'KRW',
);
```

## 6. 성능 모니터링

### 6.1 Performance Monitoring 활성화
```bash
flutter pub add firebase_performance
```

### 6.2 커스텀 추적 (PerformanceMonitor)
```dart
final perfMonitor = getIt<PerformanceMonitor>();

await perfMonitor.logScreenLoadTime(
  'home_page',
  Duration(milliseconds: 500),
);

await perfMonitor.logApiResponseTime(
  '/api/measurements',
  Duration(milliseconds: 150),
);
```

## 7. 에러 추적

### 7.1 Crashlytics 설정 (선택사항)
```bash
flutter pub add firebase_crashlytics
```

### 7.2 에러 로깅 (ErrorTracker)
```dart
final errorTracker = getIt<ErrorTracker>();

await errorTracker.logMeasurementError(
  errorType: 'hardware_disconnected',
  errorMessage: 'NFC reader not found',
  measurementType: 'blood_glucose',
);
```

## 8. 데이터 분석 쿼리 (BigQuery)

### 8.1 주요 분석 대시보드
```sql
-- 코칭 효과 분석 (A/B 테스트)
SELECT
  user_properties.ab_test_variant.value as variant,
  COUNT(DISTINCT user_id) as unique_users,
  COUNTIF(event_name = 'coaching_completed') as coaching_completions,
  COUNTIF(event_name = 'coaching_completed') / COUNT(DISTINCT user_id) as completion_rate
FROM `firebase_project.analytics_events`
WHERE event_date BETWEEN '2024-01-01' AND '2024-01-31'
  AND event_name IN ('coaching_completed', 'app_open')
GROUP BY variant
ORDER BY completion_rate DESC;

-- 측정 사용 패턴
SELECT
  event_parameters.string_value as measurement_type,
  COUNT(*) as total_measurements,
  AVG(CAST(event_parameters.float_value as float64)) as avg_value
FROM `firebase_project.analytics_events`,
UNNEST(event_params) as event_parameters
WHERE event_name = 'measurement_completed'
GROUP BY measurement_type;

-- API 성능 분석
SELECT
  event_parameters.string_value as endpoint,
  COUNT(*) as request_count,
  AVG(CAST(event_parameters.int_value as int64)) as avg_response_ms,
  PERCENTILE_CONT(CAST(event_parameters.int_value as int64), 0.95) OVER () as p95_response_ms
FROM `firebase_project.analytics_events`,
UNNEST(event_params) as event_parameters
WHERE event_name = 'api_response_time'
GROUP BY endpoint
ORDER BY avg_response_ms DESC;
```

## 9. MVP 모드에서의 분석

### 9.1 활성화된 분석 (MVP)
- ✅ 앱 오픈/설치/업데이트
- ✅ 측정 완료 (혈당, 혈압, 운동)
- ✅ 코칭 권장사항 수행
- ✅ 데이터 허브 조회
- ✅ 설정 변경
- ✅ API 응답 시간
- ✅ 오프라인 모드 이벤트

### 9.2 비활성화된 분석 (Phase 2)
- ❌ 마켓플레이스 구매 (feature 비활성화)
- ❌ 커뮤니티 활동 (feature 비활성화)
- ❌ 원격진료 예약 (feature 비활성화)
- ❌ AI 코칭 고급 메트릭 (rule-based로 단순화)

## 10. 로컬 테스트 (Firebase Emulator)

### 10.1 Emulator Suite 설치
```bash
# Firebase CLI 설치 (전역)
npm install -g firebase-tools

# 에뮬레이터 시작
firebase emulators:start --project demo-project
```

### 10.2 Flutter 앱에서 Emulator 사용
```dart
// lib/config/service_locator.dart
Future<void> setupDependencies() async {
  // Emulator 연결 (개발 환경)
  if (kDebugMode) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Analytics, Remote Config 에뮬레이터로 라우팅
  }
}
```

## 11. 보안 및 프라이버시

### 11.1 데이터 수집 정책
- 개인식별 정보(PII) 제외: ✅
- 민감한 건강데이터는 암호화: ✅
- GDPR/CCPA 준수: ✅

### 11.2 데이터 보존 정책
- Analytics: 13개월 자동 삭제
- 사용자 데이터: 사용자 요청 시 삭제

## 12. 성능 최적화

### 12.1 배치 이벤트 전송 (대역폭 절감)
```dart
// Firebase Analytics는 기본적으로 배치 전송
// (15분 또는 1000 이벤트 도달 시)
// 추가 설정 불필요
```

### 12.2 캐싱 전략
```dart
// Remote Config 캐시 (1시간)
await remoteConfig.setConfigSettings(
  RemoteConfigSettings(
    minimumFetchInterval: Duration(hours: 1),
  ),
);
```

## 13. 대시보드 및 리포팅

### 13.1 권장 대시보드
1. **건강 지표 대시보드**
   - DAU/MAU
   - 측정 완료율
   - 평균 측정값

2. **코칭 효과 대시보드** (A/B 테스트)
   - 변형별 코칭 완료율
   - 권장사항 준수율
   - 건강 개선도

3. **기술 성능 대시보드**
   - API 응답 시간 (p95, p99)
   - 오프라인 동기화 성공율
   - 앱 충돌율

4. **사용자 리텐션 대시보드**
   - 7일 리텐션
   - 30일 리텐션
   - 기능별 사용 빈도

## 14. 문제 해결

### 14.1 Analytics 데이터가 나타나지 않음
```
1. Firebase Console → Real-time에서 확인
2. app/debug 빌드로 테스트
3. logEvent 호출 확인 (debugPrint 추가)
4. 최소 24시간 대기 (초기)
```

### 14.2 Remote Config이 기본값만 반환
```
1. fetchAndActivate() 호출 확인
2. 인터넷 연결 확인
3. Firebase Console에서 퍼블리시 확인
4. 캐시 시간(minimumFetchInterval) 확인
```

## 15. 추가 리소스

- [Firebase Analytics 문서](https://firebase.google.com/docs/analytics)
- [Firebase Remote Config 문서](https://firebase.google.com/docs/remote-config)
- [A/B Testing with Google Analytics](https://support.google.com/analytics/answer/7372977)
- [Flutter Firebase 플러그인](https://github.com/firebase/flutterfire)
