import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import '../config/mvp_config.dart';

/// 오프라인 모드 관리자 - Hive 기반 로컬 우선 전략
class OfflineModeManager {
  static const String _offlineBoxName = 'offline_data';
  static const String _syncQueueBoxName = 'sync_queue';
  static const String _metadataBoxName = 'offline_metadata';

  late Box<Map> _offlineBox;
  late Box<Map> _syncQueueBox;
  late Box<Map> _metadataBox;

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectionSubscription;

  bool _isOnline = true;
  bool get isOnline => _isOnline;

  final _statusStreamController = StreamController<OfflineStatus>.broadcast();
  Stream<OfflineStatus> get statusStream => _statusStreamController.stream;

  Future<void> init() async {
    // Hive 박스 초기화
    _offlineBox = await Hive.openBox<Map>(_offlineBoxName);
    _syncQueueBox = await Hive.openBox<Map>(_syncQueueBoxName);
    _metadataBox = await Hive.openBox<Map>(_metadataBoxName);

    // 연결 상태 모니터링
    _connectionSubscription = _connectivity.onConnectivityChanged.listen((result) {
      _isOnline = result != ConnectivityResult.none;
      _statusStreamController.add(OfflineStatus(
        isOnline: _isOnline,
        syncQueueSize: _syncQueueBox.length,
        lastSyncTime: _getLastSyncTime(),
      ));

      if (_isOnline) {
        _processSyncQueue();
      }
    });

    // 초기 연결 상태 확인
    final result = await _connectivity.checkConnectivity();
    _isOnline = result != ConnectivityResult.none;
  }

  // ===== 오프라인 데이터 저장 =====

  /// 데이터를 로컬 Hive에 저장 (오프라인 우선)
  Future<void> saveOfflineData(
    String key,
    Map<String, dynamic> data, {
    required String dataType, // 'measurement', 'health', 'analytics'
    required DateTime timestamp,
  }) async {
    final offlineData = {
      'key': key,
      'data': data,
      'dataType': dataType,
      'timestamp': timestamp.toIso8601String(),
      'synced': false,
      'version': 1,
    };

    // Hive에 저장
    await _offlineBox.put(key, offlineData);

    // 오프라인 상태면 동기화 큐에 추가
    if (!_isOnline) {
      await _addToSyncQueue(key, offlineData);
    }

    _updateMetadata();
  }

  /// Hive에서 데이터 조회
  Future<Map<String, dynamic>?> getOfflineData(String key) async {
    final data = _offlineBox.get(key);
    if (data != null) {
      return Map<String, dynamic>.from(data);
    }
    return null;
  }

  /// 특정 데이터 타입의 모든 데이터 조회
  Future<List<Map<String, dynamic>>> getOfflineDataByType(String dataType) async {
    return _offlineBox.values
        .where((item) => item['dataType'] == dataType)
        .cast<Map<String, dynamic>>()
        .toList();
  }

  /// 아직 동기화되지 않은 데이터 조회
  Future<List<Map<String, dynamic>>> getUnsyncedData() async {
    return _offlineBox.values
        .where((item) => item['synced'] == false)
        .cast<Map<String, dynamic>>()
        .toList();
  }

  // ===== 동기화 큐 관리 =====

  Future<void> _addToSyncQueue(String key, Map<String, dynamic> data) async {
    if (_syncQueueBox.length >= OfflineModeConfig.maxSyncQueueSize) {
      // 큐가 가득 차면 가장 오래된 항목 제거
      final oldestKey = _syncQueueBox.keys.first;
      await _syncQueueBox.delete(oldestKey);
    }

    await _syncQueueBox.put(key, {
      ...data,
      'queuedAt': DateTime.now().toIso8601String(),
      'retryCount': 0,
    });
  }

  /// 온라인 상태로 복귀 시 동기화 처리
  Future<void> _processSyncQueue() async {
    final queueSize = _syncQueueBox.length;
    if (queueSize == 0) return;

    print('[OfflineMode] 동기화 시작: $queueSize개 항목');

    // 배치로 나누어 처리 (기본값: 100개)
    final batchSize = OfflineModeConfig.syncStrategy.batchSize;
    final items = _syncQueueBox.toMap();

    for (int i = 0; i < items.length; i += batchSize) {
      final batch = items.entries
          .skip(i)
          .take(batchSize)
          .map((e) => MapEntry(e.key, e.value))
          .toList();

      await _syncBatch(batch);
    }

    print('[OfflineMode] 동기화 완료');
    _updateMetadata();
  }

  Future<void> _syncBatch(List<MapEntry<dynamic, Map>> batch) async {
    for (final entry in batch) {
      bool synced = false;
      int retryCount = 0;

      while (!synced && retryCount < OfflineModeConfig.syncStrategy.maxRetries) {
        try {
          // 실제 백엔드 동기화 (여기에서 API 호출)
          // await _backendService.sync(entry.value);

          // 동기화 성공
          await _offlineBox.put(entry.key, {
            ...entry.value,
            'synced': true,
            'syncedAt': DateTime.now().toIso8601String(),
          });

          await _syncQueueBox.delete(entry.key);
          synced = true;
        } catch (e) {
          retryCount++;

          if (OfflineModeConfig.syncStrategy.exponentialBackoff) {
            // 지수 백오프: 1s, 2s, 4s, 8s
            final delayMs = Duration(seconds: 1 << (retryCount - 1));
            await Future.delayed(delayMs);
          }

          if (retryCount >= OfflineModeConfig.syncStrategy.maxRetries) {
            print('[OfflineMode] 동기화 실패: ${entry.key} (재시도 초과)');
          }
        }
      }
    }
  }

