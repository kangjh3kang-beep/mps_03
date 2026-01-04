import 'package:dartz/dartz.dart';

class GetCartridgesUsecase {
  final dynamic repository;
  GetCartridgesUsecase(this.repository);
  
  Future<Either<Exception, List<dynamic>>> call() async {
    return Right([]);
  }
}

class PurchaseCartridgeUsecase {
  final dynamic repository;
  final dynamic paymentService;
  
  PurchaseCartridgeUsecase(this.repository, this.paymentService);
  
  Future<Either<Exception, Map<String, dynamic>>> call(String cartridgeId) async {
    return Left(Exception('Not implemented'));
  }
}
