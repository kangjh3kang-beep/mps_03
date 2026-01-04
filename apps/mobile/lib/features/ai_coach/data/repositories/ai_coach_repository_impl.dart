import 'package:dartz/dartz.dart';

abstract class AICoachRepository {
  Future<Either<Exception, Map<String, dynamic>>> getHealthInsight();
  Future<Either<Exception, Map<String, dynamic>>> chat(String message);
}

class AICoachRepositoryImpl implements AICoachRepository {
  @override
  Future<Either<Exception, Map<String, dynamic>>> getHealthInsight() async {
    return Left(Exception('Not implemented'));
  }

  @override
  Future<Either<Exception, Map<String, dynamic>>> chat(String message) async {
    return Left(Exception('Not implemented'));
  }
}
