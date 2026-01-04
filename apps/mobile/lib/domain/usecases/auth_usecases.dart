import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';
import '../entities/user.dart';

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  Future<Either<Exception, AuthToken>> call({
    required String email,
    required String password,
  }) async {
    // Validation
    if (email.isEmpty || !email.contains('@')) {
      return Left(Exception('Invalid email format'));
    }
    if (password.isEmpty || password.length < 6) {
      return Left(Exception('Invalid password'));
    }

    return await repository.login(email: email, password: password);
  }
}

class SignupUsecase {
  final AuthRepository repository;

  SignupUsecase(this.repository);

  Future<Either<Exception, User>> call({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    // Validation
    if (email.isEmpty || !email.contains('@')) {
      return Left(Exception('Invalid email format'));
    }
    if (password.isEmpty || password.length < 6) {
      return Left(Exception('Password must be at least 6 characters'));
    }
    if (name.isEmpty) {
      return Left(Exception('Name is required'));
    }

    return await repository.signup(
      email: email,
      password: password,
      name: name,
      phoneNumber: phoneNumber,
    );
  }
}

class LogoutUsecase {
  final AuthRepository repository;

  LogoutUsecase(this.repository);

  Future<Either<Exception, void>> call() async {
    return await repository.logout();
  }
}

class CheckAuthUsecase {
  final AuthRepository repository;

  CheckAuthUsecase(this.repository);

  Future<Either<Exception, bool>> call() async {
    return await repository.isAuthenticated();
  }
}
