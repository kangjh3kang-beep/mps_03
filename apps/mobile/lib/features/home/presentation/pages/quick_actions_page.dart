import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 빠른 실행 페이지 - 자주 사용하는 기능 바로가기
class QuickActionsPage extends StatelessWidget {
  const QuickActionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('빠른 실행'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditDialog(context),
            tooltip: '편집',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 즐겨찾기 액션
            Text(
              '즐겨찾기',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildFavoriteActions(context),

            const SizedBox(height: 24),

            // 측정 관련
            Text(
              '측정',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildActionGrid(context, _measurementActions),

            const SizedBox(height: 24),

            // 건강 관리
            Text(
              '건강 관리',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildActionGrid(context, _healthActions),

            const SizedBox(height: 24),

            // 기타
            Text(
              '기타',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildActionGrid(context, _otherActions),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteActions(BuildContext context) {
    final favorites = [
      _QuickAction('혈당 측정', Icons.water_drop, Colors.purple,
          '/measurement/cartridge-detection'),
      _QuickAction('AI 상담', Icons.smart_toy, Colors.blue, '/ai-coach/chat'),
      _QuickAction('건강 점수', Icons.favorite, Colors.red, '/home/health-score'),
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final action = favorites[index];
          return Container(
            width: 120,
            margin:
                EdgeInsets.only(right: index < favorites.length - 1 ? 12 : 0),
            child: _buildLargeActionCard(context, action),
          );
        },
      ),
    );
  }

  Widget _buildLargeActionCard(BuildContext context, _QuickAction action) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push(action.route),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                action.color.withOpacity(0.1),
                action.color.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(action.icon, color: action.color, size: 32),
              const SizedBox(height: 8),
              Text(
                action.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: action.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionGrid(BuildContext context, List<_QuickAction> actions) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        return _buildActionItem(context, actions[index]);
      },
    );
  }

  Widget _buildActionItem(BuildContext context, _QuickAction action) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => context.push(action.route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: action.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(action.icon, color: action.color),
          ),
          const SizedBox(height: 8),
          Text(
            action.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '빠른 실행 편집',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              '즐겨찾기에 표시할 항목을 선택하고 순서를 변경할 수 있습니다.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('확인'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static final _measurementActions = [
    _QuickAction('혈당', Icons.water_drop, Colors.purple, '/measurement'),
    _QuickAction('혈압', Icons.favorite, Colors.red, '/measurement'),
    _QuickAction('체온', Icons.thermostat, Colors.orange, '/measurement'),
    _QuickAction('콜레스테롤', Icons.science, Colors.teal, '/measurement'),
  ];

  static final _healthActions = [
    _QuickAction('AI 상담', Icons.smart_toy, Colors.blue, '/ai-coach/chat'),
    _QuickAction('데이터 분석', Icons.analytics, Colors.indigo, '/analysis'),
    _QuickAction(
        '건강 리포트', Icons.description, Colors.green, '/analysis/reports'),
    _QuickAction('화상 진료', Icons.video_call, Colors.cyan, '/telemedicine'),
  ];

  static final _otherActions = [
    _QuickAction('마켓', Icons.shopping_bag, Colors.pink, '/marketplace'),
    _QuickAction('커뮤니티', Icons.people, Colors.amber, '/community'),
    _QuickAction('가족 공유', Icons.family_restroom, Colors.brown, '/family'),
    _QuickAction('설정', Icons.settings, Colors.grey, '/settings'),
  ];
}

class _QuickAction {
  final String title;
  final IconData icon;
  final Color color;
  final String route;

  _QuickAction(this.title, this.icon, this.color, this.route);
}
