import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// AI 코칭 메인 페이지
class CoachingPage extends StatefulWidget {
  const CoachingPage({Key? key}) : super(key: key);

  @override
  State<CoachingPage> createState() => _CoachingPageState();
}

class _CoachingPageState extends State<CoachingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 코칭'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 오늘의 목표
          Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('오늘의 목표',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: 0.65,
                    minHeight: 8,
                  ),
                  const SizedBox(height: 12),
                  const Text('65% 달성'),
                  const SizedBox(height: 16),
                  const Text('혈당 관리 & 운동 30분 & 물 2리터 마시기',
                    style: TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 코칭 카테고리
          _CoachingCard(
            icon: Icons.fitness_center,
            title: '운동',
            subtitle: '개인 맞춤 운동 프로그램',
            onTap: () => context.push('/coaching/exercise'),
          ),
          _CoachingCard(
            icon: Icons.restaurant,
            title: '영양',
            subtitle: '식단 관리 및 영양 상담',
            onTap: () => context.push('/coaching/nutrition'),
          ),
          _CoachingCard(
            icon: Icons.bedtime,
            title: '수면',
            subtitle: '수면 패턴 개선',
            onTap: () => context.push('/coaching/mindfulness'),
          ),
          _CoachingCard(
            icon: Icons.emoji_events,
            title: '챌린지',
            subtitle: '건강 챌린지 참여',
            onTap: () => context.push('/coaching/challenges'),
          ),

          const SizedBox(height: 24),

          // AI 채팅
          Card(
            child: ListTile(
              leading: const Icon(Icons.chat, color: Colors.blue),
              title: const Text('AI 의사와 상담'),
              subtitle: const Text('실시간 건강 상담'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => context.push('/ai-physician/chat'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoachingCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _CoachingCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          leading: Icon(icon, color: Colors.blue, size: 32),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ),
    );
  }
}

/// 운동 코칭 페이지
class ExerciseCoachingPage extends StatelessWidget {
  const ExerciseCoachingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('운동 코칭'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 운동 목표
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('이주 운동 목표',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  _GoalItem(label: '일주일 운동', target: '5회', current: '3회'),
                  _GoalItem(label: '주당 운동 시간', target: '150분', current: '90분'),
                  _GoalItem(label: '걷기 거리', target: '50km', current: '35km'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 추천 운동
          const Text('오늘 추천 운동', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),

          _ExerciseCard(
            name: '가벼운 산책',
            duration: '30분',
            intensity: '낮음',
            calories: '120kcal',
            color: Colors.green,
          ),
          _ExerciseCard(
            name: '빠르기 걷기',
            duration: '20분',
            intensity: '중간',
            calories: '180kcal',
            color: Colors.orange,
          ),
          _ExerciseCard(
            name: '조깅',
            duration: '15분',
            intensity: '높음',
            calories: '240kcal',
            color: Colors.red,
          ),

          const SizedBox(height: 24),

          // 운동 기록
          const Text('최근 운동 기록', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          _ActivityLogItem(
            date: '오늘',
            activity: '산책',
            duration: '30분',
            calories: '120kcal',
          ),
          _ActivityLogItem(
            date: '어제',
            activity: '조깅',
            duration: '15분',
            calories: '240kcal',
          ),
          _ActivityLogItem(
            date: '2일 전',
            activity: '수영',
            duration: '45분',
            calories: '350kcal',
          ),
        ],
      ),
    );
  }
}

/// 영양 코칭 페이지
class NutritionCoachingPage extends StatelessWidget {
  const NutritionCoachingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('영양 코칭'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 영양 정보
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('오늘 섭취 영양소',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  _NutrientBar(
                    label: '탄수화물',
                    value: 250,
                    target: 300,
                    color: Colors.orange,
                  ),
                  _NutrientBar(
                    label: '단백질',
                    value: 60,
                    target: 75,
                    color: Colors.red,
                  ),
                  _NutrientBar(
                    label: '지방',
                    value: 50,
                    target: 65,
                    color: Colors.yellow,
                  ),
                  _NutrientBar(
                    label: '식이섬유',
                    value: 18,
                    target: 25,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 식사 제안
          const Text('추천 식사', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),

          _MealCard(
            meal: '아침',
            suggestion: '계란 2개 + 현미밥 + 시금치 나물',
            calories: '420kcal',
          ),
          _MealCard(
            meal: '점심',
            suggestion: '구운 닭가슴살 + 고구마 + 브로콜리',
            calories: '580kcal',
          ),
          _MealCard(
            meal: '저녁',
            suggestion: '흰살 생선 + 현미밥 + 야채 국',
            calories: '450kcal',
          ),

          const SizedBox(height: 24),

          // 영양 정보
          Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('영양 팁',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const Text('• 단백질을 충분히 섭취하세요 (현재 80%)',
                    style: TextStyle(fontSize: 13)),
                  const SizedBox(height: 8),
                  const Text('• 식이섬유 섭취를 늘려보세요 (현재 72%)',
                    style: TextStyle(fontSize: 13)),
                  const SizedBox(height: 8),
                  const Text('• 과자나 음료수는 제한하세요',
                    style: TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 마음챙김 페이지
class MindfulnessPage extends StatelessWidget {
  const MindfulnessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('수면 & 스트레스 관리'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 수면 정보
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('어제 수면',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _SleepStat(label: '수면 시간', value: '7.5시간'),
                      _SleepStat(label: '수면 질', value: '82점'),
                      _SleepStat(label: '깨어난 횟수', value: '2회'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 스트레스 수준
          const Text('오늘 스트레스 수준', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Slider(
                    value: 45,
                    onChanged: (_) {},
                    min: 0,
                    max: 100,
                  ),
                  const Text('중간 수준 (45/100)', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 명상 프로그램
          const Text('추천 명상 프로그램', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),

          _MeditationCard(
            title: '5분 스트레스 해소 명상',
            description: '업무 중간에 하는 짧은 명상',
            duration: '5분',
          ),
          _MeditationCard(
            title: '수면 유도 명상',
            description: '자기 전 긴장을 풀어주는 명상',
            duration: '15분',
          ),
          _MeditationCard(
            title: '아침 활력 명상',
            description: '하루를 시작하는 명상',
            duration: '10분',
          ),

          const SizedBox(height: 24),

          // 수면 팁
          Card(
            color: Colors.purple[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('수면 개선 팁',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const Text('• 매일 같은 시간에 자고 일어나세요',
                    style: TextStyle(fontSize: 13)),
                  const SizedBox(height: 8),
                  const Text('• 자기 1시간 전에 스크린을 보지 마세요',
                    style: TextStyle(fontSize: 13)),
                  const SizedBox(height: 8),
                  const Text('• 낮 운동으로 숙면을 유도하세요',
                    style: TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 챌린지 페이지
class ChallengeDetailPage extends StatelessWidget {
  const ChallengeDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('건강 챌린지'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 진행중인 챌린지
          const Text('진행 중인 챌린지', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),

          _ChallengeCard(
            title: '30일 운동 챌린지',
            progress: 18,
            target: 30,
            reward: '배지 + 1000포인트',
            status: 'in_progress',
          ),
          _ChallengeCard(
            title: '물 마시기 챌린지',
            progress: 15,
            target: 30,
            reward: '배지 + 500포인트',
            status: 'in_progress',
          ),

          const SizedBox(height: 24),

          // 완료된 챌린지
          const Text('완료된 챌린지', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),

          _ChallengeCard(
            title: '일주일 스트레칭',
            progress: 7,
            target: 7,
            reward: '배지 + 300포인트',
            status: 'completed',
          ),

          const SizedBox(height: 24),

          // 추천 챌린지
          const Text('추천 챌린지', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),

          _ChallengeCard(
            title: '10분 조깅 챌린지',
            progress: 0,
            target: 10,
            reward: '배지 + 200포인트',
            status: 'available',
          ),
          _ChallengeCard(
            title: '채소 섭취 챌린지',
            progress: 0,
            target: 21,
            reward: '배지 + 500포인트',
            status: 'available',
          ),
        ],
      ),
    );
  }
}

// ============ 헬퍼 위젯들 ============

class _GoalItem extends StatelessWidget {
  final String label;
  final String target;
  final String current;

  const _GoalItem({
    required this.label,
    required this.target,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text('$current / $target', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
        ],
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final String name;
  final String duration;
  final String intensity;
  final String calories;
  final Color color;

  const _ExerciseCard({
    required this.name,
    required this.duration,
    required this.intensity,
    required this.calories,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$duration • $intensity 강도'),
        trailing: Text(calories, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _ActivityLogItem extends StatelessWidget {
  final String date;
  final String activity;
  final String duration;
  final String calories;

  const _ActivityLogItem({
    required this.date,
    required this.activity,
    required this.duration,
    required this.calories,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text('$date: $activity'),
        subtitle: Text('$duration • $calories'),
      ),
    );
  }
}

class _NutrientBar extends StatelessWidget {
  final String label;
  final double value;
  final double target;
  final Color color;

  const _NutrientBar({
    required this.label,
    required this.value,
    required this.target,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (value / target * 100).clamp(0, 100);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Text('${value.toInt()} / ${target.toInt()}g'),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  final String meal;
  final String suggestion;
  final String calories;

  const _MealCard({
    required this.meal,
    required this.suggestion,
    required this.calories,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          meal == '아침'
              ? Icons.wb_sunny
              : meal == '점심'
                  ? Icons.cloud
                  : Icons.nights_stay,
          color: Colors.orange,
        ),
        title: Text(meal, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(suggestion),
        trailing: Text(calories, style: const TextStyle(color: Colors.green)),
      ),
    );
  }
}

class _SleepStat extends StatelessWidget {
  final String label;
  final String value;

  const _SleepStat({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _MeditationCard extends StatelessWidget {
  final String title;
  final String description;
  final String duration;

  const _MeditationCard({
    required this.title,
    required this.description,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.spa, color: Colors.purple),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$description • $duration'),
        trailing: const Icon(Icons.play_circle, color: Colors.purple),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title 명상을 시작합니다')),
          );
        },
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  final String title;
  final int progress;
  final int target;
  final String reward;
  final String status;

  const _ChallengeCard({
    required this.title,
    required this.progress,
    required this.target,
    required this.reward,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (progress / target) * 100;
    final isCompleted = status == 'completed';

    return Card(
      color: isCompleted ? Colors.green[50] : null,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                if (isCompleted)
                  const Icon(Icons.check_circle, color: Colors.green)
                else
                  Text('$progress/$target', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage / 100,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 12),
            Text('🎁 $reward', style: const TextStyle(fontSize: 13, color: Colors.orange)),
            if (status == 'available')
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$title에 참여했습니다!')),
                      );
                    },
                    child: const Text('참여'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
