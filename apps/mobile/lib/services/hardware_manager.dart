import 'dart:async';
import 'package:injectable/injectable.dart';

enum MeasurementMode {
  targeted,    // 표적 측정
  nonTargeted, // 비표적 측정 (전자코, 전자혀)
  ehdGas,      // EHD 기체 측정
  nonInvasive  // 비침습 측정
}

@singleton
class HardwareManager {
  final List<String> _connectedReaders = [];
  
  // 다중 리더기 연결 관리
  Future<void> connectReader(String readerId) async {
    if (!_connectedReaders.contains(readerId)) {
      _connectedReaders.add(readerId);
      // TODO: BLE 연결 로직
    }
  }
  
  // 카트리지 기반 자동 측정 방식 선택
  MeasurementMode selectModeByCartridge(String cartridgeId) {
    // 카트리지 ID 패턴에 따른 자동 선택 로직
    if (cartridgeId.startsWith('TGT-')) return MeasurementMode.targeted;
    if (cartridgeId.startsWith('NTG-')) return MeasurementMode.nonTargeted;
    if (cartridgeId.startsWith('EHD-')) return MeasurementMode.ehdGas;
    if (cartridgeId.startsWith('NIV-')) return MeasurementMode.nonInvasive;
    
    return MeasurementMode.targeted; // 기본값
  }
  
  List<String> get connectedReaders => List.unmodifiable(_connectedReaders);
}
