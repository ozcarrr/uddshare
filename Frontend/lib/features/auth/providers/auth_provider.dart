import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/constants.dart';

class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? career;

  const UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.career,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        email: json['email'] as String,
        displayName: json['display_name'] as String?,
        career: json['career'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'display_name': displayName,
        'career': career,
      };
}

class AuthProvider extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  final _dio = Dio(BaseOptions(baseUrl: AppConstants.apiBaseUrl));

  UserModel? _user;
  String? _token;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _token != null;

  Future<void> loadStoredAuth() async {
    _token = await _storage.read(key: AppConstants.tokenKey);
    final userJson = await _storage.read(key: AppConstants.userKey);
    if (_token != null && userJson != null) {
      try {
        _user = UserModel.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
      } catch (_) {
        await logout();
      }
    }
    notifyListeners();
  }

  Future<bool> register({
    required String email,
    required String password,
    String? displayName,
    String? career,
  }) async {
    if (!email.endsWith('@udd.cl')) {
      _error = 'Solo se permiten correos @udd.cl';
      notifyListeners();
      return false;
    }
    _setLoading(true);
    try {
      final response = await _dio.post('/auth/register', data: {
        'email': email,
        'password': password,
        if (displayName != null && displayName.isNotEmpty) 'display_name': displayName,
        if (career != null && career.isNotEmpty) 'career': career,
      });
      await _persistAuth(response.data as Map<String, dynamic>);
      return true;
    } on DioException catch (e) {
      _error = (e.response?.data as Map<String, dynamic>?)?['detail'] as String? ??
          'Error al registrarse';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> login({required String email, required String password}) async {
    if (!email.endsWith('@udd.cl')) {
      _error = 'Solo se permiten correos @udd.cl';
      notifyListeners();
      return false;
    }
    _setLoading(true);
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      await _persistAuth(response.data as Map<String, dynamic>);
      return true;
    } on DioException catch (e) {
      _error = (e.response?.data as Map<String, dynamic>?)?['detail'] as String? ??
          'Error al iniciar sesión';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: AppConstants.tokenKey);
    await _storage.delete(key: AppConstants.userKey);
    _token = null;
    _user = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> _persistAuth(Map<String, dynamic> data) async {
    _token = data['access_token'] as String;
    _user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
    await _storage.write(key: AppConstants.tokenKey, value: _token);
    await _storage.write(
        key: AppConstants.userKey, value: jsonEncode(_user!.toJson()));
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    if (value) _error = null;
    notifyListeners();
  }
}
