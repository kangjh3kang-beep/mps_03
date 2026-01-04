/// 디바이스 연결 상태
enum DeviceConnectionState {
  /// 연결 해제됨
  disconnected,
  
  /// 스캔 중
  scanning,
  
  /// 연결 중
  connecting,
  
  /// 연결됨
  connected,
  
  /// 연결 해제 중
  disconnecting,
  
  /// 오류
  error,
}

/// 연결 상태 확장
extension DeviceConnectionStateExtension on DeviceConnectionState {
  /// 연결 가능 여부
  bool get canConnect => this == DeviceConnectionState.disconnected;
  
  /// 연결됨 여부
  bool get isConnected => this == DeviceConnectionState.connected;
  
  /// 진행 중 여부
  bool get isInProgress => 
      this == DeviceConnectionState.scanning ||
      this == DeviceConnectionState.connecting ||
      this == DeviceConnectionState.disconnecting;
  
  /// 상태 이름 (한국어)
  String get displayName {
    switch (this) {
      case DeviceConnectionState.disconnected:
        return '연결 해제됨';
      case DeviceConnectionState.scanning:
        return '검색 중';
      case DeviceConnectionState.connecting:
        return '연결 중';
      case DeviceConnectionState.connected:
        return '연결됨';
      case DeviceConnectionState.disconnecting:
        return '연결 해제 중';
      case DeviceConnectionState.error:
        return '오류';
    }
  }
}

