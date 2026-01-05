import 'package:flutter/material.dart';

/// AI 코치 페이지들 - Phase 3 구현
/// AiCoachMain, HealthCoaching, EnvironmentCoaching, AiPredictions, LearningHistory, AiInsight

// ============================================
// AI 코치 메인 페이지
// ============================================
class AiCoachMainPage extends StatelessWidget {
  const AiCoachMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 코치'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // AI 아바타
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.smart_toy,
                        color: Colors.white, size: 48),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'MPS AI 코치',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '안녕하세요! 오늘 건강 상태는 어떠세요?',
                    style: TextStyle(color: Colors.white.withOpacity(0.9)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 빠른 액션
            Row(
              children: [
                Expanded(
                    child: _buildQuickAction('채팅', Icons.chat, Colors.blue)),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildQuickAction('음성', Icons.mic, Colors.green)),
                const SizedBox(width: 12),
                Expanded(
                    child:
                        _buildQuickAction('이력', Icons.history, Colors.orange)),
              ],
            ),
            const SizedBox(height: 24),

            // AI 기능 메뉴
            _buildMenuItem('건강 코칭', '맞춤형 건강 조언', Icons.favorite, Colors.red),
            _buildMenuItem('환경 코칭', '생활 환경 개선', Icons.eco, Colors.green),
            _buildMenuItem(
                'AI 예측', '건강 추이 예측', Icons.auto_graph, Colors.purple),
            _buildMenuItem('학습 이력', 'AI 학습 기록', Icons.school, Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(String label, IconData icon, Color color) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      String title, String subtitle, IconData icon, Color color) {
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
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}

// ============================================
// 건강 코칭 페이지
// ============================================
class HealthCoachingPage extends StatelessWidget {
  const HealthCoachingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('건강 코칭')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCoachingCard(
            '혈당 관리',
            '현재 혈당 수치가 안정적입니다. 식후 혈당 관리에 집중하세요.',
            Icons.water_drop,
            Colors.purple,
          ),
          _buildCoachingCard(
            '영양 가이드',
            '저GI 식품 위주로 식단을 구성하면 혈당 조절에 도움이 됩니다.',
            Icons.restaurant,
            Colors.green,
          ),
          _buildCoachingCard(
            '운동 추천',
            '식후 15분 걷기가 혈당 조절에 효과적입니다.',
            Icons.directions_walk,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildCoachingCard(
      String title, String advice, IconData icon, Color color) {
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
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 12),
            Text(advice,
                style: TextStyle(color: Colors.grey[700], height: 1.4)),
          ],
        ),
      ),
    );
  }
}

// ============================================
// 환경 코칭 페이지
// ============================================
class EnvironmentCoachingPage extends StatelessWidget {
  const EnvironmentCoachingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('환경 코칭')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildEnvCard('수면 환경', '침실 온도 18-22°C 유지', Icons.bedroom_parent,
              Colors.indigo, 0.8),
          _buildEnvCard('실내 공기', '정기적인 환기 권장', Icons.air, Colors.cyan, 0.6),
          _buildEnvCard(
              '조명', '저녁 청색광 노출 줄이기', Icons.light_mode, Colors.amber, 0.7),
          _buildEnvCard(
              '소음', '수면 시 조용한 환경', Icons.volume_off, Colors.grey, 0.9),
        ],
      ),
    );
  }

  Widget _buildEnvCard(
      String title, String advice, IconData icon, Color color, double score) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(advice,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: score,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text('${(score * 100).toInt()}',
                style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}

// ============================================
// AI 예측 페이지
// ============================================
class AiPredictionsPage extends StatelessWidget {
  const AiPredictionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('AI 예측')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 예측 카드
            Card(
              color: theme.colorScheme.primaryContainer.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(Icons.auto_graph,
                        size: 48, color: Colors.purple),
                    const SizedBox(height: 12),
                    const Text('AI 예측 분석',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 8),
                    Text('마지막 분석: 오늘 08:00',
                        style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 예측 항목
            _buildPrediction('7일 후 평균 혈당', '92-98 mg/dL', Colors.green, '안정'),
            _buildPrediction('다음 주 변동성', '낮음', Colors.blue, '개선'),
            _buildPrediction('3개월 후 HbA1c', '5.5-5.8%', Colors.purple, '유지'),
          ],
        ),
      ),
    );
  }

  Widget _buildPrediction(
      String title, String value, Color color, String trend) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title),
        subtitle: Text('예상: $value'),
        trailing: Chip(
          label: Text(trend),
          backgroundColor: color.withOpacity(0.1),
          labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// ============================================
// 학습 이력 페이지
// ============================================
class LearningHistoryPage extends StatelessWidget {
  const LearningHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('학습 이력')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 학습 통계
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat('총 데이터', '1,234'),
                  _buildStat('학습 기간', '35일'),
                  _buildStat('정확도', '94%'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 학습 기록
          const Text('최근 학습 기록', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildLearningItem('혈당 패턴 분석', '새로운 패턴 발견', '오늘'),
          _buildLearningItem('식사 영향 분석', '모델 업데이트', '어제'),
          _buildLearningItem('수면 상관관계', '분석 완료', '3일 전'),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _buildLearningItem(String title, String status, String time) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.psychology)),
        title: Text(title),
        subtitle: Text(status),
        trailing: Text(time, style: const TextStyle(color: Colors.grey)),
      ),
    );
  }
}

// ============================================
// AI 인사이트 상세 페이지
// ============================================
class AiInsightDetailPage extends StatelessWidget {
  final String? insightId;

  const AiInsightDetailPage({super.key, this.insightId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI 인사이트')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 인사이트 헤더
            Card(
              color: Colors.purple.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(Icons.insights, color: Colors.purple, size: 48),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('혈당 패턴 발견',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(height: 4),
                          Text('오늘 발견됨',
                              style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 상세 내용
            const Text('분석 결과',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            const Text(
              '지난 2주간 데이터를 분석한 결과, 점심 식후 혈당이 오후 2-4시 사이에 평균보다 15% 높게 나타나는 패턴이 발견되었습니다.\n\n이는 점심 식사의 탄수화물 비율과 관련이 있을 수 있습니다.',
              style: TextStyle(height: 1.6),
            ),
            const SizedBox(height: 24),

            // 권장 조치
            const Text('권장 조치',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            _buildAction('점심 탄수화물 양 조절'),
            _buildAction('식후 가벼운 산책'),
            _buildAction('오후 간식 줄이기'),
          ],
        ),
      ),
    );
  }

  Widget _buildAction(String text) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.check_circle_outline, color: Colors.green),
        title: Text(text),
      ),
    );
  }
}
