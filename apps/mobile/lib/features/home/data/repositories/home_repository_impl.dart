import 'package:dartz/dartz.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/entities/health_data.dart';
import '../../../services/http_client_service.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HttpClientService httpClient;

  HomeRepositoryImpl(this.httpClient);

  @override
  Future<Either<Exception, HealthScore>> getHealthScore() async {
    try {
      final response = await httpClient.get('/home/health-score');
      final data = response.containsKey('data') ? response['data'] : response;
      return Right(HealthScore.fromJson(data));
    } catch (e) {
      return Left(Exception('Failed to get health score: $e'));
    }
  }

  @override
  Future<Either<Exception, EnvironmentData>> getAirQualityIndex() async {
    try {
      final response = await httpClient.get('/home/environment/air');
      final data = response.containsKey('data') ? response['data'] : response;
      return Right(EnvironmentData.fromJson(data));
    } catch (e) {
      return Left(Exception('Failed to get air quality: $e'));
    }
  }

  @override
  Future<Either<Exception, EnvironmentData>> getWaterQualityIndex() async {
    try {
      final response = await httpClient.get('/home/environment/water');
      final data = response.containsKey('data') ? response['data'] : response;
      return Right(EnvironmentData.fromJson(data));
    } catch (e) {
      return Left(Exception('Failed to get water quality: $e'));
    }
  }

  @override
  Future<Either<Exception, List<TrendData>>> getRecentTrends({int days = 7}) async {
    try {
      final response = await httpClient.get(
        '/home/trends',
        queryParameters: {'days': days},
      );
      final data = response.containsKey('data') ? response['data'] : response;
      if (data is List) {
        return Right(data.map((e) => TrendData.fromJson(e)).toList());
      }
      return const Right([]);
    } catch (e) {
      return Left(Exception('Failed to get trends: $e'));
    }
  }

  @override
  Future<Either<Exception, AIInsight>> getAIInsight() async {
    try {
      final response = await httpClient.get('/home/ai-insight');
      final data = response.containsKey('data') ? response['data'] : response;
      return Right(AIInsight.fromJson(data));
    } catch (e) {
      return Left(Exception('Failed to get AI insight: $e'));
    }
  }

  @override
  Future<Either<Exception, List<dynamic>>> getConnectedReaders() async {
    try {
      final response = await httpClient.get('/home/readers');
      final data = response.containsKey('data') ? response['data'] : response;
      return Right(data is List ? data : []);
    } catch (e) {
      return Left(Exception('Failed to get connected readers: $e'));
    }
  }

  @override
  Future<Either<Exception, List<dynamic>>> getEmergencyContacts() async {
    try {
      final response = await httpClient.get('/home/emergency-contacts');
      final data = response.containsKey('data') ? response['data'] : response;
      return Right(data is List ? data : []);
    } catch (e) {
      return Left(Exception('Failed to get emergency contacts: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> updateEmergencyContact(dynamic contact) async {
    try {
      await httpClient.post('/home/emergency-contacts', data: contact);
      return const Right(null);
    } catch (e) {
      return Left(Exception('Failed to update emergency contact: $e'));
    }
  }
}
