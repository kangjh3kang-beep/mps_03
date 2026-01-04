import 'package:dartz/dartz.dart';
import '../repositories/measurement_repository.dart';
import '../entities/measurement.dart';

class StartMeasurementUsecase {
  final MeasurementRepository repository;

  StartMeasurementUsecase(this.repository);

  Future<Either<Exception, MeasurementData>> call({
    required String deviceId,
    required String measurementType,
    required CartridgeInfo cartridge,
  }) async {
    // Validation
    if (deviceId.isEmpty) {
      return Left(Exception('Device ID is required'));
    }
    if (measurementType.isEmpty) {
      return Left(Exception('Measurement type is required'));
    }
    if (!cartridge.canUse) {
      return Left(Exception('Cartridge cannot be used (expired or max uses reached)'));
    }

    return await repository.startMeasurement(
      deviceId: deviceId,
      measurementType: measurementType,
      cartridge: cartridge,
    );
  }
}

class GetMeasurementResultUsecase {
  final MeasurementRepository repository;

  GetMeasurementResultUsecase(this.repository);

  Future<Either<Exception, MeasurementData>> call(String measurementId) async {
    if (measurementId.isEmpty) {
      return Left(Exception('Measurement ID is required'));
    }
    return await repository.getMeasurementResult(measurementId);
  }
}

class GetRecentMeasurementsUsecase {
  final MeasurementRepository repository;

  GetRecentMeasurementsUsecase(this.repository);

  Future<Either<Exception, List<MeasurementData>>> call({
    int limit = 10,
    String? type,
  }) async {
    return await repository.getRecentMeasurements(limit: limit, type: type);
  }
}
