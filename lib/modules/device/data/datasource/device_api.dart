import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class DeviceException implements Exception {
  final String message;
  DeviceException(this.message);

  @override
  String toString() => message;
}

class DeviceApi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final FirebaseDatabase _realtime = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://tree-watcher-4bddd-default-rtdb.asia-southeast1.firebasedatabase.app',
  );
  //Thêm thiết bị
  Future<void> addDeviceToUser({
    required String userId,
    required String deviceId,
    required String name,
  }) async {
    final ref = _firestore
        .collection('users')
        .doc(userId)
        .collection('devices')
        .doc(deviceId);

    await ref.set({
      'name': name,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  //Đổi tên
  Future<void> renameDevice({
    required String userId,
    required String deviceId,
    required String newName,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('devices')
        .doc(deviceId)
        .update({
      'name': newName,
    });
  }

  //Xóa
  Future<void> deleteDevice({
    required String userId,
    required String deviceId,
  }) async {
    final ref = _firestore
        .collection('users')
        .doc(userId)
        .collection('devices')
        .doc(deviceId);

    await ref.delete();
  }

  //Lay thiet bi
  Future<List<Map<String, dynamic>>> getDevices(String userId) async {
    final snap = await _firestore
        .collection('users')
        .doc(userId)
        .collection('devices')
        .orderBy('createdAt', descending: true)
        .get();

    return snap.docs.map((doc) {
      return {
        'deviceId': doc.id,
        ...doc.data(),
      };
    }).toList();
  }

  //Xac thuc
  Future<void> verifyDevice({
    required String deviceId,
    required String password,
  }) async {
    final ref = _realtime.ref('sensors/$deviceId');
    final snap = await ref.get();

    if (!snap.exists) {
      throw DeviceException('Thiết bị không tồn tại');
    }

    final data = Map<String, dynamic>.from(snap.value as Map);

    if (data['password'] != password) {
      throw DeviceException('Sai mật khẩu thiết bị');
    }
  }

  //Đăng ký thiết bị
  Future<void> registerDevice({
    required String userId,
    required String deviceId,
    required String deviceName,
    required String password,
  }) async {
    await verifyDevice(
      deviceId: deviceId,
      password: password,
    );

    await addDeviceToUser(
      userId: userId,
      deviceId: deviceId,
      name: deviceName,
    );
  }
}
