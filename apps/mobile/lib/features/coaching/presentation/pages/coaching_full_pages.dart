import 'package:flutter/material.dart';

/// 코칭 페이지들 - Phase 3 구현
/// CoachingMain, Recommendations, Plans, Progress, Exercises, Nutrition, Sleep,
/// Stress, Conversations, Achievements, Milestones, Feedback, History

// ============================================
// 코칭 메인 페이지
// ============================================
class CoachingMainPage extends StatelessWidget {
  const CoachingMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 코칭'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 오늘의 코칭
            Card(
              color: theme.colorScheme.primaryContainer.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.psychology,
                          color: theme.colorScheme.primary, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('오늘의 코칭',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(height: 4),
                          Text('3개의 권장사항이 있습니다',
                              style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 코칭 카테고리
            Text('코칭 영역',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildCategoryCard(context, '영양', Icons.restaurant,
                    Colors.green, '/coaching/nutrition'),
                _buildCategoryCard(context, '운동', Icons.fitness_center,
                    Colors.orange, '/coaching/exercises'),
                _buildCategoryCard(context, '수면', Icons.bedtime, Colors.purple,
                    '/coaching/sleep'),
                _buildCategoryCard(context, '스트레스', Icons.spa, Colors.teal,
                    '/coaching/stress'),
              ],
            ),
            const SizedBox(height: 24),

            // 진행 상황
            Text('나의 진행률',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('이번 주 목표'),
                        Text('75%',
                            style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: 0.75,
                      backgroundColor: Colors.grey[200],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, IconData icon,
      Color color, String route) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================
// 권장사항 페이지
// ============================================
class CoachingRecommendationsPage extends StatelessWidget {
  const CoachingRecommendationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('권장사항')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildRecommendation(
              '오늘 점심 후 15분 산책을 해보세요', Icons.directions_walk, Colors.blue, true),
          _buildRecommendation(
              '물 500ml 더 마시기', Icons.water_drop, Colors.cyan, false),
          _buildRecommendation(
              '저녁 식사 시 탄수화물 줄이기', Icons.restaurant, Colors.orange, false),
          _buildRecommendation(
              '오후 10시 전 취침 준비', Icons.bedtime, Colors.purple, false),
        ],
      ),
    );
  }

  Widget _buildRecommendation(
      String text, IconData icon, Color color, bool completed) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: CheckboxListTile(
        value: completed,
        onChanged: (_) {},
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          text,
          style: TextStyle(
            decoration: completed ? TextDecoration.lineThrough : null,
            color: completed ? Colors.grey : null,
          ),
        ),
      ),
    );
  }
}

// ============================================
// 건강 계획 페이지
// ============================================
class HealthPlansPage extends StatelessWidget {
  const HealthPlansPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('건강 계획')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPlanCard('혈당 관리 플랜', '4주 프로그램', 0.6, Colors.purple),
          _buildPlanCard('체중 관리 플랜', '8주 프로그램', 0.3, Colors.green),
          _buildPlanCard('활력 증진 플랜', '2주 프로그램', 0.9, Colors.orange),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('새 계획'),
      ),
    );
  }

  Widget _buildPlanCard(
      String title, String duration, double progress, Color color) {
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
                  child: Icon(Icons.flag, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(duration,
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 12)),
                    ],
                  ),
                ),
                Text('${(progress * 100).toInt()}%',
                    style:
                        TextStyle(color: color, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// 진행 추적 페이지
// ============================================
class ProgressTrackingPage extends StatelessWidget {
  const ProgressTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('진행 추적')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 주간 요약
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text('이번 주 달성률', style: TextStyle(color: Colors.grey[600])),
                    const SizedBox(height: 8),
                    Text('78%',
                        style: theme.textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.green)),
                    const SizedBox(height: 8),
                    const Text('지난 주보다 +5%',
                        style: TextStyle(color: Colors.green)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 일별 체크
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(7, (index) {
                    bool completed = index < 5;
                    return Column(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: completed ? Colors.green : Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            completed ? Icons.check : null,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(['월', '화', '수', '목', '금', '토', '일'][index],
                            style: const TextStyle(fontSize: 12)),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// 운동 페이지
// ============================================
class ExercisesPage extends StatelessWidget {
  const ExercisesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('운동 코칭')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildExerciseCard(
              '가벼운 산책', '15분', Icons.directions_walk, Colors.green),
          _buildExerciseCard(
              '스트레칭', '10분', Icons.self_improvement, Colors.purple),
          _buildExerciseCard(
              '가벼운 조깅', '20분', Icons.directions_run, Colors.orange),
          _buildExerciseCard('요가', '30분', Icons.spa, Colors.teal),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(
      String title, String duration, IconData icon, Color color) {
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
        subtitle: Text(duration),
        trailing: ElevatedButton(
          onPressed: () {},
          child: const Text('시작'),
        ),
      ),
    );
  }
}

// ============================================
// 영양 페이지
// ============================================
class NutritionPage extends StatelessWidget {
  const NutritionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('영양 코칭')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 오늘의 영양 섭취
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('오늘의 목표',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildNutrientProgress('탄수화물', 0.7, Colors.orange),
                  _buildNutrientProgress('단백질', 0.5, Colors.red),
                  _buildNutrientProgress('지방', 0.4, Colors.blue),
                  _buildNutrientProgress('식이섬유', 0.8, Colors.green),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 권장 식품
          const Text('권장 식품', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                  avatar: const Icon(Icons.eco, size: 16),
                  label: const Text('시금치')),
              Chip(
                  avatar: const Icon(Icons.egg, size: 16),
                  label: const Text('달걀')),
              Chip(
                  avatar: const Icon(Icons.set_meal, size: 16),
                  label: const Text('연어')),
              Chip(
                  avatar: const Icon(Icons.local_florist, size: 16),
                  label: const Text('브로콜리')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientProgress(String name, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(name)),
          Expanded(
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          const SizedBox(width: 8),
          Text('${(value * 100).toInt()}%'),
        ],
      ),
    );
  }
}

// ============================================
// 수면 페이지
// ============================================
class SleepPage extends StatelessWidget {
  const SleepPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('수면 코칭')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 수면 점수
            Card(
              color: Colors.indigo[50],
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(Icons.bedtime, size: 48, color: Colors.indigo),
                    const SizedBox(height: 12),
                    Text('수면 점수', style: TextStyle(color: Colors.grey[600])),
                    Text('85',
                        style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.indigo)),
                    const Text('좋음', style: TextStyle(color: Colors.indigo)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 수면 데이터
            Card(
              child: Column(
                children: [
                  ListTile(
                      leading: const Icon(Icons.access_time),
                      title: const Text('취침 시간'),
                      trailing: const Text('23:00')),
                  const Divider(height: 1),
                  ListTile(
                      leading: const Icon(Icons.wb_sunny),
                      title: const Text('기상 시간'),
                      trailing: const Text('06:30')),
                  const Divider(height: 1),
                  ListTile(
                      leading: const Icon(Icons.timelapse),
                      title: const Text('총 수면'),
                      trailing: const Text('7시간 30분')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// 스트레스 관리 페이지
// ============================================
class StressManagementPage extends StatelessWidget {
  const StressManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('스트레스 관리')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 스트레스 레벨
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('현재 스트레스 레벨'),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return Icon(
                        Icons.circle,
                        color: index < 2 ? Colors.green : Colors.grey[300],
                        size: 24,
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  const Text('낮음',
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 릴렉스 활동
          const Text('추천 활동', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildActivityCard('명상', '5분', Icons.self_improvement, Colors.purple),
          _buildActivityCard('심호흡', '3분', Icons.air, Colors.blue),
          _buildActivityCard('음악 감상', '10분', Icons.music_note, Colors.pink),
        ],
      ),
    );
  }

  Widget _buildActivityCard(
      String title, String duration, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        subtitle: Text(duration),
        trailing: const Icon(Icons.play_circle_outline),
      ),
    );
  }
}

// ============================================
// 코칭 대화 페이지
// ============================================
class CoachingConversationsPage extends StatelessWidget {
  const CoachingConversationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('코칭 대화')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildConversationCard('영양 상담', '어제', '저녁 식단에 대한 조언을 받았습니다'),
          _buildConversationCard('운동 계획', '3일 전', '주간 운동 계획을 세웠습니다'),
          _buildConversationCard('혈당 관리', '1주 전', '혈당 조절 팁을 받았습니다'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.chat),
      ),
    );
  }

  Widget _buildConversationCard(String title, String date, String summary) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.psychology)),
        title: Text(title),
        subtitle: Text(summary, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: Text(date,
            style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ),
    );
  }
}

