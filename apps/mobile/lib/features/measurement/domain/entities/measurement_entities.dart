import 'package:equatable/equatable.dart';

class MeasurementSession extends Equatable {
  final String sessionId;
  final String cartridgeType;
  final ReaderDevice device;
  final CartridgeInfo cartridge;
  final DateTime startTime;
  final DateTime? endTime;
  final String currentStep;
  final double progressPercentage;
  final List<WaveformPoint> waveformData;
  final MeasurementPhase? currentPhase;

  const MeasurementSession({
    required this.sessionId,
    required this.cartridgeType,
    required this.device,
    required this.cartridge,
    required this.startTime,
    this.endTime,
    required this.currentStep,
    required this.progressPercentage,
    required this.waveformData,
    this.currentPhase,
  });

  factory MeasurementSession.fromJson(Map<String, dynamic> json) {
    return MeasurementSession(
      sessionId: json['sessionId'] ?? '',
      cartridgeType: json['cartridgeType'] ?? '',
      device: ReaderDevice.fromJson(json['device'] ?? {}),
      cartridge: CartridgeInfo.fromJson(json['cartridge'] ?? {}),
      startTime: DateTime.parse(json['startTime'] ?? DateTime.now().toIso8601String()),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      currentStep: json['currentStep'] ?? '',
      progressPercentage: (json['progressPercentage'] ?? 0).toDouble(),
      waveformData: (json['waveformData'] as List<dynamic>?)
              ?.map((e) => WaveformPoint.fromJson(e))
              .toList() ??
          [],
      currentPhase: json['currentPhase'] != null
          ? MeasurementPhase.fromJson(json['currentPhase'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'sessionId': sessionId,
        'cartridgeType': cartridgeType,
        'device': device.toJson(),
        'cartridge': cartridge.toJson(),
        'startTime': startTime.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
        'currentStep': currentStep,
        'progressPercentage': progressPercentage,
        'waveformData': waveformData.map((e) => e.toJson()).toList(),
        'currentPhase': currentPhase?.toJson(),
      };

  @override
  List<Object?> get props => [
        sessionId,
        cartridgeType,
        device,
        cartridge,
        startTime,
        endTime,
        currentStep,
        progressPercentage,
        waveformData,
        currentPhase,
      ];
}

class ReaderDevice extends Equatable {
  final String deviceId;
  final String deviceName;
  final String model;
  final String firmwareVersion;
  final String macAddress;
  final bool isConnected;
  final int batteryLevel;
  final String status;
  final DateTime lastConnectedTime;

  const ReaderDevice({
    required this.deviceId,
    required this.deviceName,
    required this.model,
    required this.firmwareVersion,
    required this.macAddress,
    required this.isConnected,
    required this.batteryLevel,
    required this.status,
    required this.lastConnectedTime,
  });

  factory ReaderDevice.fromJson(Map<String, dynamic> json) {
    return ReaderDevice(
      deviceId: json['deviceId'] ?? '',
      deviceName: json['deviceName'] ?? '',
      model: json['model'] ?? '',
      firmwareVersion: json['firmwareVersion'] ?? '',
      macAddress: json['macAddress'] ?? '',
      isConnected: json['isConnected'] ?? false,
      batteryLevel: json['batteryLevel'] ?? 0,
      status: json['status'] ?? '',
      lastConnectedTime: DateTime.parse(json['lastConnectedTime'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
        'deviceId': deviceId,
        'deviceName': deviceName,
        'model': model,
        'firmwareVersion': firmwareVersion,
        'macAddress': macAddress,
        'isConnected': isConnected,
        'batteryLevel': batteryLevel,
        'status': status,
        'lastConnectedTime': lastConnectedTime.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        deviceId,
        deviceName,
        model,
        firmwareVersion,
        macAddress,
        isConnected,
        batteryLevel,
        status,
        lastConnectedTime,
      ];
}

class CartridgeInfo extends Equatable {
  final String id;
  final String type;
  final String lotNumber;
  final DateTime expiryDate;
  final int remainingUses;
  final Map<String, double> calibrationData;

  const CartridgeInfo({
    required this.id,
    required this.type,
    required this.lotNumber,
    required this.expiryDate,
    required this.remainingUses,
    required this.calibrationData,
  });

  factory CartridgeInfo.fromJson(Map<String, dynamic> json) {
    return CartridgeInfo(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      lotNumber: json['lotNumber'] ?? '',
      expiryDate: DateTime.parse(json['expiryDate'] ?? DateTime.now().toIso8601String()),
      remainingUses: json['remainingUses'] ?? 0,
      calibrationData: (json['calibrationData'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, (value as num).toDouble()),
          ) ??
          {},
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'lotNumber': lotNumber,
        'expiryDate': expiryDate.toIso8601String(),
        'remainingUses': remainingUses,
        'calibrationData': calibrationData,
      };

  @override
  List<Object?> get props => [
        id,
        type,
        lotNumber,
        expiryDate,
        remainingUses,
        calibrationData,
      ];
}

class WaveformPoint extends Equatable {
  final int timestamp;
  final double value;

  const WaveformPoint({
    required this.timestamp,
    required this.value,
  });

  factory WaveformPoint.fromJson(Map<String, dynamic> json) {
    return WaveformPoint(
      timestamp: json['timestamp'] ?? 0,
      value: (json['value'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp,
        'value': value,
      };

  @override
  List<Object?> get props => [timestamp, value];
}

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

  factory MeasurementPhase.fromJson(Map<String, dynamic> json) {
    return MeasurementPhase(
      stepNumber: json['stepNumber'] ?? 0,
      phaseName: json['phaseName'] ?? '',
      description: json['description'] ?? '',
      progress: (json['progress'] ?? 0).toDouble(),
      startTime: DateTime.parse(json['startTime'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
        'stepNumber': stepNumber,
        'phaseName': phaseName,
        'description': description,
        'progress': progress,
        'startTime': startTime.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        stepNumber,
        phaseName,
        description,
        progress,
        startTime,
      ];
}
