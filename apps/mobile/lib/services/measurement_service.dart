import 'package:injectable/injectable.dart';
import 'hardware_manager.dart';
import 'hardware_simulator.dart';

enum MeasurementStep {
  ready,        // 준비
  cartridgeIn,  // 카트리지 삽입
  measuring,    // 측정 중
  analyzing,    // 분석 중
  completed     // 완료
}

@singleton
class MeasurementService {
  final HardwareManager _hardwareManager;
  final HardwareSimulator _simulator;
  
  MeasurementService(this._hardwareManager, this._simulator);
  
  // 5단계 측정 프로세스 관리
  Stream<MeasurementStep> startMeasurement(String cartridgeId) async* {
    yield MeasurementStep.ready;
    await Future.delayed(const Duration(seconds: 1));
    
    yield MeasurementStep.cartridgeIn;
    final mode = _hardwareManager.selectModeByCartridge(cartridgeId);
    await Future.delayed(const Duration(seconds: 2));
    
    yield MeasurementStep.measuring;
    // 시뮬레이터로부터 데이터 수집
    await for (final data in _simulator.generateData(mode)) {
      // 데이터 수집 중임을 알림 (실제로는 데이터를 스트림으로 보낼 수 있음)
      print('Collecting data: ${data.values}');
    }
    
    yield MeasurementStep.analyzing;
    await Future.delayed(const Duration(seconds: 3));
    
    yield MeasurementStep.completed;
  }
}
