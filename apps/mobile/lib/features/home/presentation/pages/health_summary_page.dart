import 'package:flutter/material.dart';

/// 건강 요약 페이지 - 주간/월간 건강 리포트
class HealthSummaryPage extends StatefulWidget {
  const HealthSummaryPage({super.key});

  @override
  State<HealthSummaryPage> createState() => _HealthSummaryPageState();
}

class _HealthSummaryPageState extends State<HealthSummaryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('건강 요약'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '오늘'),
            Tab(text: '주간'),
            Tab(text: '월간'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDailySummary(theme),
          _buildWeeklySummary(theme),
          _buildMonthlySummary(theme),
        ],
      ),
    );
  }

  Widget _buildDailySummary(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 오늘의 건강 점수
          _buildScoreCard(theme, '오늘의 건강 점수', 85, '어제보다 +5점'),
          const SizedBox(height: 24),

          // 측정 현황
          Text('오늘의 측정',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildMeasurementSummary([
            {'label': '혈당', 'value': '95 mg/dL', 'status': 'normal'},
            {'label': '혈압', 'value': '120/80', 'status': 'normal'},
            {'label': '심박수', 'value': '72 BPM', 'status': 'normal'},
          ]),

          const SizedBox(height: 24),

          // 활동 기록
          Text('활동 기록',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildActivityRow(
              '걸음 수', '8,234', Icons.directions_walk, Colors.blue),
          _buildActivityRow('수면', '7시간 23분', Icons.bedtime, Colors.purple),
          _buildActivityRow('물 섭취', '1.5L', Icons.water_drop, Colors.cyan),
        ],
      ),
    );
  }

  Widget _buildWeeklySummary(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildScoreCard(theme, '주간 평균 점수', 82, '지난주와 동일'),
          const SizedBox(height: 24),

          // 주간 추이
          Text('주간 추이',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildWeeklyChart(theme),

          const SizedBox(height: 24),

          // 주간 통계
          Text('주간 통계',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: _buildStatCard(
                      '측정 횟수', '14회', Icons.science, Colors.teal)),
              const SizedBox(width: 12),
              Expanded(
                  child: _buildStatCard(
                      '정상 비율', '92%', Icons.check_circle, Colors.green)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: _buildStatCard(
                      '평균 혈당', '98 mg/dL', Icons.water_drop, Colors.purple)),
              const SizedBox(width: 12),
              Expanded(
                  child: _buildStatCard(
                      '평균 혈압', '118/78', Icons.favorite, Colors.red)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlySummary(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildScoreCard(theme, '이번 달 평균 점수', 80, '지난달 대비 +3점'),
          const SizedBox(height: 24),

          // 월간 하이라이트
          Text('월간 하이라이트',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildHighlightCard(
            icon: Icons.trending_up,
            color: Colors.green,
            title: '혈당 관리 개선',
            description: '공복 혈당 평균이 지난달 대비 5mg/dL 감소했습니다.',
          ),
          _buildHighlightCard(
            icon: Icons.emoji_events,
            color: Colors.amber,
            title: '측정 목표 달성',
            description: '이번 달 목표 측정 횟수를 100% 달성했습니다!',
          ),
          _buildHighlightCard(
            icon: Icons.lightbulb,
            color: Colors.blue,
            title: 'AI 추천',
            description: '식후 혈당 관리를 위해 식사 후 가벼운 산책을 권장합니다.',
          ),

          const SizedBox(height: 24),

          // 상세 리포트 버튼
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.description),
              label: const Text('상세 리포트 다운로드'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(
      ThemeData theme, String title, int score, String change) {
    Color scoreColor = score >= 80
        ? Colors.green
        : score >= 60
            ? Colors.orange
            : Colors.red;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [scoreColor.withOpacity(0.1), scoreColor.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation(scoreColor),
                  ),
                ),
                Text(
                  '$score',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: scoreColor,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: scoreColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      change,
                      style: TextStyle(
                        color: scoreColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeasurementSummary(List<Map<String, String>> items) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: items.map((item) {
          return ListTile(
            leading: Icon(
              item['status'] == 'normal' ? Icons.check_circle : Icons.warning,
              color: item['status'] == 'normal' ? Colors.green : Colors.orange,
            ),
            title: Text(item['label']!),
            trailing: Text(
              item['value']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActivityRow(
      String label, String value, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(label),
        trailing:
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildWeeklyChart(ThemeData theme) {
    final days = ['월', '화', '수', '목', '금', '토', '일'];
    final scores = [78, 82, 85, 80, 88, 75, 85];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(7, (index) {
            return Column(
              children: [
                Text(
                  '${scores[index]}',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 30,
                  height: scores[index].toDouble(),
                  decoration: BoxDecoration(
                    color: index == 6
                        ? theme.colorScheme.primary
                        : theme.colorScheme.primary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  days[index],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        index == 6 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightCard({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description, style: const TextStyle(fontSize: 12)),
      ),
    );
  }
}
