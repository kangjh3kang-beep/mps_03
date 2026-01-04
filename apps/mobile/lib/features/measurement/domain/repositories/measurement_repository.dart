import '../entities/measurement_entities.dart';

abstract class MeasurementRepository {
  Future<MeasurementSession> createSession(String cartridgeType, String deviceId);
  Future<void> updateSession(MeasurementSession session);
  Future<MeasurementSession?> getSession(String sessionId);
  Future<List<MeasurementSession>> getHistory(String userId);
}
