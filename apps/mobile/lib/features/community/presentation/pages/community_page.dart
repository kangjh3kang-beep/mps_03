import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/bloc/community_bloc.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('커뮤니티')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<CommunityBloc, CommunityState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                _TabSelector(),
                _PostListCard(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TabSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tabs = ['전체', 'Q&A', '챌린지', '팔로우'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: tabs.map((tab) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FilterChip(
                label: Text(tab),
                onSelected: (selected) {
                  context.read<CommunityBloc>().add(
                    FilterPosts(filter: tab),
                  );
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _PostListCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        child: Text('${index + 1}'),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('사용자 #${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const Text('2시간 전', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('포스트 #${index + 1} 제목입니다'),
                  const SizedBox(height: 8),
                  const Text(
                    '이것은 커뮤니티 포스트의 본문입니다. 사용자들이 경험과 팁을 공유하는 공간입니다.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ActionButton(icon: Icons.thumb_up, label: '좋아요 ${10 + index}'),
                      _ActionButton(icon: Icons.comment, label: '댓글 ${5 + index}'),
                      _ActionButton(icon: Icons.share, label: '공유'),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
