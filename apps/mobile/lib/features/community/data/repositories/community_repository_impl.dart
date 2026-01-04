import 'package:dartz/dartz.dart';

abstract class CommunityRepository {
  Future<Either<Exception, List<dynamic>>> getForums();
  Future<Either<Exception, Map<String, dynamic>>> getForumPosts(String forumId);
}

class CommunityRepositoryImpl implements CommunityRepository {
  @override
  Future<Either<Exception, List<dynamic>>> getForums() async {
    return Right([]);
  }

  @override
  Future<Either<Exception, Map<String, dynamic>>> getForumPosts(String forumId) async {
    return Left(Exception('Not implemented'));
  }
}
