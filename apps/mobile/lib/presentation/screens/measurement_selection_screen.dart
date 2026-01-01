import 'package:flutter/material.dart';
import 'measurement_screen.dart';

class MeasurementSelectionScreen extends StatelessWidget {
  const MeasurementSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('측정 유형 선택')),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: [
          _buildSelectionCard(context, '표적 측정', '특정 바이오마커 분석', Icons.gps_fixed, Colors.cyan),
          _buildSelectionCard(context, '비표적 측정', '전자코/전자혀 패턴 분석', Icons.Blur_on, Colors.purple),
          _buildSelectionCard(context, 'EHD 기체', '기체 농도 및 흐름 분석', Icons.air, Colors.blue),
          _buildSelectionCard(context, '비침습 측정', '광학/임피던스 생체 신호', Icons.waves, Colors.green),
        ],
      ),
    );
  }

  Widget _buildSelectionCard(BuildContext context, String title, String desc, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MeasurementScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              desc,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.slate[500], fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
