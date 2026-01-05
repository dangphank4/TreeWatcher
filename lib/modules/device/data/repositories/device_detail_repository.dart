import '../datasource/device_realtime_datasource.dart';
import '../datasource/device_log_datasource.dart';

class DeviceDetailRepository {
  final DeviceRealtimeDatasource realtimeDs;
  final DeviceLogDatasource logDs;

  DeviceDetailRepository(this.realtimeDs, this.logDs);

  //realtime
  Stream<Map<String, dynamic>> watchDeviceView(String deviceId) {
    return realtimeDs.watchDeviceView(deviceId);
  }

  Stream<Map<String, dynamic>> watchDeviceController(String deviceId) {
    return realtimeDs.watchDeviceController(deviceId);
  }

  Future<void> setMotorManual({
    required String deviceId,
    required bool on,
  }) {
    return realtimeDs.setMotorManual(
      deviceId: deviceId,
      on: on,
    );
  }

  Future<void> setAuto({
    required String deviceId,
    required bool auto,
  }) {
    return realtimeDs.setAuto(
      deviceId: deviceId,
      auto: auto,
    );
  }

  Future<void> setHumidityRange({
    required String deviceId,
    required int minHum,
    required int maxHum,
  }) {
    return realtimeDs.setHumidityRange(
      deviceId: deviceId,
      minHum: minHum,
      maxHum: maxHum,
    );
  }

  Future<void> setScheduleTime({
    required String deviceId,
    required String time,
  }) {
    return realtimeDs.setScheduleTime(
      deviceId: deviceId,
      time: time,
    );
  }

  //fiestore
  Future<List<Map<String, dynamic>>> getDeviceLogs({
    required String deviceId,
    required DateTime from,
    required DateTime to,
  }) async {
    final list = await logDs.getLogs(
      deviceId: deviceId,
      from: from,
      to: to,
    );

    print("=== Logs from $deviceId ===");
    for (final log in list) {
      print(log);
    }
    print("=== Total: ${list.length} logs ===");

    return list;
  }

}
