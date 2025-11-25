import 'package:flutter_api/modules/auth/data/datasource/auth_api.dart';

class AuthRepository {
  final AuthApi api;

  AuthRepository({required this.api});

  /// Login: trả về Map chứa token, userId, username
  Future<Map<String, String>?> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await api.login(email: email, password: password);
      final token = await api.getIdToken(userCredential.user!);
      final userId = userCredential.user!.uid;
      final username = userCredential.user!.email ?? '';

      return {
        'token': token,
        'userId': userId,
        'username': username,
      };
    } catch (_) {
      return null;
    }
  }

  /// Register: tạo user mới và trả về Map giống login
  Future<Map<String, String>?> register({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await api.register(email: email, password: password);
      final token = await api.getIdToken(userCredential.user!);
      final userId = userCredential.user!.uid;
      final username = userCredential.user!.email ?? '';

      return {
        'token': token,
        'userId': userId,
        'username': username,
      };
    } catch (_) {
      return null;
    }
  }

  /// Logout
  Future<void> logout() async {
    await api.logout();
  }
}
