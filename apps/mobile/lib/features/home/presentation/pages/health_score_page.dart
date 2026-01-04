import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 건강 점수 상세 페이지
/// 사용자의 종합 건강 점수와 각 지표별 상세 분석을 표시
class HealthScorePage extends StatefulWidget {
  const HealthScorePage({super.key});

  @override
  State<HealthScorePage> createState() => _HealthScorePageState();
}

class _HealthScorePageState extends State<HealthScorePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scoreAnimation;

  // Mock 데이터 - 실제로는 BLoC에서 가져옴
  final int overallScore = 85;
  final Map<String, HealthMetric> metrics = {
    'glucose': HealthMetric(
      name: '혈당',
      score: 82,
      value: '98',
      unit: 'mg/dL',
      status: HealthStatus.normal,
      trend: 'stable',
      icon: Icons.water_drop,
      color: Colors.blue,
    ),
    'bloodPressure': HealthMetric(
      name: '혈압',
      score: 88,
      value: '120/80',
      unit: 'mmHg',
      status: HealthStatus.optimal,
      trend: 'improving',
      icon: Icons.favorite,
      color: Colors.red,
    ),
    'heartRate': HealthMetric(
      name: '심박수',
      score: 85,
      value: '72',
      unit: 'bpm',
      status: HealthStatus.normal,
      trend: 'stable',
      icon: Icons.monitor_heart,
      color: Colors.pink,
    ),
    'oxygen': HealthMetric(
      name: '산소포화도',
      score: 95,
      value: '98',
      unit: '%',
      status: HealthStatus.excellent,
      trend: 'stable',
      icon: Icons.air,
      color: Colors.cyan,
    ),
    'temperature': HealthMetric(
      name: '체온',
      score: 90,
      value: '36.5',
      unit: '°C',
      status: HealthStatus.normal,
      trend: 'stable',
      icon: Icons.thermostat,
      color: Colors.orange,
    ),
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scoreAnimation = Tween<double>(begin: 0, end: overallScore.toDouble())
        .animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        title: const Text('건강 점수'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _showShareDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 종합 점수 카드
            _buildOverallScoreCard(),
            const SizedBox(height: 24),

            // 점수 해석
            _buildScoreInterpretation(),
            const SizedBox(height: 24),

            // 개별 지표 카드들
            _buildMetricsSection(),
            const SizedBox(height: 24),

            // 개선 권장사항
            _buildRecommendations(),
            const SizedBox(height: 24),

            // 히스토리 차트
            _buildHistoryChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallScoreCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1E3A5F),
            const Color(0xFF0D2137),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            '종합 건강 점수',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 24),
          AnimatedBuilder(
            animation: _scoreAnimation,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CustomPaint(
                      painter: ScoreRingPainter(
                        score: _scoreAnimation.value,
                        maxScore: 100,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _scoreAnimation.value.toInt().toString(),
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _getScoreGrade(overallScore),
                        style: TextStyle(
                          fontSize: 18,
                          color: _getScoreColor(overallScore),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildScoreStat('전주 대비', '+3점', Colors.green),
              _buildScoreStat('월평균', '82점', Colors.white70),
              _buildScoreStat('최고 기록', '92점', Colors.amber),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreStat(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildScoreInterpretation() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle, color: Colors.green, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '건강 상태 양호',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '현재 건강 지표가 전반적으로 양호합니다. 꾸준한 관리를 계속해주세요.',
                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '세부 지표',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ...metrics.values.map((metric) => _buildMetricCard(metric)),
      ],
    );
  }

  Widget _buildMetricCard(HealthMetric metric) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2942),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: metric.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(metric.icon, color: metric.color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      metric.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    _buildStatusBadge(metric.status),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '${metric.value} ${metric.unit}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 16),
                    _buildTrendIndicator(metric.trend),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: metric.score / 100,
                  backgroundColor: Colors.white12,
                  valueColor: AlwaysStoppedAnimation<Color>(metric.color),
                  strokeWidth: 4,
                ),
                Text(
                  '${metric.score}',
                  style: const TextStyle(
                    color: Colors.white,
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

  Widget _buildStatusBadge(HealthStatus status) {
    Color color;
    String text;
    switch (status) {
      case HealthStatus.excellent:
        color = Colors.green;
        text = '최적';
        break;
      case HealthStatus.optimal:
        color = Colors.teal;
        text = '양호';
        break;
      case HealthStatus.normal:
        color = Colors.blue;
        text = '정상';
        break;
      case HealthStatus.warning:
        color = Colors.orange;
        text = '주의';
        break;
      case HealthStatus.critical:
        color = Colors.red;
        text = '위험';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildTrendIndicator(String trend) {
    IconData icon;
    Color color;
    String text;

    switch (trend) {
      case 'improving':
        icon = Icons.trending_up;
        color = Colors.green;
        text = '개선 중';
        break;
      case 'declining':
        icon = Icons.trending_down;
        color = Colors.red;
        text = '하락 중';
        break;
      default:
        icon = Icons.trending_flat;
        color = Colors.grey;
        text = '안정';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: color, fontSize: 12)),
      ],
    );
  }

  Widget _buildRecommendations() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2942),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb, color: Colors.amber),
              const SizedBox(width: 8),
              const Text(
                '맞춤형 권장사항',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildRecommendationItem(
            Icons.directions_walk,
            '하루 30분 걷기',
            '심혈관 건강 개선에 도움이 됩니다',
            Colors.green,
          ),
          _buildRecommendationItem(
            Icons.water_drop,
            '수분 섭취 늘리기',
            '하루 8잔 물 마시기를 권장합니다',
            Colors.blue,
          ),
          _buildRecommendationItem(
            Icons.bedtime,
            '수면 시간 확보',
            '7-8시간의 충분한 수면이 필요합니다',
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(
      IconData icon, String title, String description, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.white54),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2942),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '점수 변화 추이',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '최근 7일',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: CustomPaint(
              size: Size.infinite,
              painter: ChartPainter(
                data: [78, 80, 82, 79, 83, 84, 85],
                lineColor: Colors.cyan,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['월', '화', '수', '목', '금', '토', '일']
                .map((day) => Text(
                      day,
                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  String _getScoreGrade(int score) {
    if (score >= 90) return '최상';
    if (score >= 80) return '양호';
    if (score >= 70) return '보통';
    if (score >= 60) return '주의';
    return '위험';
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return Colors.green;
    if (score >= 80) return Colors.teal;
    if (score >= 70) return Colors.orange;
    if (score >= 60) return Colors.deepOrange;
    return Colors.red;
  }

  void _showShareDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A2942),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '건강 점수 공유',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(Icons.people, '가족', Colors.blue),
                _buildShareOption(Icons.medical_services, '의사', Colors.green),
                _buildShareOption(Icons.download, '다운로드', Colors.orange),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(IconData icon, String label, Color color) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A2942),
        title: const Text(
          '건강 점수란?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          '건강 점수는 혈당, 혈압, 심박수, 산소포화도 등 주요 건강 지표를 종합하여 0-100점 사이로 계산됩니다.\n\n'
          '90점 이상: 최상의 건강 상태\n'
          '80-89점: 양호한 건강 상태\n'
          '70-79점: 보통, 개선 권장\n'
          '70점 미만: 주의 필요, 전문가 상담 권장',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}

// 점수 링 페인터
class ScoreRingPainter extends CustomPainter {
  final double score;
  final double maxScore;

  ScoreRingPainter({required this.score, required this.maxScore});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // 배경 링
    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // 점수 링
    final scorePaint = Paint()
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        colors: [Colors.cyan, Colors.green, Colors.cyan],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = (score / maxScore) * 2 * math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      scorePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// 차트 페인터
class ChartPainter extends CustomPainter {
  final List<double> data;
  final Color lineColor;

  ChartPainter({required this.data, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxValue = data.reduce(math.max);
    final minValue = data.reduce(math.min);
    final range = maxValue - minValue;

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [lineColor.withOpacity(0.3), lineColor.withOpacity(0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final fillPath = Path();

    final stepX = size.width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = size.height - ((data[i] - minValue) / range) * size.height * 0.8 - size.height * 0.1;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      // 점 그리기
      canvas.drawCircle(Offset(x, y), 4, Paint()..color = lineColor);
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// 데이터 모델
class HealthMetric {
  final String name;
  final int score;
  final String value;
  final String unit;
  final HealthStatus status;
  final String trend;
  final IconData icon;
  final Color color;

  HealthMetric({
    required this.name,
    required this.score,
    required this.value,
    required this.unit,
    required this.status,
    required this.trend,
    required this.icon,
    required this.color,
  });
}

enum HealthStatus { excellent, optimal, normal, warning, critical }

