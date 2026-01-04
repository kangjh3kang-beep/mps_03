import '../entities/user.dart';

/// 인증 레포지토리 인터페이스
abstract class AuthRepository {
  /// 이메일/비밀번호로 로그인
  Future<AuthResult> login(String email, String password);

  /// 회원가입
  Future<AuthResult> signup({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  });

  /// 로그아웃
  Future<void> logout();

  /// 토큰 갱신
  Future<AuthToken> refreshToken(String refreshToken);

  /// 현재 사용자 조회
  Future<User?> getCurrentUser();

  /// 사용자 정보 업데이트
  Future<User> updateUser(User user);

  /// 비밀번호 재설정 요청
  Future<void> requestPasswordReset(String email);

  /// 비밀번호 재설정
  Future<void> resetPassword(String token, String newPassword);

  /// 이메일 인증 확인
  Future<bool> verifyEmail(String token);

  /// 로그인 상태 확인
  Future<bool> isLoggedIn();

  /// 로컬 인증 정보 삭제
  Future<void> clearLocalAuth();
}
