import 'package:firebase_auth/firebase_auth.dart';

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
}
