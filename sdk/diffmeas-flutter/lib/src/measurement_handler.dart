import 'dart:async';
import 'dart:math';
import 'models/measurement_data.dart';
import 'device_manager.dart';

/// 측정 핸들러 - 측정 프로세스 관리
class MeasurementHandler {
  static MeasurementHandler? _instance;
  
  static MeasurementHandler get instance {
    _instance ??= MeasurementHandler._();
    return _instance!;
  }
  
  MeasurementHandler._();
  
  final _measurementController = StreamController<MeasurementData>.broadcast();
  final _progressController = StreamController<MeasurementProgress>.broadcast();
  
  bool _isMeasuring = false;
  
  /// 측정 데이터 스트림
  Stream<MeasurementData> get measurementStream => _measurementController.stream;
  
  /// 측정 진행 상태 스트림
  Stream<MeasurementProgress> get progressStream => _progressController.stream;
  
  /// 측정 중 여부
  bool get isMeasuring => _isMeasuring;
  
  /// 측정 시작
  Future<MeasurementData> startMeasurement({
    required MeasurementType type,
    Duration timeout = const Duration(seconds: 30),
    MeasurementConfig? config,
  }) async {
    if (_isMeasuring) {
      throw MeasurementException('Measurement already in progress');
    }
    
    if (DeviceManager.instance.connectedDevice == null) {
      throw MeasurementException('No device connected');
    }
    
    _isMeasuring = true;
    print('[MeasurementHandler] Starting ${type.name} measurement...');
    
    try {
      // 측정 프로세스 시뮬레이션
      for (int progress = 0; progress <= 100; progress += 10) {
        await Future.delayed(const Duration(milliseconds: 300));
        _progressController.add(MeasurementProgress(
          type: type,
          progress: progress,
          status: _getStatusForProgress(progress),
        ));
      }
      
      // 측정 결과 생성
      final result = _generateMeasurementResult(type);
      _measurementController.add(result);
      
      print('[MeasurementHandler] Measurement complete');
      return result;
      
    } finally {
      _isMeasuring = false;
    }
  }
  
  /// 측정 취소
  void cancelMeasurement() {
    if (!_isMeasuring) return;
    
    _isMeasuring = false;
    print('[MeasurementHandler] Measurement cancelled');
  }
  
  /// 연속 측정 모드
  Stream<MeasurementData> startContinuousMeasurement({
    required MeasurementType type,
    Duration interval = const Duration(seconds: 5),
  }) {
    return Stream.periodic(interval, (i) {
      return _generateMeasurementResult(type);
    });
  }
  
  /// 캘리브레이션
  Future<bool> calibrate() async {
    print('[MeasurementHandler] Starting calibration...');
    
    for (int i = 1; i <= 3; i++) {
      _progressController.add(MeasurementProgress(
        type: MeasurementType.calibration,
        progress: (i * 33).clamp(0, 100),
        status: 'Calibration step $i/3',
      ));
      await Future.delayed(const Duration(seconds: 2));
    }
    
    print('[MeasurementHandler] Calibration complete');
    return true;
  }
  
  String _getStatusForProgress(int progress) {
    if (progress < 20) return '준비 중...';
    if (progress < 40) return '센서 안정화...';
    if (progress < 60) return '데이터 수집 중...';
    if (progress < 80) return '분석 중...';
    if (progress < 100) return '결과 처리 중...';
    return '완료';
  }
  
  MeasurementData _generateMeasurementResult(MeasurementType type) {
    final random = Random();
    
    switch (type) {
      case MeasurementType.glucose:
        return GlucoseMeasurement(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          timestamp: DateTime.now(),
          value: 85 + random.nextDouble() * 40, // 85-125 mg/dL
          unit: 'mg/dL',
          mealStatus: MealStatus.fasting,
          isValid: true,
        );
        
      case MeasurementType.bloodPressure:
        return BloodPressureMeasurement(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          timestamp: DateTime.now(),
          systolic: 110 + random.nextInt(30),
          diastolic: 70 + random.nextInt(20),
          pulse: 60 + random.nextInt(40),
          unit: 'mmHg',
          isValid: true,
        );
        
      case MeasurementType.heartRate:
        return HeartRateMeasurement(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          timestamp: DateTime.now(),
          value: 60 + random.nextInt(40),
          unit: 'bpm',
          rhythm: HeartRhythm.normal,
          isValid: true,
        );
        
      case MeasurementType.oxygenSaturation:
        return OxygenMeasurement(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          timestamp: DateTime.now(),
          value: 95 + random.nextDouble() * 4, // 95-99%
          unit: '%',
          perfusionIndex: 2 + random.nextDouble() * 8,
          isValid: true,
        );
        
      case MeasurementType.temperature:
        return TemperatureMeasurement(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          timestamp: DateTime.now(),
          value: 36.0 + random.nextDouble() * 1.5,
          unit: '°C',
          site: TemperatureSite.forehead,
          isValid: true,
        );
        
      default:
        throw MeasurementException('Unknown measurement type');
    }
  }
  
  /// 리소스 해제
  void dispose() {
    _measurementController.close();
    _progressController.close();
  }
}

/// 측정 진행 상태
class MeasurementProgress {
  final MeasurementType type;
  final int progress;
  final String status;
  final String? message;
  
  MeasurementProgress({
    required this.type,
    required this.progress,
    required this.status,
    this.message,
  });
}

/// 측정 타입
enum MeasurementType {
  glucose,
  bloodPressure,
  heartRate,
  oxygenSaturation,
  temperature,
  ecg,
  weight,
  bodyFat,
  calibration,
}

/// 측정 설정
class MeasurementConfig {
  final int sampleCount;
  final Duration stabilizationTime;
  final bool autoCalibrate;
  
  MeasurementConfig({
    this.sampleCount = 3,
    this.stabilizationTime = const Duration(seconds: 5),
    this.autoCalibrate = true,
  });
}

/// 측정 예외
class MeasurementException implements Exception {
  final String message;
  final String? code;
  
  MeasurementException(this.message, {this.code});
  
  @override
  String toString() => 'MeasurementException: $message';
}

