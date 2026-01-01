import 'package:flutter/material.dart';

class ExternalDataScreen extends StatefulWidget {
  const ExternalDataScreen({super.key});

  @override
  State<ExternalDataScreen> createState() => _ExternalDataScreenState();
}

class _ExternalDataScreenState extends State<ExternalDataScreen> {
  bool _appleHealthConnected = false;
  bool _googleFitConnected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('외부 데이터 연동')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            '건강 데이터 통합',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            '다른 건강 앱의 데이터를 만파식 AI와 연동하여 더 정밀한 분석을 받으세요.',
            style: TextStyle(color: Colors.slate[500]),
          ),
          const SizedBox(height: 40),
          _buildIntegrationTile(
            'Apple Health',
            '활동량, 수면, 심박수 데이터 연동',
            Icons.apple,
            Colors.white,
            _appleHealthConnected,
            (val) => setState(() => _appleHealthConnected = val),
            trustScore: 0.98,
          ),
          const SizedBox(height: 20),
          _buildIntegrationTile(
            'Google Fit',
            '운동 기록 및 신체 활동 데이터 연동',
            Icons.fitbit,
            Colors.orange,
            _googleFitConnected,
            (val) => setState(() => _googleFitConnected = val),
            trustScore: 0.92,
          ),
          const SizedBox(height: 40),
          _buildIntegrityInfo(),
        ],
      ),
    );
  }

  Widget _buildIntegrationTile(String title, String desc, IconData icon, Color color, bool isConnected, Function(bool) onChanged, {double trustScore = 0.0}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.slate[900],
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isConnected ? Colors.cyan.withOpacity(0.5) : Colors.slate[800]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(desc, style: TextStyle(color: Colors.slate[500], fontSize: 12)),
                  ],
                ),
              ),
              Switch(
                value: isConnected,
                onChanged: onChanged,
                activeColor: Colors.cyan,
              ),
            ],
          ),
          if (isConnected) ...[
            const SizedBox(height: 16),
            const Divider(color: Colors.slate[800]),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.verified_user, color: Colors.green, size: 14),
                    const SizedBox(width: 6),
                    const Text('소스 인증 완료', style: TextStyle(color: Colors.green, fontSize: 11)),
                  ],
                ),
                Text(
                  '신뢰도 점수: ${(trustScore * 100).toInt()}%',
                  style: TextStyle(color: Colors.cyan[200], fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildIntegrityInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.cyan.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.cyan.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.shield_outlined, color: Colors.cyan, size: 20),
              const SizedBox(width: 12),
              const Text(
                '데이터 무결성 보장',
                style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '연동된 모든 데이터는 블록체인 기반 해시 체인 기술로 보호되며, 위변조가 불가능한 상태로 연구 데이터 허브에 안전하게 저장됩니다.',
            style: TextStyle(fontSize: 12, color: Colors.slate[400]),
          ),
        ],
      ),
    );
  }
}
