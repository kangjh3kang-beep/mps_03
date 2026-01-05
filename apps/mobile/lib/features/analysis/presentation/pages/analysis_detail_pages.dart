import 'package:flutter/material.dart';

/// 분석 상세 페이지들 - Phase 2 구현
/// Reports, Benchmarks, Insights, Predictions, Anomalies, DrillDown, CustomReports, AnalysisExport

// ============================================
// 리포트 페이지
// ============================================
class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('건강 리포트'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildReportCard(
            '월간 건강 리포트',
            '2026년 1월',
            Icons.calendar_month,
            Colors.blue,
            '포괄적인 월간 건강 분석',
          ),
          _buildReportCard(
            '혈당 추이 리포트',
            '최근 30일',
            Icons.show_chart,
            Colors.purple,
            '혈당 변화 및 패턴 분석',
          ),
          _buildReportCard(
            '의료진 공유용 리포트',
            '2026년 1월 5일',
            Icons.medical_services,
            Colors.green,
            '담당 의사와 공유할 상세 리포트',
          ),
          _buildReportCard(
            '주간 요약 리포트',
            '이번 주',
            Icons.summarize,
            Colors.orange,
            '주간 건강 지표 요약',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('새 리포트'),
      ),
    );
  }

  Widget _buildReportCard(
    String title,
    String period,
    IconData icon,
    Color color,
    String description,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(description,
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(period, style: TextStyle(color: color, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================
// 벤치마크 페이지
// ============================================
class BenchmarksPage extends StatelessWidget {
  const BenchmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('건강 벤치마크')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 내 위치
            Card(
              color: theme.colorScheme.primaryContainer.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text('내 건강 점수', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 8),
                    Text(
                      '85',
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '상위 15%',
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text('지표별 비교',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildBenchmarkItem('혈당 관리', 92, 78, Colors.purple),
            _buildBenchmarkItem('혈압 관리', 88, 75, Colors.red),
            _buildBenchmarkItem('측정 빈도', 95, 65, Colors.blue),
            _buildBenchmarkItem('목표 달성률', 78, 70, Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildBenchmarkItem(
      String title, int myScore, int avgScore, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  myScore > avgScore
                      ? '+${myScore - avgScore}'
                      : '${myScore - avgScore}',
                  style: TextStyle(
                    color: myScore > avgScore ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      LinearProgressIndicator(
                        value: myScore / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation(color),
                      ),
                      const SizedBox(height: 4),
                      Text('나: $myScore점',
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      LinearProgressIndicator(
                        value: avgScore / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation(Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text('평균: $avgScore점',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// 인사이트 페이지
// ============================================
class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('AI 인사이트')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInsightCard(
            '혈당 패턴 발견',
            '오후 3-5시 사이 혈당이 상승하는 경향이 있습니다. 이 시간대 간식 섭취를 확인해보세요.',
            Icons.insights,
            Colors.purple,
            '오늘',
          ),
          _buildInsightCard(
            '개선 추세',
            '지난 2주간 공복 혈당 평균이 5mg/dL 감소했습니다. 좋은 진전입니다!',
            Icons.trending_down,
            Colors.green,
            '어제',
          ),
          _buildInsightCard(
            '측정 습관',
            '매일 일정한 시간에 측정하고 계십니다. 이 습관을 유지하세요.',
            Icons.schedule,
            Colors.blue,
            '3일 전',
          ),
          _buildInsightCard(
            '주의 필요',
            '주말 혈당이 평일보다 평균 10% 높습니다. 주말 식습관을 점검해보세요.',
            Icons.warning_amber,
            Colors.orange,
            '1주 전',
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(String title, String description, IconData icon,
      Color color, String time) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(time,
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[500])),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(description,
                style: TextStyle(color: Colors.grey[700], height: 1.4)),
          ],
        ),
      ),
    );
  }
}

// ============================================
// 예측 페이지
// ============================================
class PredictionsPage extends StatelessWidget {
  const PredictionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('AI 예측')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 예측 헤더
            Card(
              color: theme.colorScheme.primaryContainer.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.auto_graph,
                        color: theme.colorScheme.primary, size: 48),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('AI 예측 분석',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(height: 4),
                          Text('머신러닝 기반 건강 예측',
                              style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text('7일 예측',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildPredictionCard(
                '평균 혈당', '92-98 mg/dL', '안정적 유지 예상', Colors.green),
            _buildPredictionCard('혈당 변동성', '낮음', '현재 패턴 유지 시', Colors.blue),
            _buildPredictionCard(
                '목표 달성률', '85%', '목표 90% 달성 가능', Colors.purple),

            const SizedBox(height: 24),
            Text('장기 전망',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '현재 추세가 유지된다면 3개월 후 HbA1c 수치가 0.2% 감소할 것으로 예측됩니다.',
                      style: TextStyle(height: 1.5),
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: 0.7,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation(Colors.green),
                    ),
                    const SizedBox(height: 8),
                    Text('예측 신뢰도: 70%',
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionCard(
      String title, String value, String note, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.auto_awesome, color: color),
        ),
        title: Text(title),
        subtitle: Text(note, style: const TextStyle(fontSize: 12)),
        trailing: Text(value,
            style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ),
    );
  }
}

// ============================================
// 이상치 감지 페이지
// ============================================
class AnomaliesPage extends StatelessWidget {
  const AnomaliesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('이상치 감지')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 요약
          Card(
            color: Colors.green.withOpacity(0.1),
            child: const ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('최근 7일간 이상치 없음'),
              subtitle: Text('모든 측정값이 정상 범위 내에 있습니다'),
            ),
          ),
          const SizedBox(height: 24),

          const Text('과거 이상치 기록',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          _buildAnomalyItem('높은 혈당', '145 mg/dL', '2주 전', Colors.red),
          _buildAnomalyItem('측정 누락', '3일 연속', '3주 전', Colors.orange),
          _buildAnomalyItem('급격한 변화', '+30 mg/dL', '1개월 전', Colors.orange),
        ],
      ),
    );
  }

  Widget _buildAnomalyItem(
      String title, String value, String time, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.warning, color: color),
        ),
        title: Text(title),
        subtitle: Text(time),
        trailing: Text(value,
            style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ),
    );
  }
}

// ============================================
// 드릴다운 분석 페이지
// ============================================
class DrillDownPage extends StatelessWidget {
  const DrillDownPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('상세 분석')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 분석 카테고리
          Text('분석 카테고리 선택',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildCategoryCard(
              '시간대별 분석', '아침/점심/저녁 혈당 패턴', Icons.access_time, Colors.blue),
          _buildCategoryCard(
              '요일별 분석', '주중/주말 차이 분석', Icons.calendar_view_week, Colors.green),
          _buildCategoryCard(
              '식사 관련 분석', '식전/식후 혈당 변화', Icons.restaurant, Colors.orange),
          _buildCategoryCard(
              '활동 관련 분석', '운동 전후 변화', Icons.directions_run, Colors.purple),
          _buildCategoryCard(
              '수면 관련 분석', '수면 시간과 혈당 관계', Icons.bedtime, Colors.indigo),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
      String title, String description, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(description, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}

// ============================================
// 커스텀 리포트 페이지
// ============================================
class CustomReportsPage extends StatelessWidget {
  const CustomReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('맞춤 리포트')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('리포트 유형', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                    label: const Text('혈당'),
                    selected: true,
                    onSelected: (_) {}),
                ChoiceChip(
                    label: const Text('혈압'),
                    selected: false,
                    onSelected: (_) {}),
                ChoiceChip(
                    label: const Text('종합'),
                    selected: false,
                    onSelected: (_) {}),
              ],
            ),
            const SizedBox(height: 24),
            const Text('기간', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                    label: const Text('1주'),
                    selected: false,
                    onSelected: (_) {}),
                ChoiceChip(
                    label: const Text('1개월'),
                    selected: true,
                    onSelected: (_) {}),
                ChoiceChip(
                    label: const Text('3개월'),
                    selected: false,
                    onSelected: (_) {}),
                ChoiceChip(
                    label: const Text('사용자 지정'),
                    selected: false,
                    onSelected: (_) {}),
              ],
            ),
            const SizedBox(height: 24),
            const Text('포함 항목', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            CheckboxListTile(
              value: true,
              onChanged: (_) {},
              title: const Text('기본 통계'),
              subtitle: const Text('평균, 최고/최저, 표준편차'),
            ),
            CheckboxListTile(
              value: true,
              onChanged: (_) {},
              title: const Text('추이 그래프'),
            ),
            CheckboxListTile(
              value: false,
              onChanged: (_) {},
              title: const Text('AI 분석'),
            ),
            CheckboxListTile(
              value: true,
              onChanged: (_) {},
              title: const Text('권장 사항'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.description),
                label: const Text('리포트 생성'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// 분석 데이터 내보내기 페이지
// ============================================
class AnalysisExportPage extends StatelessWidget {
  const AnalysisExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('분석 데이터 내보내기')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  title: const Text('PDF 분석 리포트'),
                  subtitle: const Text('그래프와 통계 포함'),
                  trailing: IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () {},
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.table_chart, color: Colors.green),
                  title: const Text('Excel 데이터'),
                  subtitle: const Text('원본 데이터 + 분석'),
                  trailing: IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () {},
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.image, color: Colors.blue),
                  title: const Text('그래프 이미지'),
                  subtitle: const Text('PNG 형식'),
                  trailing: IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('연동 서비스',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ListTile(
                    leading: const Icon(Icons.health_and_safety),
                    title: const Text('Apple Health'),
                    trailing: Switch(value: true, onChanged: (_) {}),
                  ),
                  ListTile(
                    leading: const Icon(Icons.fitness_center),
                    title: const Text('Google Fit'),
                    trailing: Switch(value: false, onChanged: (_) {}),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
