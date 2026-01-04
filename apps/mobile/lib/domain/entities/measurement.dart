import 'package:equatable/equatable.dart';

class MeasurementData extends Equatable {
  final String id;
  final String deviceId;
  final String cartridgeId;
  final String measurementType;
  final double result;
  final double? uncertainty;
  final DateTime timestamp;
  final String? notes;
  final Map<String, dynamic> rawChannels;
  final String? aiInterpretation;
  final String? patientState;
  final bool synced;

  const MeasurementData({
    required this.id,
    required this.deviceId,
    required this.cartridgeId,
    required this.measurementType,
    required this.result,
    this.uncertainty,
    required this.timestamp,
    this.notes,
    required this.rawChannels,
    this.aiInterpretation,
    this.patientState,
    this.synced = false,
  });

  @override
  List<Object?> get props => [
    id,
    deviceId,
    cartridgeId,
    measurementType,
    result,
    uncertainty,
    timestamp,
    notes,
    rawChannels,
    aiInterpretation,
    patientState,
    synced,
  ];
}

class CartridgeInfo extends Equatable {
  final String id;
  final String type;
  final String lotNumber;
  final DateTime manufactureDate;
  final DateTime expiryDate;
  final Map<String, double> calibrationData;
  final int maxUses;
  final int currentUses;
  final bool isExpired;

  const CartridgeInfo({
    required this.id,
    required this.type,
    required this.lotNumber,
    required this.manufactureDate,
    required this.expiryDate,
    required this.calibrationData,
    required this.maxUses,
    required this.currentUses,
    this.isExpired = false,
  });

  bool get canUse => !isExpired && currentUses < maxUses;

  @override
  List<Object> get props => [
    id,
    type,
    lotNumber,
    manufactureDate,
    expiryDate,
    calibrationData,
    maxUses,
    currentUses,
    isExpired,
  ];
}

class ReaderDevice extends Equatable {
  final String id;
  final String name;
  final String deviceType;
  final int? rssi;
  final bool isConnected;
  final String? firmwareVersion;
  final DateTime? lastConnectedAt;
  final Map<String, dynamic>? metadata;

  const ReaderDevice({
    required this.id,
    required this.name,
    required this.deviceType,
    this.rssi,
    this.isConnected = false,
    this.firmwareVersion,
    this.lastConnectedAt,
    this.metadata,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    deviceType,
    rssi,
    isConnected,
    firmwareVersion,
    lastConnectedAt,
    metadata,
  ];
}
