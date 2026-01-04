import 'package:dartz/dartz.dart';

class GetHealthInsightUsecase {
  final dynamic repository;
  GetHealthInsightUsecase(this.repository);
  
  Future<Either<Exception, Map<String, dynamic>>> call() async {
    return Left(Exception('Not implemented'));
  }
}

class ChatWithAIUsecase {
  final dynamic repository;
  ChatWithAIUsecase(this.repository);
  
  Future<Either<Exception, Map<String, dynamic>>> call(String message) async {
    return Left(Exception('Not implemented'));
  }
}
