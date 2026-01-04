/// 디바이스 정보 모델
class DeviceInfo {
  final String id;
  final String name;
  final String model;
  final String firmwareVersion;
  final String hardwareVersion;
  final String serialNumber;
  final int batteryLevel;
  final DateTime? lastConnected;
  final DeviceCapabilities capabilities;
  
  DeviceInfo({
    required this.id,
    required this.name,
    required this.model,
    required this.firmwareVersion,
    required this.hardwareVersion,
    required this.serialNumber,
    required this.batteryLevel,
    this.lastConnected,
    required this.capabilities,
  });
  
  /// 배터리 부족 여부
  bool get isLowBattery => batteryLevel < 20;
  
  /// 펌웨어 업데이트 필요 여부
  bool get needsFirmwareUpdate {
    // 버전 비교 로직
    return false;
  }
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'model': model,
    'firmwareVersion': firmwareVersion,
    'hardwareVersion': hardwareVersion,
    'serialNumber': serialNumber,
    'batteryLevel': batteryLevel,
    'lastConnected': lastConnected?.toIso8601String(),
    'capabilities': capabilities.toJson(),
  };
  
  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      id: json['id'],
      name: json['name'],
      model: json['model'],
      firmwareVersion: json['firmwareVersion'],
      hardwareVersion: json['hardwareVersion'],
      serialNumber: json['serialNumber'],
      batteryLevel: json['batteryLevel'],
      lastConnected: json['lastConnected'] != null 
          ? DateTime.parse(json['lastConnected']) 
          : null,
      capabilities: DeviceCapabilities.fromJson(json['capabilities']),
    );
  }
}

/// 디바이스 기능
class DeviceCapabilities {
  final bool supportsGlucose;
  final bool supportsBloodPressure;
  final bool supportsHeartRate;
  final bool supportsOxygen;
  final bool supportsTemperature;
  final bool supportsECG;
  final bool supportsWeight;
  final bool supportsNFC;
  final bool supportsBLE;
  final bool supportsOTA; // Over-the-air updates
  
  DeviceCapabilities({
    this.supportsGlucose = false,
    this.supportsBloodPressure = false,
    this.supportsHeartRate = false,
    this.supportsOxygen = false,
    this.supportsTemperature = false,
    this.supportsECG = false,
    this.supportsWeight = false,
    this.supportsNFC = false,
    this.supportsBLE = true,
    this.supportsOTA = false,
  });
  
  /// 전체 기능 목록
  List<String> get supportedMeasurements {
    final list = <String>[];
    if (supportsGlucose) list.add('glucose');
    if (supportsBloodPressure) list.add('bloodPressure');
    if (supportsHeartRate) list.add('heartRate');
    if (supportsOxygen) list.add('oxygen');
    if (supportsTemperature) list.add('temperature');
    if (supportsECG) list.add('ecg');
    if (supportsWeight) list.add('weight');
    return list;
  }
  
  Map<String, dynamic> toJson() => {
    'supportsGlucose': supportsGlucose,
    'supportsBloodPressure': supportsBloodPressure,
    'supportsHeartRate': supportsHeartRate,
    'supportsOxygen': supportsOxygen,
    'supportsTemperature': supportsTemperature,
    'supportsECG': supportsECG,
    'supportsWeight': supportsWeight,
    'supportsNFC': supportsNFC,
    'supportsBLE': supportsBLE,
    'supportsOTA': supportsOTA,
  };
  
  factory DeviceCapabilities.fromJson(Map<String, dynamic> json) {
    return DeviceCapabilities(
      supportsGlucose: json['supportsGlucose'] ?? false,
      supportsBloodPressure: json['supportsBloodPressure'] ?? false,
      supportsHeartRate: json['supportsHeartRate'] ?? false,
      supportsOxygen: json['supportsOxygen'] ?? false,
      supportsTemperature: json['supportsTemperature'] ?? false,
      supportsECG: json['supportsECG'] ?? false,
      supportsWeight: json['supportsWeight'] ?? false,
      supportsNFC: json['supportsNFC'] ?? false,
      supportsBLE: json['supportsBLE'] ?? true,
      supportsOTA: json['supportsOTA'] ?? false,
    );
  }
  
  /// 모든 기능 지원 (DiffMeas Pro)
  factory DeviceCapabilities.full() {
    return DeviceCapabilities(
      supportsGlucose: true,
      supportsBloodPressure: true,
      supportsHeartRate: true,
      supportsOxygen: true,
      supportsTemperature: true,
      supportsECG: true,
      supportsWeight: true,
      supportsNFC: true,
      supportsBLE: true,
      supportsOTA: true,
    );
  }
  
  /// 기본 기능만 (DiffMeas Mini)
  factory DeviceCapabilities.basic() {
    return DeviceCapabilities(
      supportsGlucose: true,
      supportsHeartRate: true,
      supportsOxygen: true,
      supportsBLE: true,
    );
  }
}

