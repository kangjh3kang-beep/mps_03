import 'package:dartz/dartz.dart';

abstract class MarketplaceRepository {
  Future<Either<Exception, List<dynamic>>> getCartridges();
  Future<Either<Exception, Map<String, dynamic>>> purchaseItem(String itemId);
}

class MarketplaceRepositoryImpl implements MarketplaceRepository {
  @override
  Future<Either<Exception, List<dynamic>>> getCartridges() async {
    return Right([]);
  }

  @override
  Future<Either<Exception, Map<String, dynamic>>> purchaseItem(String itemId) async {
    return Left(Exception('Not implemented'));
  }
}
