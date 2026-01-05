import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class DeviceRealtimeDatasource {
  final FirebaseDatabase _db = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
    'https://tree-watcher-4bddd-default-rtdb.asia-southeast1.firebasedatabase.app',
  );

  /// SENSOR VIEW
  Stream<Map<String, dynamic>> watchDeviceView(String deviceId) {
    final ref = _db.ref('sensors/$deviceId/view');

    return ref.onValue.map((event) {
      final raw = event.snapshot.value;
      if (raw == null) return {};
      return Map<String, dynamic>.from(raw as Map);
    });
  }

  /// CONTROLLER
  Stream<Map<String, dynamic>> watchDeviceController(String deviceId) {
    final ref = _db.ref('sensors/$deviceId/controller');

    return ref.onValue.map((event) {
      final raw = event.snapshot.value;
      if (raw == null) return {};
      return Map<String, dynamic>.from(raw as Map);
    });
  }


  Future<void> setMotorManual({
    required String deviceId,
    required bool on,
  }) async {
    await _controllerRef(deviceId).update({
      'auto': 0,
      'motor_state': on ? 1 : 0,
    });
  }

  Future<void> setAuto({
    required String deviceId,
    required bool auto,
  }) async {
    await _controllerRef(deviceId).update({
      'auto': auto ? 1 : 0,
    });
  }

  Future<void> setHumidityRange({
    required String deviceId,
    required int minHum,
    required int maxHum,
  }) async {
    await _controllerRef(deviceId).update({
      'min_hum': minHum,
      'max_hum': maxHum,
    });
  }

  Future<void> setScheduleTime({
    required String deviceId,
    required String time,
  }) async {
    await _controllerRef(deviceId).update({
      'motor_time_start': time,
    });
  }

  DatabaseReference _controllerRef(String deviceId) =>
      _db.ref('sensors/$deviceId/controller');
}
