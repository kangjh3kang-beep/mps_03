import 'dart:async';
import 'models/device_info.dart';
import 'connection_state.dart';

/// BLE/NFC 디바이스 관리자
class DeviceManager {
  static DeviceManager? _instance;
  
  static DeviceManager get instance {
    _instance ??= DeviceManager._();
    return _instance!;
  }
  
  DeviceManager._();
  
  final _connectionStateController = StreamController<DeviceConnectionState>.broadcast();
  final _discoveredDevicesController = StreamController<List<DiffMeasDevice>>.broadcast();
  
  DiffMeasDevice? _connectedDevice;
  DeviceConnectionState _connectionState = DeviceConnectionState.disconnected;
  
  /// 연결 상태 스트림
  Stream<DeviceConnectionState> get connectionStateStream => _connectionStateController.stream;
  
  /// 발견된 디바이스 스트림
  Stream<List<DiffMeasDevice>> get discoveredDevicesStream => _discoveredDevicesController.stream;
  
  /// 현재 연결된 디바이스
  DiffMeasDevice? get connectedDevice => _connectedDevice;
  
  /// 현재 연결 상태
  DeviceConnectionState get connectionState => _connectionState;
  
  /// BLE 스캔 시작
  Future<void> startScan({
    Duration timeout = const Duration(seconds: 10),
    List<String>? serviceUuids,
  }) async {
    print('[DeviceManager] Starting BLE scan...');
    _updateConnectionState(DeviceConnectionState.scanning);
    
    // 시뮬레이션: 실제로는 flutter_blue_plus 또는 flutter_reactive_ble 사용
    await Future.delayed(const Duration(seconds: 2));
    
    // Mock 디바이스 발견
    final mockDevices = [
      DiffMeasDevice(
        id: 'DIFFMEAS-001',
        name: 'DiffMeas Pro',
        rssi: -45,
        type: DeviceType.ble,
        firmwareVersion: '2.1.0',
      ),
      DiffMeasDevice(
        id: 'DIFFMEAS-002',
        name: 'DiffMeas Mini',
        rssi: -62,
        type: DeviceType.ble,
        firmwareVersion: '2.0.5',
      ),
    ];
    
    _discoveredDevicesController.add(mockDevices);
    _updateConnectionState(DeviceConnectionState.disconnected);
    print('[DeviceManager] Found ${mockDevices.length} devices');
  }
  
  /// 스캔 중지
  Future<void> stopScan() async {
    print('[DeviceManager] Stopping scan');
    _updateConnectionState(DeviceConnectionState.disconnected);
  }
  
  /// 디바이스 연결
  Future<bool> connect(DiffMeasDevice device) async {
    print('[DeviceManager] Connecting to ${device.name}...');
    _updateConnectionState(DeviceConnectionState.connecting);
    
    // 연결 시뮬레이션
    await Future.delayed(const Duration(seconds: 2));
    
    _connectedDevice = device;
    _updateConnectionState(DeviceConnectionState.connected);
    print('[DeviceManager] Connected to ${device.name}');
    
    return true;
  }
  
  /// 디바이스 연결 해제
  Future<void> disconnect() async {
    if (_connectedDevice == null) return;
    
    print('[DeviceManager] Disconnecting from ${_connectedDevice!.name}...');
    _updateConnectionState(DeviceConnectionState.disconnecting);
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    _connectedDevice = null;
    _updateConnectionState(DeviceConnectionState.disconnected);
    print('[DeviceManager] Disconnected');
  }
  
  /// NFC 태그 스캔
  Future<DiffMeasDevice?> scanNfc() async {
    print('[DeviceManager] Scanning NFC...');
    
    // NFC 시뮬레이션
    await Future.delayed(const Duration(seconds: 3));
    
    return DiffMeasDevice(
      id: 'NFC-001',
      name: 'DiffMeas NFC Tag',
      rssi: 0,
      type: DeviceType.nfc,
      firmwareVersion: '1.0.0',
    );
  }
  
  /// 데이터 전송
  Future<void> sendData(List<int> data) async {
    if (_connectedDevice == null) {
      throw Exception('No device connected');
    }
    
    print('[DeviceManager] Sending ${data.length} bytes');
    await Future.delayed(const Duration(milliseconds: 100));
  }
  
  /// 데이터 수신
  Stream<List<int>> get dataStream {
    // 시뮬레이션된 데이터 스트림
    return Stream.periodic(const Duration(seconds: 1), (i) {
      return [0x01, 0x02, i & 0xFF];
    });
  }
  
  void _updateConnectionState(DeviceConnectionState state) {
    _connectionState = state;
    _connectionStateController.add(state);
  }
  
  /// 리소스 해제
  void dispose() {
    _connectionStateController.close();
    _discoveredDevicesController.close();
  }
}

/// 디바이스 정보
class DiffMeasDevice {
  final String id;
  final String name;
  final int rssi;
  final DeviceType type;
  final String? firmwareVersion;
  final String? serialNumber;
  final int? batteryLevel;
  
  DiffMeasDevice({
    required this.id,
    required this.name,
    required this.rssi,
    required this.type,
    this.firmwareVersion,
    this.serialNumber,
    this.batteryLevel,
  });
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'rssi': rssi,
    'type': type.name,
    'firmwareVersion': firmwareVersion,
    'serialNumber': serialNumber,
    'batteryLevel': batteryLevel,
  };
}

/// 디바이스 타입
enum DeviceType {
  ble,
  nfc,
  usb,
}

