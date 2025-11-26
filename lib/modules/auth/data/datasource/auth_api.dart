import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthApi {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Login với email/password
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Đăng ký (register) user mới
  Future<UserCredential> register({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Lấy Firebase ID Token
  Future<String> getIdToken(User user) async {
    final token = await user.getIdToken();
    if (token == null) {
      throw Exception("Cannot get Firebase ID Token");
    }
    return token;
  }

  /// Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// Gửi email đặt lại mật khẩu
  Future<void> resetPassword({
    required String email,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Reset password failed");
    }
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("Người dùng chưa đăng nhập");
    }

    try {
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(cred);

      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Đổi mật khẩu thất bại");
    }
  }
}
