import 'package:dartz/dartz.dart';

class GetHomeDataUsecase {
  final dynamic repository;
  GetHomeDataUsecase(this.repository);
  
  Future<Either<Exception, Map<String, dynamic>>> call() async {
    return Left(Exception('Not implemented'));
  }
}
