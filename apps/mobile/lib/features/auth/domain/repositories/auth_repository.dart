import 'package:dartz/dartz.dart';
import 'user.dart';
import 'auth_token.dart';

abstract class AuthRepository {
  Future<Either<Exception, AuthToken>> login({
    required String email,
    required String password,
  });

  Future<Either<Exception, User>> signup({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  });

  Future<Either<Exception, void>> logout();

  Future<Either<Exception, AuthToken?>> refreshToken();

  Future<Either<Exception, bool>> isAuthenticated();

  Future<Either<Exception, User?>> getCurrentUser();

  Future<Either<Exception, void>> sendResetPasswordEmail(String email);

  Future<Either<Exception, void>> resetPassword({
    required String token,
    required String newPassword,
  });

  Future<Either<Exception, AuthToken>> verifyEmail(String token);
}
