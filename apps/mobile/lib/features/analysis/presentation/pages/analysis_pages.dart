import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 분석 메인 페이지 - 데이터 분석 허브
class AnalysisPage extends StatelessWidget {
  const AnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        title: const Text('데이터 분석'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 분석 요약 카드
            _buildSummaryCard(),
            const SizedBox(height: 24),

            // 분석 메뉴 그리드
            const Text(
              '분석 도구',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            _buildAnalysisGrid(context),
            const SizedBox(height: 24),

            // 최근 인사이트
            _buildRecentInsights(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF1E3A5F), const Color(0xFF0D2137)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem('총 측정', '248회', Icons.analytics),
              _buildSummaryItem('분석 기간', '90일', Icons.date_range),
              _buildSummaryItem('데이터 품질', '98%', Icons.verified),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.cyan, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildAnalysisGrid(BuildContext context) {
    final items = [
      AnalysisMenuItem(
        icon: Icons.show_chart,
        title: '차트 분석',
        subtitle: '시각적 데이터 탐색',
        color: Colors.blue,
        route: '/analysis/charts',
      ),
      AnalysisMenuItem(
        icon: Icons.timeline,
        title: '시계열 분석',
        subtitle: '시간에 따른 변화',
        color: Colors.purple,
        route: '/analysis/time-series',
      ),
      AnalysisMenuItem(
        icon: Icons.bar_chart,
        title: '통계 분석',
        subtitle: '평균, 표준편차 등',
        color: Colors.green,
        route: '/analysis/statistics',
      ),
      AnalysisMenuItem(
        icon: Icons.compare_arrows,
        title: '상관관계',
        subtitle: '지표 간 연관성',
        color: Colors.orange,
        route: '/analysis/correlations',
      ),
      AnalysisMenuItem(
        icon: Icons.description,
        title: '보고서',
        subtitle: 'PDF 생성',
        color: Colors.red,
        route: '/analysis/reports',
      ),
      AnalysisMenuItem(
        icon: Icons.psychology,
        title: 'AI 인사이트',
        subtitle: 'AI 분석 결과',
        color: Colors.cyan,
        route: '/analysis/insights',
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildAnalysisCard(context, items[index]),
    );
  }

  Widget _buildAnalysisCard(BuildContext context, AnalysisMenuItem item) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, item.route),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2942),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: item.color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: item.color, size: 24),
            ),
            const Spacer(),
            Text(
              item.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.subtitle,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentInsights() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2942),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.amber),
              SizedBox(width: 8),
              Text(
                '최근 발견된 인사이트',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInsightItem(
            '혈당 패턴 발견',
            '오후 3시경 혈당이 상승하는 경향이 있습니다.',
            Colors.orange,
          ),
          _buildInsightItem(
            '운동 효과 확인',
            '운동 후 심박수 회복 시간이 개선되었습니다.',
            Colors.green,
          ),
          _buildInsightItem(
            '수면 연관성',
            '수면 시간과 다음 날 혈압 간 상관관계가 있습니다.',
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(String title, String description, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
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
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 차트 분석 페이지
class ChartsPage extends StatefulWidget {
  const ChartsPage({super.key});

  @override
  State<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  String selectedMetric = 'glucose';
  String selectedPeriod = '7d';

  final metrics = {
    'glucose': '혈당',
    'bloodPressure': '혈압',
    'heartRate': '심박수',
    'oxygen': '산소포화도',
  };

  final periods = {
    '7d': '7일',
    '30d': '30일',
    '90d': '90일',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        title: const Text('차트 분석'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 필터 영역
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: _buildMetricSelector()),
                const SizedBox(width: 12),
                _buildPeriodSelector(),
              ],
            ),
          ),

          // 차트 영역
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildChartCard(),
            ),
          ),

          // 통계 요약
          _buildStatsSummary(),
        ],
      ),
    );
  }

  Widget _buildMetricSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2942),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        value: selectedMetric,
        isExpanded: true,
        dropdownColor: const Color(0xFF1A2942),
        underline: const SizedBox(),
        style: const TextStyle(color: Colors.white),
        items: metrics.entries
            .map((e) => DropdownMenuItem(
                  value: e.key,
                  child: Text(e.value),
                ))
            .toList(),
        onChanged: (value) => setState(() => selectedMetric = value!),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A2942),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: periods.entries.map((e) {
          final isSelected = selectedPeriod == e.key;
          return InkWell(
            onTap: () => setState(() => selectedPeriod = e.key),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.cyan : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                e.value,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white54,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChartCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2942),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${metrics[selectedMetric]} 추이',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: CustomPaint(
              size: Size.infinite,
              painter: LineChartPainter(
                data: _generateMockData(),
                lineColor: Colors.cyan,
                showGrid: true,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildChartLegend(),
        ],
      ),
    );
  }

  List<double> _generateMockData() {
    final random = math.Random(42);
    final count = selectedPeriod == '7d' ? 7 : (selectedPeriod == '30d' ? 30 : 90);
    return List.generate(count, (i) => 80 + random.nextDouble() * 40);
  }

  Widget _buildChartLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('평균', Colors.cyan),
        const SizedBox(width: 24),
        _buildLegendItem('정상 범위', Colors.green.withOpacity(0.3)),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 4,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }

  Widget _buildStatsSummary() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2942),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('평균', '98.5', 'mg/dL'),
          _buildStatItem('최소', '85', 'mg/dL'),
          _buildStatItem('최대', '125', 'mg/dL'),
          _buildStatItem('표준편차', '12.3', ''),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String unit) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: ' $unit',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 통계 분석 페이지
