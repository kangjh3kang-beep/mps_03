import 'package:dartz/dartz.dart';
import 'entities/health_data.dart';

abstract class HomeRepository {
  Future<Either<Exception, HealthScore>> getHealthScore();
  Future<Either<Exception, EnvironmentData>> getAirQualityIndex();
  Future<Either<Exception, EnvironmentData>> getWaterQualityIndex();
  Future<Either<Exception, List<TrendData>>> getRecentTrends({int days = 7});
  Future<Either<Exception, AIInsight>> getAIInsight();
  Future<Either<Exception, List<dynamic>>> getConnectedReaders();
  Future<Either<Exception, List<dynamic>>> getEmergencyContacts();
  Future<Either<Exception, void>> updateEmergencyContact(dynamic contact);
}
