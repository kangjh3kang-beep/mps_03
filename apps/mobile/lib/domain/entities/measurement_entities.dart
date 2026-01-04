import 'package:equatable/equatable.dart';

/// 측정 데이터 엔티티
class MeasurementData extends Equatable {
  final String id;
  final String userId;
  final MeasurementType type;
  final double value;
  final String unit;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;
  final String? deviceId;
  final String? cartridgeId;
  final bool isSynced;
  final String? notes;

  const MeasurementData({
    required this.id,
    required this.userId,
    required this.type,
    required this.value,
    required this.unit,
    required this.timestamp,
    this.metadata,
    this.deviceId,
    this.cartridgeId,
    this.isSynced = false,
    this.notes,
  });

  @override
  List<Object?> get props => [id, userId, type, value, unit, timestamp, metadata, deviceId, cartridgeId, isSynced, notes];

  factory MeasurementData.fromJson(Map<String, dynamic> json) {
    return MeasurementData(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      type: MeasurementType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => MeasurementType.glucose,
      ),
      value: (json['value'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      metadata: json['metadata'],
      deviceId: json['device_id'],
      cartridgeId: json['cartridge_id'],
      isSynced: json['is_synced'] ?? false,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'type': type.name,
    'value': value,
    'unit': unit,
    'timestamp': timestamp.toIso8601String(),
    'metadata': metadata,
    'device_id': deviceId,
    'cartridge_id': cartridgeId,
    'is_synced': isSynced,
    'notes': notes,
  };
}

/// 측정 타입
enum MeasurementType {
  glucose,      // 혈당
  bloodPressure, // 혈압
  cholesterol,  // 콜레스테롤
  hba1c,        // 당화혈색소
  creatinine,   // 크레아티닌
  radon,        // 라돈
  waterQuality, // 수질
  soilAnalysis, // 토양분석
  foodSafety,   // 식품안전
  dna,          // DNA
  hormone,      // 호르몬
  vitamin,      // 비타민
  mineral,      // 미네랄
  custom,       // 커스텀
}

/// 측정 세션
class MeasurementSession extends Equatable {
  final String sessionId;
  final String cartridgeType;
  final ReaderDevice? device;
  final CartridgeInfo? cartridge;
  final DateTime startTime;
  final DateTime? endTime;
  final String currentStep;
  final double progressPercentage;
  final List<WaveformPoint> waveformData;
  final MeasurementPhase? currentPhase;

  const MeasurementSession({
    required this.sessionId,
    required this.cartridgeType,
    this.device,
    this.cartridge,
    required this.startTime,
    this.endTime,
    required this.currentStep,
    required this.progressPercentage,
    this.waveformData = const [],
    this.currentPhase,
  });

  @override
  List<Object?> get props => [sessionId, cartridgeType, device, cartridge, startTime, endTime, currentStep, progressPercentage, waveformData, currentPhase];

  MeasurementSession copyWith({
    String? sessionId,
    String? cartridgeType,
    ReaderDevice? device,
    CartridgeInfo? cartridge,
    DateTime? startTime,
    DateTime? endTime,
    String? currentStep,
    double? progressPercentage,
    List<WaveformPoint>? waveformData,
    MeasurementPhase? currentPhase,
  }) {
    return MeasurementSession(
      sessionId: sessionId ?? this.sessionId,
      cartridgeType: cartridgeType ?? this.cartridgeType,
      device: device ?? this.device,
      cartridge: cartridge ?? this.cartridge,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      currentStep: currentStep ?? this.currentStep,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      waveformData: waveformData ?? this.waveformData,
      currentPhase: currentPhase ?? this.currentPhase,
    );
  }
}

/// 측정 상태
enum MeasurementStatus {
  initializing,
  cartridgeInsertion,
  samplePreparation,
  measuring,
  analyzing,
  completed,
  failed,
  cancelled,
}

/// 리더기 장치
class ReaderDevice extends Equatable {
  final String deviceId;
  final String deviceName;
  final String model;
  final String firmwareVersion;
  final String macAddress;
  final bool isConnected;
  final int batteryLevel;
  final String status;
  final DateTime? lastConnectedTime;

  const ReaderDevice({
    required this.deviceId,
    required this.deviceName,
    required this.model,
    this.firmwareVersion = '1.0.0',
    this.macAddress = '',
    this.isConnected = false,
    this.batteryLevel = 100,
    this.status = 'disconnected',
    this.lastConnectedTime,
  });

  @override
  List<Object?> get props => [deviceId, deviceName, model, firmwareVersion, macAddress, isConnected, batteryLevel, status, lastConnectedTime];
}

/// 장치 타입
enum DeviceType {
  mpsReader,
  mpsReaderPro,
  mpsResearch,
}

/// 카트리지 정보
class CartridgeInfo extends Equatable {
  final String id;
  final String type;
  final String lotNumber;
  final DateTime expiryDate;
  final int remainingUses;
  final Map<String, dynamic>? calibrationData;

  const CartridgeInfo({
    required this.id,
    required this.type,
    required this.lotNumber,
    required this.expiryDate,
    this.remainingUses = 100,
    this.calibrationData,
  });

  @override
  List<Object?> get props => [id, type, lotNumber, expiryDate, remainingUses, calibrationData];

  bool get isExpired => DateTime.now().isAfter(expiryDate);
}

/// 파형 포인트
class WaveformPoint extends Equatable {
  final int timestamp;
  final double value;

  const WaveformPoint({
    required this.timestamp,
    required this.value,
  });

  @override
  List<Object?> get props => [timestamp, value];
}

/// 측정 단계
class MeasurementPhase extends Equatable {
  final int stepNumber;
  final String phaseName;
  final String description;
  final double progress;
  final DateTime startTime;

  const MeasurementPhase({
    required this.stepNumber,
    required this.phaseName,
    required this.description,
    required this.progress,
    required this.startTime,
  });

  @override
  List<Object?> get props => [stepNumber, phaseName, description, progress, startTime];
}
