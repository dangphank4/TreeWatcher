import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_api/core/models/user_model.dart';
import 'package:flutter_api/modules/account/data/datasource/account_api.dart';

class AccountRepository {
  final AccountApi api;
  final FirebaseAuth _auth;

  AccountRepository({
    required this.api,
    FirebaseAuth? auth,
  }) : _auth = auth ?? FirebaseAuth.instance;

  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;

    final data = await api.getUserById(firebaseUser.uid);
    if (data == null) return null;

    final user = UserModel(
      userId: firebaseUser.uid,
      fullName: data['fullName'] ?? '',
      email: firebaseUser.email ?? '',
      accessToken: data['accessToken'] ?? null,
      gender: data['gender'] ?? ''
    );

    return user;
  }


  Future<bool> hasCompletedProfile() async {
    final user = await getCurrentUser();
    return user?.fullName?.isNotEmpty == true;
  }
}
