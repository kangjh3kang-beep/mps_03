import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

/// 실시간 분석 페이지 - 현재 건강 지표 실시간 모니터링
class RealTimeAnalysisPage extends StatefulWidget {
  const RealTimeAnalysisPage({super.key});

  @override
  State<RealTimeAnalysisPage> createState() => _RealTimeAnalysisPageState();
}

class _RealTimeAnalysisPageState extends State<RealTimeAnalysisPage> {
  Timer? _timer;
  final Random _random = Random();

  // 실시간 데이터
  int _heartRate = 72;
  double _bloodPressureSystolic = 120;
  double _bloodPressureDiastolic = 80;
  double _temperature = 36.5;
  int _spO2 = 98;

  @override
  void initState() {
    super.initState();
    _startRealTimeUpdates();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startRealTimeUpdates() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _heartRate = 65 + _random.nextInt(20);
        _bloodPressureSystolic = 115 + _random.nextDouble() * 15;
        _bloodPressureDiastolic = 75 + _random.nextDouble() * 10;
        _temperature = 36.3 + _random.nextDouble() * 0.6;
        _spO2 = 96 + _random.nextInt(4);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('실시간 분석'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상태 표시
            _buildStatusBanner(theme),
            const SizedBox(height: 24),

            // 실시간 지표 그리드
            Text(
              '실시간 건강 지표',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                _buildMetricCard(
                  '심박수',
                  '$_heartRate',
                  'BPM',
                  Icons.favorite,
                  Colors.red,
                  _getHeartRateStatus(),
                ),
                _buildMetricCard(
                  '혈압',
                  '${_bloodPressureSystolic.toInt()}/${_bloodPressureDiastolic.toInt()}',
                  'mmHg',
                  Icons.water_drop,
                  Colors.blue,
                  _getBloodPressureStatus(),
                ),
                _buildMetricCard(
                  '체온',
                  _temperature.toStringAsFixed(1),
                  '°C',
                  Icons.thermostat,
                  Colors.orange,
                  _getTemperatureStatus(),
                ),
                _buildMetricCard(
                  '산소포화도',
                  '$_spO2',
                  '%',
                  Icons.air,
                  Colors.teal,
                  _getSpO2Status(),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 실시간 그래프 (간단한 시각화)
            Text(
              '심박수 추이',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildSimpleGraph(theme),

            const SizedBox(height: 24),

            // AI 인사이트
            _buildAIInsightCard(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBanner(ThemeData theme) {
    bool isNormal = _heartRate < 100 && _spO2 >= 95;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isNormal
              ? [Colors.green[400]!, Colors.green[600]!]
              : [Colors.orange[400]!, Colors.orange[600]!],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isNormal ? Icons.check_circle : Icons.warning,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isNormal ? '모든 지표 정상' : '일부 지표 주의 필요',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '마지막 업데이트: 방금 전',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  'LIVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    String unit,
    IconData icon,
    Color color,
    String status,
  ) {
    Color statusColor = status == '정상'
        ? Colors.green
        : status == '주의'
            ? Colors.orange
            : Colors.red;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleGraph(ThemeData theme) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: CustomPaint(
        painter: _SimpleGraphPainter(heartRate: _heartRate),
        size: Size.infinite,
      ),
    );
  }

  Widget _buildAIInsightCard(ThemeData theme) {
    return Card(
      color: theme.colorScheme.primaryContainer.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.psychology,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AI 인사이트',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '현재 건강 상태가 양호합니다. 규칙적인 운동을 유지하세요.',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getHeartRateStatus() {
    if (_heartRate >= 60 && _heartRate <= 100) return '정상';
    if (_heartRate < 60) return '주의';
    return '높음';
  }

  String _getBloodPressureStatus() {
    if (_bloodPressureSystolic <= 120 && _bloodPressureDiastolic <= 80)
      return '정상';
    if (_bloodPressureSystolic <= 140 && _bloodPressureDiastolic <= 90)
      return '주의';
    return '높음';
  }

  String _getTemperatureStatus() {
    if (_temperature >= 36.1 && _temperature <= 37.2) return '정상';
    return '주의';
  }

  String _getSpO2Status() {
    if (_spO2 >= 95) return '정상';
    if (_spO2 >= 90) return '주의';
    return '위험';
  }
}

class _SimpleGraphPainter extends CustomPainter {
  final int heartRate;

  _SimpleGraphPainter({required this.heartRate});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red.withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final random = Random(heartRate);

    path.moveTo(0, size.height / 2);
    for (double x = 0; x < size.width; x += 10) {
      final y = size.height / 2 + (random.nextDouble() - 0.5) * 40;
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SimpleGraphPainter oldDelegate) {
    return oldDelegate.heartRate != heartRate;
  }
}
