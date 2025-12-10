import 'package:firebase_database/firebase_database.dart';

class DeviceApi {
  final db = FirebaseDatabase.instance.ref();

  Future<Map?> getSensor(String sensorId) async {
    final snap = await db.child("sensors/$sensorId").get();
    return snap.exists ? snap.value as Map : null;
  }

  Future<void> assignOwner({
    required String userId,
    required String sensorId,
    required String name,
  }) async {
    // User side
    await db.child("users/$userId/devices/$sensorId").set({
      "role": "owner",
      "name": name,
    });

    await db.child("sensors/$sensorId/owners/$userId").set(true);
  }
}
