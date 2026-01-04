import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../config/mvp_config.dart';
import '../../services/offline_mode_manager.dart';
import '../../services/http_optimization.dart';
import '../../services/analytics_manager.dart';

/// 성능 대시보드 (개발자용)
class PerformanceDashboardPage extends StatefulWidget {
  const PerformanceDashboardPage({Key? key}) : super(key: key);

  @override
  State<PerformanceDashboardPage> createState() => _PerformanceDashboardPageState();
}

class _PerformanceDashboardPageState extends State<PerformanceDashboardPage> {
  final _offlineManager = GetIt.instance<OfflineModeManager>();
  final _analyticsManager = GetIt.instance<AnalyticsManager>();
  late final PerformanceMonitor? _perfMonitor;

  @override
  void initState() {
    super.initState();
    try {
      _perfMonitor = GetIt.instance<PerformanceMonitor>();
    } catch (e) {
      _perfMonitor = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('성능 대시보드 (개발자)'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // MVP 모드 설정
            _buildMVPConfigSection(),

            const Divider(thickness: 2),

            // 오프라인 모드 상태
            _buildOfflineModeSection(),

            const Divider(thickness: 2),

            // 기능 플래그 상태
            _buildFeatureFlagsSection(),

            const Divider(thickness: 2),

            // API 성능
            _buildApiPerformanceSection(),

            const Divider(thickness: 2),

            // 캐시 통계
            _buildCacheStatsSection(),

            const Divider(thickness: 2),

            // Analytics 설정
            _buildAnalyticsSection(),
          ],
        ),
      ),
    );
  }

  /// MVP 설정 섹션
  Widget _buildMVPConfigSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'MVP 모드 설정',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildConfigItem(
                'MVP 모드',
                MVPConfig.enableMVPMode ? '활성화' : '비활성화',
                MVPConfig.enableMVPMode ? Colors.green : Colors.orange,
              ),
              _buildConfigItem(
                '활성화된 경로',
                MVPConfig.enableMVPMode ? '30개 (MVP)' : '150+ (전체)',
                Colors.blue,
              ),
              _buildConfigItem(
                '백엔드 서비스',
                MVPConfig.enableMVPMode ? '3개 (auth, measurement, ai)' : '9개 (전체)',
                Colors.blue,
              ),
              _buildConfigItem(
                'AI 모드',
                MVPConfig.aiConfig.useRuleBasedCoaching ? '규칙 기반' : 'ML 기반',
                Colors.purple,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // 설정 토글 (실제 구현)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('MVP 모드 변경 시 앱 재시작이 필요합니다')),
                    );
                  },
                  child: const Text('MVP 모드 토글 (개발용)'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 오프라인 모드 섹션
  Widget _buildOfflineModeSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '오프라인 모드',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              StreamBuilder<bool>(
                stream: _offlineManager.onlineStatusStream,
                builder: (context, snapshot) {
                  final isOnline = snapshot.data ?? true;
                  return _buildConfigItem(
                    '연결 상태',
                    isOnline ? '온라인' : '오프라인',
                    isOnline ? Colors.green : Colors.red,
                  );
                },
              ),
              const SizedBox(height: 8),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _offlineManager.getUnsyncedData(),
                builder: (context, snapshot) {
                  final count = snapshot.data?.length ?? 0;
                  return _buildConfigItem(
                    '동기화 대기',
                    '$count개 항목',
                    count > 0 ? Colors.orange : Colors.green,
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildConfigItem(
                '충돌 해결 전략',
                MVPConfig.offlineConfig.conflictResolution.toString().split('.').last,
                Colors.blue,
              ),
              _buildConfigItem(
                '배치 크기',
                '${MVPConfig.offlineConfig.batchSize} 항목',
                Colors.blue,
              ),
              _buildConfigItem(
                '재시도 횟수',
                '${MVPConfig.offlineConfig.maxRetries}회',
                Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 기능 플래그 섹션
  Widget _buildFeatureFlagsSection() {
    final features = MVPConfig.enabledFeatures;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '활성화된 기능',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildFeatureFlag('홈 화면', features.home),
              _buildFeatureFlag('측정', features.measurement),
              _buildFeatureFlag('데이터 허브', features.dataHub),
              _buildFeatureFlag('인증', features.auth),
              _buildFeatureFlag('코칭', features.coaching),
              _buildFeatureFlag('마켓플레이스', features.marketplace),
              _buildFeatureFlag('원격진료', features.telemedicine),
              _buildFeatureFlag('커뮤니티', features.community),
            ],
          ),
        ),
      ),
    );
  }

  /// API 성능 섹션
  Widget _buildApiPerformanceSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'API 성능',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildConfigItem(
                '최대 응답 시간',
                '${MVPConfig.performanceConfig.maxApiResponseMs}ms',
                Colors.blue,
              ),
              _buildConfigItem(
                '캐시 최대 나이',
                '${MVPConfig.performanceConfig.cacheMaxAgeSeconds}초',
                Colors.blue,
              ),
              _buildConfigItem(
                '캐시 최대 오래된 데이터',
                '${MVPConfig.performanceConfig.cacheMaxStaleSeconds}초',
                Colors.blue,
              ),
              _buildConfigItem(
                '캐시된 항목 수',
                '최대 ${MVPConfig.performanceConfig.maxCachedItems}개',
                Colors.blue,
              ),
              const SizedBox(height: 12),
              if (_perfMonitor != null) ...[
                FutureBuilder<Map<String, dynamic>>(
                  future: Future.value(_perfMonitor?.getPerformanceStats()),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox(
                        height: 20,
                        child: CircularProgressIndicator(),
                      );
                    }
                    final stats = snapshot.data ?? {};
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatItem(
                          '평균 응답 시간',
                          '${(stats['average'] ?? 0).toStringAsFixed(1)}ms',
                        ),
                        _buildStatItem(
                          'P95',
                          '${(stats['p95'] ?? 0).toStringAsFixed(1)}ms',
                        ),
                        _buildStatItem(
                          'P99',
                          '${(stats['p99'] ?? 0).toStringAsFixed(1)}ms',
                        ),
                        _buildStatItem(
                          '느린 요청',
                          '${(stats['slowPercentage'] ?? 0).toStringAsFixed(1)}%',
                        ),
                      ],
                    );
                  },
                ),
              ] else
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('성능 모니터링 미활성화'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// 캐시 통계 섹션
  Widget _buildCacheStatsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '캐시 통계',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildConfigItem(
                '캐싱 활성화',
                MVPConfig.enablePerformanceOptimization ? '활성화' : '비활성화',
                MVPConfig.enablePerformanceOptimization ? Colors.green : Colors.orange,
              ),
              const SizedBox(height: 12),
              FutureBuilder<Map<String, dynamic>>(
                future: Future.value(_offlineManager.getCacheStats()),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox(
                      height: 20,
                      child: CircularProgressIndicator(),
                    );
                  }
                  final stats = snapshot.data ?? {};
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatItem(
                        '캐시된 항목',
                        '${stats['cachedItems'] ?? 0}개',
                      ),
                      _buildStatItem(
                        '캐시 크기',
                        '${(stats['cacheSize'] ?? 0) / (1024 * 1024)}MB',
                      ),
                      _buildStatItem(
                        '캐시 히트율',
                        '${(stats['hitRate'] ?? 0).toStringAsFixed(1)}%',
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Analytics 섹션
  Widget _buildAnalyticsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Analytics 설정',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildConfigItem(
                'A/B 테스팅',
                MVPConfig.abTestConfig.enableABTesting ? '활성화' : '비활성화',
                MVPConfig.abTestConfig.enableABTesting ? Colors.green : Colors.orange,
              ),
              _buildConfigItem(
                '현재 변형',
                _analyticsManager.getUserVariant(),
                Colors.blue,
              ),
              const SizedBox(height: 12),
              const Text(
                '추적되는 이벤트:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildEventChip('측정 완료'),
              _buildEventChip('코칭 수행'),
              _buildEventChip('데이터 조회'),
              _buildEventChip('API 응답'),
              _buildEventChip('오프라인 동기화'),
              _buildEventChip('오류 발생'),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _analyticsManager.logScreenView('performance_dashboard');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('성능 대시보드 조회 이벤트 기록됨')),
                    );
                  },
                  child: const Text('Analytics 테스트 이벤트'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 설정 항목 위젯
  Widget _buildConfigItem(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color),
            ),
            child: Text(
              value,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  /// 통계 항목 위젯
  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  /// 기능 플래그 위젯
  Widget _buildFeatureFlag(String featureName, bool enabled) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: enabled ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: 8),
          Text(featureName),
          const Spacer(),
          Text(
            enabled ? '활성화' : '비활성화',
            style: TextStyle(
              color: enabled ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// 이벤트 칩 위젯
  Widget _buildEventChip(String eventName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
      child: Chip(
        label: Text(eventName),
        backgroundColor: Colors.deepPurple.withOpacity(0.2),
        side: const BorderSide(color: Colors.deepPurple),
      ),
    );
  }
}
