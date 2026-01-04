import '../entities/measurement_entities.dart';

/// 측정 레포지토리 인터페이스
abstract class MeasurementRepository {
  /// 측정 시작
  Future<MeasurementSession> startMeasurement({
    required MeasurementType type,
    required String userId,
    String? deviceId,
    String? cartridgeId,
  });

  /// 측정 완료
  Future<MeasurementData> completeMeasurement(MeasurementSession session);

  /// 측정 취소
  Future<void> cancelMeasurement(String sessionId);

  /// 측정 데이터 저장
  Future<void> saveMeasurement(MeasurementData measurement);

  /// 측정 데이터 조회
  Future<MeasurementData?> getMeasurement(String id);

  /// 사용자의 모든 측정 데이터 조회
  Future<List<MeasurementData>> getMeasurements({
    required String userId,
    MeasurementType? type,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  });

  /// 최근 측정 데이터 조회
  Future<List<MeasurementData>> getRecentMeasurements({
    required String userId,
    int limit = 10,
  });

  /// 카트리지 정보 조회
  Future<CartridgeInfo?> getCartridgeInfo(String serialNumber);

  /// 연결된 리더기 목록 조회
  Future<List<ReaderDevice>> getConnectedDevices();

  /// 리더기 연결
  Future<ReaderDevice> connectDevice(String deviceId);

  /// 리더기 연결 해제
  Future<void> disconnectDevice(String deviceId);

  /// 측정 통계 조회
  Future<Map<String, dynamic>> getMeasurementStats({
    required String userId,
    required MeasurementType type,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// 데이터 동기화
  Future<void> syncMeasurements();
}
