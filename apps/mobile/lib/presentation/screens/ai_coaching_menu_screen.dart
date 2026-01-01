import 'package:flutter/material.dart';

class AICoachingMenuScreen extends StatelessWidget {
  const AICoachingMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI 주치의')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildMenuCard(
            context,
            'AI 상담 채팅',
            '주치의와 실시간으로 건강 상담을 나누세요.',
            Icons.chat_bubble_outline,
            Colors.cyan,
          ),
          const SizedBox(height: 20),
          _buildMenuCard(
            context,
            '코칭 히스토리',
            '과거의 코칭 기록과 건강 변화를 확인하세요.',
            Icons.history,
            Colors.purple,
          ),
          const SizedBox(height: 20),
          _buildMenuCard(
            context,
            '의학 연구 라이브러리',
            '내 건강과 관련된 최신 논문과 연구 자료입니다.',
            Icons.library_books,
            Colors.amber,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, String desc, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.slate[900],
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(desc, style: TextStyle(color: Colors.slate[500], fontSize: 13)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.slate[700]),
        ],
      ),
    );
  }
}
