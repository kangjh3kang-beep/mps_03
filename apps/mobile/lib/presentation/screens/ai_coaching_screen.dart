import 'package:flutter/material.dart';
import '../../services/ai_physician.dart';

class AICoachingScreen extends StatelessWidget {
  final CoachingResponse response;
  final int earnedPoints;

  const AICoachingScreen({
    super.key,
    required this.response,
    required this.earnedPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI 주치의 코칭')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEmpathyHeader(context),
            const SizedBox(height: 24),
            _buildCoachingMessage(context),
            const SizedBox(height: 24),
            _buildResearchCitations(context),
            const SizedBox(height: 32),
            _buildRewardCard(context),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  minimumSize: const Size(200, 50),
                ),
                child: const Text('확인 완료', style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpathyHeader(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundColor: Colors.cyan,
          child: Icon(Icons.medical_services, color: Colors.black, size: 30),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('내 손안의 주치의', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(
              '공감 지수: ${(response.empathyScore * 100).toInt()}%',
              style: const TextStyle(color: Colors.cyan, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCoachingMessage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.slate[900],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.cyan.withOpacity(0.3)),
      ),
      child: Text(
        response.message,
        style: const TextStyle(fontSize: 16, height: 1.6),
      ),
    );
  }

  Widget _buildResearchCitations(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.library_books, size: 18, color: Colors.amber),
            SizedBox(width: 8),
            Text('참고 문헌 및 연구 근거', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        ...response.citations.map((c) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text('• $c', style: TextStyle(color: Colors.slate[400], fontSize: 13)),
        )),
      ],
    );
  }

  Widget _buildRewardCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.purple, Colors.blue]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('오늘의 건강 보상', style: TextStyle(color: Colors.white70)),
              Text('참여 포인트 획득!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
          Text('+$earnedPoints P', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.amber)),
        ],
      ),
    );
  }
}
