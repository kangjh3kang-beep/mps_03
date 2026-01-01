import 'package:flutter/material.dart';

class ReaderModeScreen extends StatelessWidget {
  const ReaderModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            _buildHeader(),
            const Spacer(),
            _buildMainStatus(),
            const Spacer(),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'MPS READER v2.2',
          style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        Row(
          children: [
            const Icon(Icons.battery_full, color: Colors.green, size: 30),
            const SizedBox(width: 20),
            const Icon(Icons.bluetooth_connected, color: Colors.blue, size: 30),
          ],
        ),
      ],
    );
  }

  Widget _buildMainStatus() {
    return Column(
      children: [
        const Text('측정 준비 완료', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Text(
          '카트리지를 삽입해 주세요',
          style: TextStyle(color: Colors.slate[500], fontSize: 24),
        ),
        const SizedBox(height: 60),
        Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.cyan.withOpacity(0.3), width: 4),
          ),
          child: const Center(
            child: Icon(Icons.biotech, size: 120, color: Colors.cyan),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _largeButton('시스템 설정', Icons.settings, Colors.slate[800]!),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _largeButton('강제 측정', Icons.play_arrow, Colors.cyan),
        ),
      ],
    );
  }

  Widget _largeButton(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color == Colors.cyan ? Colors.black : Colors.white, size: 32),
          const SizedBox(width: 16),
          Text(
            label,
            style: TextStyle(
              color: color == Colors.cyan ? Colors.black : Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
