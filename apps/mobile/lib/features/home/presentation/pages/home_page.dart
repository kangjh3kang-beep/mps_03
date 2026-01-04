import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/bloc/home_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // 홈 페이지 로드
    context.read<HomeBloc>().add(const HomeDataRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('만파식'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.go('/more/settings/account/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<HomeBloc>().add(const HomeDataRefreshed());
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is HomeError) {
              return Center(child: Text('오류: ${state.message}'));
            }
            if (state is HomeLoaded) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 건강 점수
                    _HealthScoreWidget(healthScore: state.healthScore),
                    const SizedBox(height: 20),

                    // 환경 상태
                    _EnvironmentStatusRow(environment: state.environmentStatus),
                    const SizedBox(height: 20),

                    // 최근 측정
                    _RecentMeasurementsCard(measurements: state.recentMeasurements),
                    const SizedBox(height: 20),

                    // AI 인사이트
                    _AIInsightCard(insight: state.aiInsight),
                    const SizedBox(height: 20),

                    // 액션 버튼
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => context.go('/measurement/process/glucose?step=1'),
                              icon: const Icon(Icons.health_and_safety),
                              label: const Text('새 측정'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => context.go('/data-hub/trends'),
                              icon: const Icon(Icons.analytics),
                              label: const Text('분석 보기'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 리더기 상태
                    _ReaderStatusWidget(readers: state.connectedReaders),
                    const SizedBox(height: 20),

                    // 긴급 버튼
                    _EmergencyButton(contacts: state.emergencyContacts),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

// ============ 건강 점수 위젯 ============
class _HealthScoreWidget extends StatelessWidget {
  final dynamic healthScore;
  const _HealthScoreWidget({required this.healthScore});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        margin: const EdgeInsets.all(16),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.blue, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: CircularProgressIndicator(
                      value: (healthScore['score'] ?? 85) / 100,
                      strokeWidth: 8,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        (healthScore['score'] ?? 85) > 70 ? Colors.green : Colors.orange,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${healthScore['score'] ?? 85}',
                        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                      ),
                      const Text('점', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                healthScore['status'] ?? 'Good',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '${healthScore['daysTrend'] ?? 5} 포인트 ${(healthScore['daysTrend'] ?? 5) > 0 ? '↑' : '↓'}',
                style: TextStyle(
                  color: (healthScore['daysTrend'] ?? 5) > 0 ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============ 환경 상태 행 ============
class _EnvironmentStatusRow extends StatelessWidget {
  final dynamic environment;
  const _EnvironmentStatusRow({required this.environment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _getAirQualityColor(environment['airQuality'] ?? 'good').withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getAirQualityColor(environment['airQuality'] ?? 'good'),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.air, size: 32),
                    const SizedBox(height: 12),
                    const Text('공기질', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      environment['airQuality'] ?? 'Good',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _getWaterQualityColor(environment['waterQuality'] ?? 'safe').withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getWaterQualityColor(environment['waterQuality'] ?? 'safe'),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.water, size: 32),
                    const SizedBox(height: 12),
                    const Text('수질', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      environment['waterQuality'] ?? 'Safe',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getAirQualityColor(String quality) {
    switch (quality.toLowerCase()) {
      case 'good':
        return Colors.green;
      case 'moderate':
        return Colors.yellow;
      case 'unhealthy':
        return Colors.orange;
      case 'very_unhealthy':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  Color _getWaterQualityColor(String quality) {
    switch (quality.toLowerCase()) {
      case 'safe':
        return Colors.green;
      case 'caution':
        return Colors.orange;
      case 'unsafe':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}

// ============ 최근 측정 카드 ============
class _RecentMeasurementsCard extends StatelessWidget {
  final List<dynamic> measurements;
  const _RecentMeasurementsCard({required this.measurements});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('최근 측정', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...measurements.map((m) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${m['type'] ?? '측정'}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('${m['timestamp'] ?? ''}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  Text('${m['result'] ?? ''}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

// ============ AI 인사이트 카드 ============
class _AIInsightCard extends StatelessWidget {
  final dynamic insight;
  const _AIInsightCard({required this.insight});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.amber[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.smart_toy, color: Colors.orange),
                const SizedBox(width: 12),
                const Text('AI 인사이트', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Text(insight['message'] ?? '건강한 상태입니다'),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                child: const Text('더 보기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============ 리더기 상태 위젯 ============
class _ReaderStatusWidget extends StatelessWidget {
  final List<dynamic> readers;
  const _ReaderStatusWidget({required this.readers});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('리더기 상태', style: TextStyle(fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () {},
                  child: const Text('관리', style: TextStyle(color: Colors.blue, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...readers.asMap().entries.map((e) {
              final reader = e.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      reader['isConnected'] ?? false ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
                      color: reader['isConnected'] ?? false ? Colors.blue : Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(reader['deviceName'] ?? '리더기'),
                          Text('배터리: ${reader['batteryLevel']}%', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: reader['isConnected'] ?? false ? Colors.green[100] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        reader['isConnected'] ?? false ? '연결됨' : '연결 안 됨',
                        style: TextStyle(
                          fontSize: 12,
                          color: reader['isConnected'] ?? false ? Colors.green : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ============ 긴급 버튼 ============
class _EmergencyButton extends StatefulWidget {
  final List<dynamic> contacts;
  const _EmergencyButton({required this.contacts});

  @override
  State<_EmergencyButton> createState() => _EmergencyButtonState();
}

class _EmergencyButtonState extends State<_EmergencyButton> {
  int _pressCount = 0;
  DateTime? _lastPressTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onLongPress: () {
          _handleLongPress();
        },
        onTapDown: (_) {
          final now = DateTime.now();
          if (_lastPressTime != null && now.difference(_lastPressTime!).inSeconds < 5) {
            _pressCount++;
          } else {
            _pressCount = 1;
          }
          _lastPressTime = now;
          setState(() {});
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: Colors.red[50],
            border: Border.all(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(
                Icons.sos,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 12),
              const Text(
                '긴급 도움',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 4),
              Text(
                '3초 길게 누르세요',
                style: TextStyle(fontSize: 12, color: Colors.red[300]),
              ),
              if (_pressCount > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('누른 횟수: $_pressCount'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLongPress() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('긴급 상황이 접수되었습니다'),
        duration: Duration(seconds: 2),
      ),
    );
    // 실제 긴급 호출 로직
  }
}

