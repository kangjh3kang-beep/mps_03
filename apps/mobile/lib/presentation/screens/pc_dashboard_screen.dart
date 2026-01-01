import 'package:flutter/material.dart';

class PCDashboardScreen extends StatelessWidget {
  const PCDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '글로벌 건강 모니터링 (PC)',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.cyan),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Row(
                children: [
                  // 왼쪽: 주요 지표 그리드
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        _buildStatGrid(),
                        const SizedBox(height: 24),
                        Expanded(child: _buildMainChart()),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  // 오른쪽: 실시간 로그 및 알림
                  Expanded(
                    flex: 1,
                    child: _buildSidePanel(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatGrid() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 2,
      children: [
        _statCard('평균 혈당', '95 mg/dL', Icons.bloodtype, Colors.green),
        _statCard('심박수 변동성', '65 ms', Icons.favorite, Colors.cyan),
        _statCard('수면 효율', '88%', Icons.bedtime, Colors.purple),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.slate[900],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.slate500, fontSize: 12)),
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainChart() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.slate[900],
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(
        child: Text('[고밀도 시계열 데이터 그래프 영역]', style: TextStyle(color: Colors.slate600)),
      ),
    );
  }

  Widget _buildSidePanel() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.slate[900],
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('실시간 분석 로그', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    const Icon(Icons.circle, size: 8, color: Colors.cyan),
                    const SizedBox(width: 12),
                    Text('데이터 패킷 수신 완료: Sensor-0${index + 1}', style: const TextStyle(fontSize: 12, color: Colors.slate400)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
