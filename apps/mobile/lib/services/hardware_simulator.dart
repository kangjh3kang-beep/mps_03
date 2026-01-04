import 'dart:async';
import 'dart:math';
import 'package:injectable/injectable.dart';
import '../config/mvp_config.dart';
import 'hardware_manager.dart';

class SimulatedData {
  final MeasurementMode mode;
  final List<double> values;
  final Map<String, dynamic> metadata;

  SimulatedData({required this.mode, required this.values, required this.metadata});
}

@singleton
class HardwareSimulator {
  final Random _random = Random();

  // 카트리지 유형별 정밀 데이터 생성
  Stream<SimulatedData> generateData(MeasurementMode mode) async* {
    switch (mode) {
      case MeasurementMode.targeted:
        yield* _generateTargetedData();
        break;
      case MeasurementMode.nonTargeted:
        yield* _generateNonTargetedData();
        break;
      case MeasurementMode.ehdGas:
        yield* _generateEhdGasData();
        break;
      case MeasurementMode.nonInvasive:
        yield* _generateNonInvasiveData();
        break;
    }
  }

  // 1. 표적 측정 (Targeted): 특정 바이오마커 농도 시뮬레이션
  Stream<SimulatedData> _generateTargetedData() async* {
    double baseValue = 90.0 + _random.nextDouble() * 20.0;
    for (int i = 0; i < 10; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      double noise = (_random.nextDouble() - 0.5) * 2.0;
      yield SimulatedData(
        mode: MeasurementMode.targeted,
        values: [baseValue + noise],
        metadata: {'unit': 'mg/dL', 'biomarker': 'Glucose'},
      );
    }
  }

  // 2. 비표적 측정 (Non-Targeted): 전자코/전자혀 다채널 센서 패턴
  Stream<SimulatedData> _generateNonTargetedData() async* {
    for (int i = 0; i < 10; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      // 8채널 센서 어레이 패턴 생성
      List<double> channels = List.generate(8, (_) => _random.nextDouble() * 100.0);
      yield SimulatedData(
        mode: MeasurementMode.nonTargeted,
        values: channels,
        metadata: {'channels': 8, 'type': 'Electronic Nose'},
      );
    }
  }

  // 3. EHD 기체 측정: 기체 흐름 및 농도 변화
  Stream<SimulatedData> _generateEhdGasData() async* {
    for (int i = 0; i < 10; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      double flowRate = 0.5 + _random.nextDouble() * 0.5;
      double concentration = 10.0 + _random.nextDouble() * 50.0;
      yield SimulatedData(
        mode: MeasurementMode.ehdGas,
        values: [flowRate, concentration],
        metadata: {'flow_unit': 'L/min', 'conc_unit': 'ppm'},
      );
    }
  }

  // 4. 비침습 측정: 광학/임피던스 생체 신호
  Stream<SimulatedData> _generateNonInvasiveData() async* {
    for (int i = 0; i < 20; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      // 심박수/산소포화도 유사 파형 생성
      double signal = sin(i * 0.5) * 10.0 + 95.0;
      yield SimulatedData(
        mode: MeasurementMode.nonInvasive,
        values: [signal],
        metadata: {'type': 'PPG', 'frequency': '50Hz'},
      );
    }
  }
}
