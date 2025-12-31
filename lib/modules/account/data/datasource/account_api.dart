import 'package:cloud_firestore/cloud_firestore.dart';

class AccountApi {
  final _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUserById(String uid) async {
    final doc = await _firestore
        .collection('users')
        .doc(uid)
        .get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return doc.data();
  }
}
