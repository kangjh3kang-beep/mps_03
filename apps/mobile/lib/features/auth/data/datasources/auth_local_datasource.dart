import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/auth_token_model.dart';
import 'dart:convert';

abstract class AuthLocalDatasource {
  Future<void> saveToken(AuthTokenModel token);
  Future<AuthTokenModel?> getToken();
  Future<void> deleteToken();
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> deleteUser();
  Future<bool> isTokenValid();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final FlutterSecureStorage secureStorage;
  final SharedPreferences prefs;

  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'user_data';
  static const String _expiresAtKey = 'token_expires_at';

  AuthLocalDatasourceImpl(this.secureStorage, this.prefs);

  @override
  Future<void> saveToken(AuthTokenModel token) async {
    await secureStorage.write(
      key: _tokenKey,
      value: token.accessToken,
    );
    await secureStorage.write(
      key: _refreshTokenKey,
      value: token.refreshToken,
    );
    await prefs.setString(
      _expiresAtKey,
      token.expiresAt.toIso8601String(),
    );
  }

  @override
  Future<AuthTokenModel?> getToken() async {
    final accessToken = await secureStorage.read(key: _tokenKey);
    final refreshToken = await secureStorage.read(key: _refreshTokenKey);
    final expiresAtStr = prefs.getString(_expiresAtKey);

    if (accessToken != null && refreshToken != null && expiresAtStr != null) {
      return AuthTokenModel(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresAt: DateTime.parse(expiresAtStr),
      );
    }
    return null;
  }

  @override
  Future<void> deleteToken() async {
    await secureStorage.delete(key: _tokenKey);
    await secureStorage.delete(key: _refreshTokenKey);
    await prefs.remove(_expiresAtKey);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  @override
  Future<UserModel?> getUser() async {
    final userStr = prefs.getString(_userKey);
    if (userStr != null) {
      return UserModel.fromJson(jsonDecode(userStr));
    }
    return null;
  }

  @override
  Future<void> deleteUser() async {
    await prefs.remove(_userKey);
  }

  @override
  Future<bool> isTokenValid() async {
    final token = await getToken();
    return token != null && !token.isExpired;
  }
}
