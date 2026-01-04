import '../../domain/entities/user.dart';

/// 사용자 모델 (데이터 계층)
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    super.name,
    super.phoneNumber,
    super.profileImage,
    required super.createdAt,
    super.updatedAt,
    super.emailVerified,
    super.isActive,
    super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'],
      phoneNumber: json['phone_number'],
      profileImage: json['profile_image'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      emailVerified: json['email_verified'] ?? false,
      isActive: json['is_active'] ?? true,
      role: UserRole.values.firstWhere(
        (r) => r.name == (json['role'] ?? 'user'),
        orElse: () => UserRole.user,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'phone_number': phoneNumber,
    'profile_image': profileImage,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'email_verified': emailVerified,
    'is_active': isActive,
    'role': role.name,
  };

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      phoneNumber: user.phoneNumber,
      profileImage: user.profileImage,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      emailVerified: user.emailVerified,
      isActive: user.isActive,
      role: user.role,
    );
  }
}
