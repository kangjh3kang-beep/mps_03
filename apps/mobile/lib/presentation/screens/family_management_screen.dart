import 'package:flutter/material.dart';
import '../../services/my_data_service.dart';

class FamilyManagementScreen extends StatelessWidget {
  const FamilyManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 실제로는 MyDataService 연동
    final members = [
      {'name': '나', 'relation': '본인', 'status': 'Healthy', 'last': '오늘'},
      {'name': '김만파', 'relation': '부', 'status': 'Warning', 'last': '어제'},
      {'name': '이식', 'relation': '모', 'status': 'Healthy', 'last': '3일 전'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('가족 건강 관리 (MyData)')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: members.length,
        itemBuilder: (context, index) {
          final m = members[index];
          final isWarning = m['status'] == 'Warning';
          
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.slate[900],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isWarning ? Colors.red.withOpacity(0.5) : Colors.cyan.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: isWarning ? Colors.red[900] : Colors.cyan[900],
                  child: Text(m['name']![0], style: const TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(m['name']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: Colors.slate[800], borderRadius: BorderRadius.circular(4)),
                            child: Text(m['relation']!, style: const TextStyle(fontSize: 10, color: Colors.slate400)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('최근 측정: ${m['last']}', style: TextStyle(color: Colors.slate[500], fontSize: 12)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      m['status']!,
                      style: TextStyle(
                        color: isWarning ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.slate600),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.cyan,
        child: const Icon(Icons.person_add, color: Colors.black),
      ),
    );
  }
}
