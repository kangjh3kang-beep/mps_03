/// DiffMeas Flutter SDK
/// 만파식적 측정 장비와의 BLE/NFC 연동을 위한 SDK
library diffmeas_sdk;

import 'dart:async';
import 'dart:typed_data';

// Re-export all public APIs
export 'src/device_manager.dart';
export 'src/measurement_handler.dart';
export 'src/models/measurement_data.dart';
export 'src/models/device_info.dart';
export 'src/connection_state.dart';

/// SDK 버전
const String sdkVersion = '1.0.0';

/// DiffMeas SDK 메인 클래스
class DiffMeasSDK {
  static DiffMeasSDK? _instance;
  
  /// 싱글톤 인스턴스
  static DiffMeasSDK get instance {
    _instance ??= DiffMeasSDK._();
    return _instance!;
  }
  
  DiffMeasSDK._();
  
  bool _initialized = false;
  
  /// SDK 초기화
  Future<bool> initialize({
    required String apiKey,
    String? userId,
    bool debugMode = false,
  }) async {
    if (_initialized) return true;
    
    // API Key 검증
    if (apiKey.isEmpty) {
      throw DiffMeasException('API Key is required');
    }
    
    _initialized = true;
    print('[DiffMeas SDK] Initialized with version $sdkVersion');
    return true;
  }
  
  /// SDK 종료
  Future<void> dispose() async {
    _initialized = false;
    print('[DiffMeas SDK] Disposed');
  }
  
  /// 초기화 상태 확인
  bool get isInitialized => _initialized;
}

/// SDK 예외 클래스
class DiffMeasException implements Exception {
  final String message;
  final String? code;
  
  DiffMeasException(this.message, {this.code});
  
  @override
  String toString() => 'DiffMeasException: $message (code: $code)';
}

