import 'package:flutter/material.dart';

class HealthScenarioScreen extends StatefulWidget {
  const HealthScenarioScreen({super.key});

  @override
  State<HealthScenarioScreen> createState() => _HealthScenarioScreenState();
}

class _HealthScenarioScreenState extends State<HealthScenarioScreen> {
  double _lifestyleScore = 0.7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('미래 건강 시뮬레이션')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '생활 습관에 따른 미래 예측',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              '현재의 생활 습관이 유지될 경우의 1년 후 건강 상태를 예측합니다.',
              style: TextStyle(color: Colors.slate[500]),
            ),
            const SizedBox(height: 40),
            _buildSimulationCard(),
            const SizedBox(height: 40),
            const Text('생활 습관 조절 시뮬레이션', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Slider(
              value: _lifestyleScore,
              onChanged: (val) => setState(() => _lifestyleScore = val),
              activeColor: Colors.cyan,
              inactiveColor: Colors.slate[800],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('부족', style: TextStyle(color: Colors.red, fontSize: 12)),
                Text('보통', style: TextStyle(color: Colors.amber, fontSize: 12)),
                Text('우수', style: TextStyle(color: Colors.green, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 40),
            _buildActionGuide(),
          ],
        ),
      ),
    );
  }

  Widget _buildSimulationCard() {
    Color healthColor = _lifestyleScore > 0.8 ? Colors.green : _lifestyleScore > 0.4 ? Colors.amber : Colors.red;
    String healthStatus = _lifestyleScore > 0.8 ? '매우 건강' : _lifestyleScore > 0.4 ? '주의 필요' : '위험군';

    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.slate[900],
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: healthColor.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          const Text('1년 후 예상 건강 점수', style: TextStyle(color: Colors.slate[400])),
          const SizedBox(height: 16),
          Text(
            '${(_lifestyleScore * 100).toInt()}',
            style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: healthColor),
          ),
          Text(
            healthStatus,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: healthColor),
          ),
          const SizedBox(height: 30),
          const Divider(color: Colors.slate[800]),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _miniStat('대사 질환 위험', '${(100 - _lifestyleScore * 80).toInt()}%'),
              _miniStat('심혈관 건강', '${(_lifestyleScore * 90).toInt()}%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.slate[500], fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildActionGuide() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.cyan.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb, color: Colors.cyan),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              _lifestyleScore > 0.6 
                ? '현재의 긍정적인 습관을 유지하시면 건강한 노후가 보장됩니다.'
                : '매일 30분 가벼운 산책만으로도 건강 점수를 15점 올릴 수 있습니다.',
              style: const TextStyle(fontSize: 14, color: Colors.cyan),
            ),
          ),
        ],
      ),
    );
  }
}
