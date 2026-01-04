import 'package:equatable/equatable.dart';

/// 사용자 엔티티
class User extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? phoneNumber;
  final String? profileImage;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool emailVerified;
  final bool isActive;
  final UserRole role;

  const User({
    required this.id,
    required this.email,
    this.name,
    this.phoneNumber,
    this.profileImage,
    required this.createdAt,
    this.updatedAt,
    this.emailVerified = false,
    this.isActive = true,
    this.role = UserRole.user,
  });

  @override
  List<Object?> get props => [id, email, name, phoneNumber, profileImage, createdAt, updatedAt, emailVerified, isActive, role];

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phoneNumber,
    String? profileImage,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? emailVerified,
    bool? isActive,
    UserRole? role,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      emailVerified: emailVerified ?? this.emailVerified,
      isActive: isActive ?? this.isActive,
      role: role ?? this.role,
    );
  }

  factory User.empty() => User(
    id: '',
    email: '',
    createdAt: DateTime.now(),
  );
}

/// 사용자 역할
enum UserRole {
  user,
  admin,
  doctor,
  researcher,
}

/// 인증 토큰 엔티티
class AuthToken extends Equatable {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final String tokenType;

  const AuthToken({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    this.tokenType = 'Bearer',
  });

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresAt, tokenType];

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  factory AuthToken.empty() => AuthToken(
    accessToken: '',
    refreshToken: '',
    expiresAt: DateTime.now(),
  );
}

/// 인증 결과
class AuthResult extends Equatable {
  final User user;
  final AuthToken token;

  const AuthResult({
    required this.user,
    required this.token,
  });

  @override
  List<Object?> get props => [user, token];
}
