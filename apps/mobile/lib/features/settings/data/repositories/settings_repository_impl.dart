import 'package:dartz/dartz.dart';

abstract class SettingsRepository {
  Future<Either<Exception, void>> updateSettings(Map<String, dynamic> settings);
  Future<Either<Exception, Map<String, dynamic>>> getSettings();
}

class SettingsRepositoryImpl implements SettingsRepository {
  final dynamic localDatasource;
  
  SettingsRepositoryImpl(this.localDatasource);
  
  @override
  Future<Either<Exception, void>> updateSettings(Map<String, dynamic> settings) async {
    return Right(null);
  }

  @override
  Future<Either<Exception, Map<String, dynamic>>> getSettings() async {
    return Right({});
  }
}