class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        title: const Text('통계 분석'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverviewCard(),
            const SizedBox(height: 24),
            _buildDistributionSection(),
            const SizedBox(height: 24),
            _buildComparisonSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF1E3A5F), const Color(0xFF0D2137)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '통계 요약',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Table(
            children: [
              _buildTableRow('측정 횟수', '248회'),
              _buildTableRow('정상 범위 비율', '92%'),
              _buildTableRow('평균 측정 간격', '8시간'),
              _buildTableRow('데이터 신뢰도', '98.5%'),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(label, style: const TextStyle(color: Colors.white54)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildDistributionSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2942),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '값 분포',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          _buildDistributionBar('< 70 (저혈당)', 0.05, Colors.orange),
          _buildDistributionBar('70-100 (정상)', 0.72, Colors.green),
          _buildDistributionBar('100-126 (전당뇨)', 0.18, Colors.yellow),
          _buildDistributionBar('> 126 (당뇨)', 0.05, Colors.red),
        ],
      ),
    );
  }

  Widget _buildDistributionBar(String label, double ratio, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              Text('${(ratio * 100).toInt()}%',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2942),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '기간별 비교',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          _buildComparisonRow('이번 주', '지난 주', 98.5, 95.2, Colors.green),
          _buildComparisonRow('이번 달', '지난 달', 97.8, 96.5, Colors.green),
          _buildComparisonRow('이번 분기', '지난 분기', 96.2, 94.8, Colors.green),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(
      String label1, String label2, double value1, double value2, Color changeColor) {
    final change = value1 - value2;
    final changeText = change >= 0 ? '+${change.toStringAsFixed(1)}' : change.toStringAsFixed(1);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label1, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                Text(
                  value1.toStringAsFixed(1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: changeColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              changeText,
              style: TextStyle(color: changeColor, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(label2, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                Text(
                  value2.toStringAsFixed(1),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
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
}

/// 상관관계 분석 페이지
class CorrelationsPage extends StatelessWidget {
  const CorrelationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        title: const Text('상관관계 분석'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCorrelationMatrix(),
            const SizedBox(height: 24),
            _buildKeyFindings(),
          ],
        ),
      ),
    );
  }

  Widget _buildCorrelationMatrix() {
    final metrics = ['혈당', '혈압', '심박수', '산소', '체온'];
    final correlations = [
      [1.0, 0.45, 0.32, -0.15, 0.12],
      [0.45, 1.0, 0.58, -0.22, 0.18],
      [0.32, 0.58, 1.0, -0.35, 0.25],
      [-0.15, -0.22, -0.35, 1.0, -0.08],
      [0.12, 0.18, 0.25, -0.08, 1.0],
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2942),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '상관관계 매트릭스',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                // 헤더 행
                Row(
                  children: [
                    const SizedBox(width: 60),
                    ...metrics.map((m) => SizedBox(
                          width: 60,
                          child: Text(
                            m,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        )),
                  ],
                ),
                const SizedBox(height: 8),
                // 데이터 행들
                ...List.generate(
                  metrics.length,
                  (i) => Row(
                    children: [
                      SizedBox(
                        width: 60,
                        child: Text(
                          metrics[i],
                          style: const TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ),
                      ...List.generate(
                        metrics.length,
                        (j) => _buildCorrelationCell(correlations[i][j]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildCorrelationLegend(),
        ],
      ),
    );
  }

  Widget _buildCorrelationCell(double value) {
    Color color;
    if (value >= 0.5) {
      color = Colors.green;
    } else if (value >= 0.3) {
      color = Colors.lightGreen;
    } else if (value >= 0) {
      color = Colors.grey;
    } else if (value >= -0.3) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }

    return Container(
      width: 60,
      height: 40,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: color.withOpacity(value.abs()),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          value.toStringAsFixed(2),
          style: TextStyle(
            color: value.abs() > 0.3 ? Colors.white : Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildCorrelationLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('강한 양', Colors.green),
        _buildLegendItem('약한 양', Colors.lightGreen),
        _buildLegendItem('없음', Colors.grey),
        _buildLegendItem('약한 음', Colors.orange),
        _buildLegendItem('강한 음', Colors.red),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildKeyFindings() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2942),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.insights, color: Colors.amber),
              SizedBox(width: 8),
              Text(
                '주요 발견',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFindingItem(
            '혈압-심박수',
            '중등도 양의 상관관계 (r=0.58)',
            '혈압이 높을 때 심박수도 높아지는 경향',
            Colors.blue,
          ),
          _buildFindingItem(
            '혈당-혈압',
            '약한 양의 상관관계 (r=0.45)',
            '식후 혈당 상승 시 혈압도 상승하는 패턴',
            Colors.green,
          ),
          _buildFindingItem(
            '산소-심박수',
            '약한 음의 상관관계 (r=-0.35)',
            '격한 운동 시 산소포화도 일시적 감소',
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildFindingItem(String title, String correlation, String interpretation, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                correlation,
                style: TextStyle(color: color, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            interpretation,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// 분석 메뉴 아이템 모델
class AnalysisMenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final String route;

  AnalysisMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.route,
  });
}

// 라인 차트 페인터
class LineChartPainter extends CustomPainter {
  final List<double> data;
  final Color lineColor;
  final bool showGrid;

  LineChartPainter({
    required this.data,
    required this.lineColor,
    this.showGrid = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    // 그리드 그리기
    if (showGrid) {
      final gridPaint = Paint()
        ..color = Colors.white.withOpacity(0.1)
        ..strokeWidth = 1;

      for (int i = 0; i <= 4; i++) {
        final y = size.height * i / 4;
        canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
      }
    }

    final maxValue = data.reduce(math.max);
    final minValue = data.reduce(math.min);
    final range = maxValue - minValue;

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
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
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

