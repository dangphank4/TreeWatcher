import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/utils/utils.dart';

class UserApi {
  final _db = FirebaseFirestore.instance;

  Future<bool> ensureUser({
    required String uid,
    required String email,
  }) async {
    try {
      final ref = _db.collection('users').doc(uid);
      final snap = await ref.get();

      if (snap.exists) {
        Utils.debugLog('[USER] already exists: $uid');
        return false;
      }

      await ref.set({
        'email': email,
        'phone' : "",
        'role': "user",
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt' : FieldValue.serverTimestamp()
      });

      Utils.debugLog('[USER] created: $uid');
      return true;
    } catch (e) {
      Utils.debugLog('[USER] create FAILED: $e');
      rethrow;
    }
  }

}