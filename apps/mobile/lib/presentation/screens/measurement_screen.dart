import 'package:flutter/material.dart';
import 'dart:math';
import '../../services/measurement_service.dart';
import '../../services/ai_physician.dart';
import 'ai_coaching_screen.dart';

class MeasurementScreen extends StatefulWidget {
  const MeasurementScreen({super.key});

  @override
  State<MeasurementScreen> createState() => _MeasurementScreenState();
}

class _MeasurementScreenState extends State<MeasurementScreen> {
  MeasurementStep _currentStep = MeasurementStep.ready;
  List<double> _currentData = [];
  List<String> _readers = ['MPS-READER-01 (Connected)'];
  
  void _start() {
    // 실제로는 BLoC을 통해 관리
    setState(() {
      _currentStep = MeasurementStep.ready;
      _currentData = [];
    });
    
    // 시뮬레이션 시작 (예시)
    _simulateProcess();
  }

  void _simulateProcess() async {
    setState(() => _currentStep = MeasurementStep.cartridgeIn);
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() => _currentStep = MeasurementStep.measuring);
    // 데이터 수집 시뮬레이션
    for (int i = 0; i < 10; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _currentData.add(Random().nextDouble() * 100);
      });
    }
    
    setState(() => _currentStep = MeasurementStep.analyzing);
    await Future.delayed(const Duration(seconds: 3));
    
    setState(() => _currentStep = MeasurementStep.completed);
    
    // AI 코칭 화면으로 이동 (시뮬레이션 데이터 기반)
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AICoachingScreen(
            response: CoachingResponse(
              message: "사용자님, 오늘 혈당 수치가 115mg/dL로 측정되었네요. 평소보다 조금 높지만, "
                       "어제 저녁 식사가 조금 늦으셨던 게 영향을 준 것 같아요. 너무 걱정 마세요! "
                       "최근 'Nature Medicine(2025)'에 발표된 논문에 따르면, 일시적인 혈당 상승은 "
                       "가벼운 산책만으로도 20% 이상 빠르게 안정화될 수 있다고 합니다. "
                       "지금 저와 함께 15분만 가볍게 걸어보시는 건 어떨까요? 제가 옆에서 응원할게요!",
              citations: [
                "Nature Medicine (2025): Postprandial Glucose Regulation via Light Physical Activity",
                "Journal of Clinical Endocrinology: Impact of Late-night Meals on Fasting Glucose"
              ],
              empathyScore: 0.98,
            ),
            earnedPoints: 120,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('정밀 측정 및 시뮬레이션')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReaderStatus(),
            const SizedBox(height: 20),
            _buildStepIndicator(),
            const SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  Text(
                    _getStepLabel(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.cyan),
                  ),
                  const SizedBox(height: 20),
                  _buildDataVisualization(),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _currentStep == MeasurementStep.measuring ? null : _start,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: const Text('측정 시작', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReaderStatus() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.slate[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyan.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('연결된 리더기', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.slate400)),
          const SizedBox(height: 8),
          ..._readers.map((r) => Row(
            children: [
              const Icon(Icons.bluetooth_connected, size: 16, color: Colors.green),
              const SizedBox(width: 8),
              Text(r, style: const TextStyle(fontSize: 12)),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildDataVisualization() {
    if (_currentData.isEmpty) return const SizedBox(height: 150, child: Center(child: Text('데이터 대기 중...')));
    
    return Container(
      height: 150,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.slate[800]!),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _currentData.length,
        itemBuilder: (context, index) {
          return Container(
            width: 20,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            alignment: Alignment.bottomCenter,
            child: Container(
              height: _currentData[index],
              decoration: BoxDecoration(
                color: Colors.cyan.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepIndicator() {
    // 5단계 인디케이터 UI
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final isActive = index <= _currentStep.index;
        return Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isActive ? Colors.cyan : Colors.grey,
            shape: BoxShape.circle,
          ),
          child: Center(child: Text('${index + 1}')),
        );
      }),
    );
  }

  String _getStepLabel() {
    switch (_currentStep) {
      case MeasurementStep.ready: return '준비 중...';
      case MeasurementStep.cartridgeIn: return '카트리지 인식 중...';
      case MeasurementStep.measuring: return '데이터 수집 중...';
      case MeasurementStep.analyzing: return 'AI 분석 중...';
      case MeasurementStep.completed: return '측정 완료';
    }
  }
}
