import 'dart:async';

/// 오프라인 데이터 동기화 관리자
/// 네트워크 없을 때 로컬 저장 후 온라인 복귀 시 동기화
class OfflineSyncManager {
  static final OfflineSyncManager _instance = OfflineSyncManager._internal();
  factory OfflineSyncManager() => _instance;
  OfflineSyncManager._internal();

  // 동기화 대기 큐
  final List<SyncOperation> _pendingOperations = [];

  // 네트워크 상태
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  // 이벤트 스트림
  final StreamController<SyncEvent> _eventController = StreamController.broadcast();
  Stream<SyncEvent> get events => _eventController.stream;

  /// 네트워크 상태 업데이트
  void updateNetworkStatus(bool isOnline) {
    final wasOffline = !_isOnline;
    _isOnline = isOnline;

    if (isOnline && wasOffline) {
      // 오프라인 -> 온라인: 동기화 시작
      _syncPendingOperations();
    }

    _emitEvent(SyncEventType.networkStatusChanged, {
      'isOnline': isOnline,
    });
  }

  /// 동기화 작업 추가
  Future<void> addOperation(SyncOperation operation) async {
    if (_isOnline) {
      // 온라인: 즉시 실행
      await _executeOperation(operation);
    } else {
      // 오프라인: 큐에 추가
      _pendingOperations.add(operation);
      await _saveToLocalStorage(operation);
      
      _emitEvent(SyncEventType.operationQueued, {
        'operationId': operation.id,
        'type': operation.type.name,
      });
    }
  }

  /// 대기 중인 작업 동기화
  Future<void> _syncPendingOperations() async {
    if (_pendingOperations.isEmpty) return;

    _emitEvent(SyncEventType.syncStarted, {
      'count': _pendingOperations.length,
    });

    final operations = List<SyncOperation>.from(_pendingOperations);
    int successCount = 0;
    int failCount = 0;

    for (final operation in operations) {
      try {
        await _executeOperation(operation);
        _pendingOperations.remove(operation);
        await _removeFromLocalStorage(operation.id);
        successCount++;
      } catch (e) {
        operation.retryCount++;
        if (operation.retryCount >= operation.maxRetries) {
          _pendingOperations.remove(operation);
          await _removeFromLocalStorage(operation.id);
          
          _emitEvent(SyncEventType.operationFailed, {
            'operationId': operation.id,
            'error': e.toString(),
          });
          failCount++;
        }
      }
    }

    _emitEvent(SyncEventType.syncCompleted, {
      'success': successCount,
      'failed': failCount,
    });
  }

  /// 작업 실행
  Future<void> _executeOperation(SyncOperation operation) async {
    switch (operation.type) {
      case SyncOperationType.createMeasurement:
        await _syncMeasurement(operation);
        break;
      case SyncOperationType.updateProfile:
        await _syncProfile(operation);
        break;
      case SyncOperationType.createAppointment:
        await _syncAppointment(operation);
        break;
      case SyncOperationType.saveCoachingSession:
        await _syncCoachingSession(operation);
        break;
    }

    _emitEvent(SyncEventType.operationCompleted, {
      'operationId': operation.id,
      'type': operation.type.name,
    });
  }

  Future<void> _syncMeasurement(SyncOperation operation) async {
    // 실제 구현: SupabaseService().saveMeasurement(...)
    await Future.delayed(const Duration(milliseconds: 200));
    print('[OfflineSync] 측정 데이터 동기화: ${operation.id}');
  }

  Future<void> _syncProfile(SyncOperation operation) async {
    await Future.delayed(const Duration(milliseconds: 200));
    print('[OfflineSync] 프로필 동기화: ${operation.id}');
  }

  Future<void> _syncAppointment(SyncOperation operation) async {
    await Future.delayed(const Duration(milliseconds: 200));
    print('[OfflineSync] 예약 동기화: ${operation.id}');
  }

  Future<void> _syncCoachingSession(SyncOperation operation) async {
    await Future.delayed(const Duration(milliseconds: 200));
    print('[OfflineSync] 코칭 세션 동기화: ${operation.id}');
  }

  Future<void> _saveToLocalStorage(SyncOperation operation) async {
    // 실제 구현: SharedPreferences 또는 Hive 사용
    print('[OfflineSync] 로컬 저장: ${operation.id}');
  }

  Future<void> _removeFromLocalStorage(String operationId) async {
    // 실제 구현: 로컬 스토리지에서 삭제
    print('[OfflineSync] 로컬 삭제: $operationId');
  }

  void _emitEvent(SyncEventType type, Map<String, dynamic> data) {
    _eventController.add(SyncEvent(type: type, data: data));
  }

  /// 대기 중인 작업 수
  int get pendingCount => _pendingOperations.length;

  /// 리소스 정리
  Future<void> dispose() async {
    await _eventController.close();
  }
}

enum SyncOperationType {
  createMeasurement,
  updateProfile,
  createAppointment,
  saveCoachingSession,
}

class SyncOperation {
  final String id;
  final SyncOperationType type;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  int retryCount;
  final int maxRetries;

  SyncOperation({
    required this.id,
    required this.type,
    required this.data,
    DateTime? createdAt,
    this.retryCount = 0,
    this.maxRetries = 3,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'data': data,
    'createdAt': createdAt.toIso8601String(),
    'retryCount': retryCount,
    'maxRetries': maxRetries,
  };

  factory SyncOperation.fromJson(Map<String, dynamic> json) {
    return SyncOperation(
      id: json['id'],
      type: SyncOperationType.values.firstWhere((t) => t.name == json['type']),
      data: json['data'],
      createdAt: DateTime.parse(json['createdAt']),
      retryCount: json['retryCount'] ?? 0,
      maxRetries: json['maxRetries'] ?? 3,
    );
  }
}

enum SyncEventType {
  networkStatusChanged,
  syncStarted,
  syncCompleted,
  operationQueued,
  operationCompleted,
  operationFailed,
}

class SyncEvent {
  final SyncEventType type;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  SyncEvent({
    required this.type,
    required this.data,
  }) : timestamp = DateTime.now();
}

/// 네트워크 연결 모니터
class NetworkMonitor {
  static final NetworkMonitor _instance = NetworkMonitor._internal();
  factory NetworkMonitor() => _instance;
  NetworkMonitor._internal();

  Timer? _timer;
  bool _isOnline = true;
  
  final StreamController<bool> _statusController = StreamController.broadcast();
  Stream<bool> get statusStream => _statusController.stream;
  bool get isOnline => _isOnline;

  /// 네트워크 모니터링 시작
  void startMonitoring() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      _checkConnectivity();
    });
    _checkConnectivity();
  }

  /// 연결 상태 확인
  Future<void> _checkConnectivity() async {
    // 실제 구현: connectivity_plus 패키지 사용
    // final result = await Connectivity().checkConnectivity();
    // final isOnline = result != ConnectivityResult.none;

    // MVP 시뮬레이션: 항상 온라인
    const isOnline = true;

    if (_isOnline != isOnline) {
      _isOnline = isOnline;
      _statusController.add(isOnline);
      OfflineSyncManager().updateNetworkStatus(isOnline);
    }
  }

  /// 모니터링 중지
  void stopMonitoring() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> dispose() async {
    stopMonitoring();
    await _statusController.close();
  }
}
