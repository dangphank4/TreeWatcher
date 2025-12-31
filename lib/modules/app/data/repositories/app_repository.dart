import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_api/modules/app/data/datasources/app_api.dart';

class AppRepository{
  final AppApi api;
  AppRepository({required this.api});

  Stream<DocumentSnapshot<Map<String, dynamic>>> subscribeUser() {
    return api.userStream();
  }

  Future<void> updateUserProfile({
    required String fullName,
    required String phone,
    required String gender
  }) {
    return api.updateUser(
      fullName: fullName,
      phone: phone,
      gender: gender
    );
  }
}