// ============================================
// 성취 페이지
// ============================================
class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('성취')),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: [
          _buildBadge('첫 측정', Icons.star, Colors.amber, true),
          _buildBadge(
              '7일 연속', Icons.local_fire_department, Colors.orange, true),
          _buildBadge('30일 연속', Icons.emoji_events, Colors.purple, false),
          _buildBadge('목표 달성', Icons.flag, Colors.green, true),
          _buildBadge('공유 마스터', Icons.share, Colors.blue, false),
          _buildBadge('건강 전문가', Icons.workspace_premium, Colors.red, false),
        ],
      ),
    );
  }

  Widget _buildBadge(String title, IconData icon, Color color, bool earned) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: earned ? color.withOpacity(0.1) : Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: earned ? color : Colors.grey, size: 32),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: earned ? null : Colors.grey),
        ),
      ],
    );
  }
}

// ============================================
// 마일스톤 페이지
// ============================================
class MilestonesPage extends StatelessWidget {
  const MilestonesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('마일스톤')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMilestone('시작', '첫 측정 완료', true, '2025.12.01'),
          _buildMilestone('1주차', '7일 연속 측정', true, '2025.12.08'),
          _buildMilestone('1개월', '30일 연속 측정', true, '2025.12.31'),
          _buildMilestone('목표 달성', '혈당 정상화', false, '진행 중'),
          _buildMilestone('마스터', '90일 연속 측정', false, '예정'),
        ],
      ),
    );
  }

  Widget _buildMilestone(
      String title, String description, bool completed, String date) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: completed ? Colors.green : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: completed
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
            Container(width: 2, height: 60, color: Colors.grey[300]),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(description, style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 4),
                  Text(date,
                      style: TextStyle(
                          fontSize: 12,
                          color: completed ? Colors.green : Colors.grey)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================
// 코칭 피드백 페이지
// ============================================
class CoachingFeedbackPage extends StatelessWidget {
  const CoachingFeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('피드백')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('AI 코칭이 도움이 되었나요?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(Icons.star,
                      color: index < 4 ? Colors.amber : Colors.grey[300],
                      size: 40),
                  onPressed: () {},
                );
              }),
            ),
            const SizedBox(height: 24),
            const Text('추가 의견', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: '코칭에 대한 의견을 남겨주세요',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('제출'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// 코칭 이력 페이지
// ============================================
class CoachingHistoryPage extends StatelessWidget {
  const CoachingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('코칭 이력')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.withOpacity(0.1),
                child: const Icon(Icons.psychology, color: Colors.blue),
              ),
              title: Text('코칭 세션 #${10 - index}'),
              subtitle: Text('${index + 1}일 전 • ${3 - (index % 3)}개 권장사항'),
              trailing: const Icon(Icons.chevron_right),
            ),
          );
        },
      ),
    );
  }
}
