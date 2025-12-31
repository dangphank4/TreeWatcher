import 'package:flutter_api/modules/auth/data/datasource/auth_api.dart';
import 'package:flutter_api/modules/auth/data/datasource/user_api.dart';

import '../../../../core/utils/utils.dart';

class AuthRepository {
  final AuthApi api;
  final UserApi userApi;

  AuthRepository({required this.api , required this.userApi});

  /// Login: trả về Map chứa token, userId, username
  Future<Map<String, String>?> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await api.login(email: email, password: password);

      final user = userCredential.user!;
      final token = await api.getIdToken(userCredential.user!);

      await userApi.ensureUser(
        uid: user.uid,
        email: user.email!,
      );

      return {
        'token': token,
        'userId': user.uid,
        'username': user.email ?? "user",
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

      final user = userCredential.user!;
      final token = await api.getIdToken(user);

      await userApi.ensureUser(
        uid: user.uid,
        email: user.email!,
      );

      return {
        'token': token,
        'userId': user.uid,
        'username': user.email ?? '',
      };

    } catch (e) {
      Utils.debugLog('[REGISTER] FAILED: $e');
      return null;
    }
  }


  /// Logout
  Future<void> logout() async {
    await api.logout();
  }

  Future<bool> resetPassword({required String email}) async {
    try {
      await api.resetPassword(email: email);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updatePassword({
    required String currentPassword,
    required String newPassword,
}) async {
    try{
      await api.updatePassword(currentPassword: currentPassword, newPassword: newPassword);
      return true;
    } catch (_) {
      return false;
    }
  }
}
