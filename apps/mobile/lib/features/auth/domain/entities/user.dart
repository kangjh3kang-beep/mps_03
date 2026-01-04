import 'package:equatable/equatable.dart';

enum UserRole { user, admin, doctor }

class User extends Equatable {
  final String id;
  final String email;
  final String name;
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
    required this.name,
    this.phoneNumber,
    this.profileImage,
    required this.createdAt,
    this.updatedAt,
    this.emailVerified = false,
    this.isActive = true,
    this.role = UserRole.user,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        phoneNumber,
        profileImage,
        createdAt,
        updatedAt,
        emailVerified,
        isActive,
        role,
      ];
}
