import 'package:dartz/dartz.dart';
import '../repositories/home_repository.dart';
import '../entities/health_data.dart';

class GetHomeDataUsecase {
  final HomeRepository repository;

  GetHomeDataUsecase(this.repository);

  Future<Either<Exception, HomeData>> call() async {
    try {
      final scoreResult = await repository.getHealthScore();
      final airResult = await repository.getAirQualityIndex();
      final waterResult = await repository.getWaterQualityIndex();
      final trendsResult = await repository.getRecentTrends();
      final insightResult = await repository.getAIInsight();
      final readersResult = await repository.getConnectedReaders();
      final contactsResult = await repository.getEmergencyContacts();

      return scoreResult.fold(
        (error) => Left(error),
        (score) => airResult.fold(
          (error) => Left(error),
          (airQuality) => waterResult.fold(
            (error) => Left(error),
            (waterQuality) => trendsResult.fold(
              (error) => Left(error),
              (trends) => insightResult.fold(
                (error) => Left(error),
                (insight) => readersResult.fold(
                  (error) => Left(error),
                  (readers) => contactsResult.fold(
                    (error) => Left(error),
                    (contacts) => Right(
                      HomeData(
                        healthScore: score,
                        airQuality: airQuality,
                        waterQuality: waterQuality,
                        recentTrends: trends,
                        aiInsight: insight,
                        connectedReaders: readers,
                        emergencyContacts: contacts,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      return Left(Exception('Failed to fetch home data: $e'));
    }
  }
}

class HomeData {
  final HealthScore healthScore;
  final EnvironmentData airQuality;
  final EnvironmentData waterQuality;
  final List<TrendData> recentTrends;
  final AIInsight aiInsight;
  final List<dynamic> connectedReaders;
  final List<dynamic> emergencyContacts;

  HomeData({
    required this.healthScore,
    required this.airQuality,
    required this.waterQuality,
    required this.recentTrends,
    required this.aiInsight,
    required this.connectedReaders,
    required this.emergencyContacts,
  });
}
