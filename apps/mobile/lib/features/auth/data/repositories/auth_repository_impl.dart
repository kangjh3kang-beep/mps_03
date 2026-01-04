import 'package:dartz/dartz.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  final AuthLocalDatasource localDatasource;

  AuthRepositoryImpl(this.remoteDatasource, this.localDatasource);

  @override
  Future<Either<Exception, AuthToken>> login({
    required String email,
    required String password,
  }) async {
    try {
      final token = await remoteDatasource.login(email: email, password: password);
      await localDatasource.saveToken(token);
      return Right(token);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, User>> signup({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    try {
      final user = await remoteDatasource.signup(
        email: email,
        password: password,
        name: name,
        phoneNumber: phoneNumber,
      );
      await localDatasource.saveUser(user);
      return Right(user);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, void>> logout() async {
    try {
      await remoteDatasource.logout();
      await localDatasource.deleteToken();
      await localDatasource.deleteUser();
      return const Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, AuthToken?>> refreshToken() async {
    try {
      final token = await remoteDatasource.refreshToken();
      await localDatasource.saveToken(token);
      return Right(token);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, bool>> isAuthenticated() async {
    try {
      final isValid = await localDatasource.isTokenValid();
      return Right(isValid);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, User?>> getCurrentUser() async {
    try {
      final user = await localDatasource.getUser();
      return Right(user);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, void>> sendResetPasswordEmail(String email) async {
    // TODO: Implement
    return const Right(null);
  }

  @override
  Future<Either<Exception, void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    // TODO: Implement
    return const Right(null);
  }

  @override
  Future<Either<Exception, AuthToken>> verifyEmail(String token) async {
    // TODO: Implement
    throw UnimplementedError();
  }
}
