import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppApi{
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;


  User? get currentUser => _auth.currentUser;

  Stream<DocumentSnapshot<Map<String, dynamic>>> userStream() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .snapshots();
  }

  Future<void> updateUser({
    required String fullName,
    required String phone,
    required String gender
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    await _firestore.collection('users').doc(user.uid).set({
      'fullName': fullName,
      'phone': phone,
      'email': user.email,
      'gender': gender,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}