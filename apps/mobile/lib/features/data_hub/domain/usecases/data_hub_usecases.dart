import 'package:dartz/dartz.dart';

class GetTrendDataUsecase {
  final dynamic repository;
  GetTrendDataUsecase(this.repository);
  
  Future<Either<Exception, List<dynamic>>> call({
    required String metricType,
    required DateTime periodStart,
    required DateTime periodEnd,
  }) async {
    return Left(Exception('Not implemented'));
  }
}