  // ===== 충돌 해결 =====

  /// 로컬과 원격 버전의 충돌 해결
  Map<String, dynamic> resolveConflict(
    Map<String, dynamic> localVersion,
    Map<String, dynamic> remoteVersion,
  ) {
    switch (OfflineModeConfig.syncStrategy.conflictResolution) {
      case 'local-wins':
        // 로컬 버전이 더 최신이면 로컬 우선
        final localTime = DateTime.parse(localVersion['updatedAt'] ?? '1970-01-01');
        final remoteTime = DateTime.parse(remoteVersion['updatedAt'] ?? '1970-01-01');
        return localTime.isAfter(remoteTime) ? localVersion : remoteVersion;

      case 'remote-wins':
        // 원격 버전 우선
        return remoteVersion;

      case 'merge':
        // 병합 전략 (예: 날짜가 더 최신인 것 선택)
        final merged = {...localVersion};
        remoteVersion.forEach((key, value) {
          if (!merged.containsKey(key)) {
            merged[key] = value;
          }
        });
        return merged;

      default:
        return localVersion;
    }
  }

  // ===== 메타데이터 관리 =====

  void _updateMetadata() {
    final syncedCount = _offlineBox.values.where((item) => item['synced'] == true).length;
    final unsyncedCount = _offlineBox.values.where((item) => item['synced'] == false).length;

    _metadataBox.put('offline_stats', {
      'totalItems': _offlineBox.length,
      'syncedItems': syncedCount,
      'unsyncedItems': unsyncedCount,
      'lastUpdated': DateTime.now().toIso8601String(),
    });
  }

  DateTime? _getLastSyncTime() {
    final metadata = _metadataBox.get('offline_stats');
    if (metadata != null && metadata['lastSyncTime'] != null) {
      return DateTime.parse(metadata['lastSyncTime']);
    }
    return null;
  }

  /// 오프라인 데이터 통계
  Map<String, dynamic> getOfflineStats() {
    final stats = _metadataBox.get('offline_stats') as Map?;
    return stats != null
        ? Map<String, dynamic>.from(stats)
        : {
            'totalItems': 0,
            'syncedItems': 0,
            'unsyncedItems': 0,
          };
  }

  /// 오래된 데이터 정리 (retention policy)
  Future<void> cleanupOldData() async {
    final cutoffDate = DateTime.now().subtract(OfflineModeConfig.localDataRetention);

    // 오프라인 데이터 정리
    final keysToDelete = <dynamic>[];
    _offlineBox.toMap().forEach((key, item) {
      if (item['synced'] == true) {
        final itemDate = DateTime.parse(item['timestamp']);
        if (itemDate.isBefore(cutoffDate)) {
          keysToDelete.add(key);
        }
      }
    });

    for (final key in keysToDelete) {
      await _offlineBox.delete(key);
    }

    // 동기화 큐 정리
    final queueKeysToDelete = <dynamic>[];
    _syncQueueBox.toMap().forEach((key, item) {
      final queuedDate = DateTime.parse(item['queuedAt']);
      if (queuedDate.isBefore(cutoffDate)) {
        queueKeysToDelete.add(key);
      }
    });

    for (final key in queueKeysToDelete) {
      await _syncQueueBox.delete(key);
    }

    _updateMetadata();
    print('[OfflineMode] 정리 완료: ${keysToDelete.length + queueKeysToDelete.length}개 항목 삭제');
  }

  /// 모든 오프라인 데이터 삭제
  Future<void> clearAll() async {
    await _offlineBox.clear();
    await _syncQueueBox.clear();
    await _metadataBox.clear();
  }

  Future<void> dispose() async {
    await _connectionSubscription.cancel();
    await _statusStreamController.close();
  }
}

class OfflineStatus {
  final bool isOnline;
  final int syncQueueSize;
  final DateTime? lastSyncTime;

  OfflineStatus({
    required this.isOnline,
    required this.syncQueueSize,
    required this.lastSyncTime,
  });

  String get statusText => isOnline
      ? syncQueueSize > 0
          ? '온라인 (동기화 대기 중: $syncQueueSize개)'
          : '온라인'
      : '오프라인';
}

/// 오프라인 데이터 배경 동기화 서비스
class OfflineSyncService {
  final OfflineModeManager _offlineManager;
  Timer? _syncTimer;

  OfflineSyncService(this._offlineManager);

  /// 정기적 백그라운드 동기화 시작 (5분마다)
  void startBackgroundSync() {
    _syncTimer = Timer.periodic(const Duration(minutes: 5), (_) async {
      if (_offlineManager.isOnline) {
        await _offlineManager._processSyncQueue();
      }
    });
  }

  void stopBackgroundSync() {
    _syncTimer?.cancel();
  }

  /// 즉시 동기화
  Future<void> syncNow() async {
    if (_offlineManager.isOnline) {
      await _offlineManager._processSyncQueue();
    }
  }
}
