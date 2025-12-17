import '../datasource/device_api.dart';

class DeviceRepository {
  final DeviceApi api;

  DeviceRepository({required this.api});

  Future<String> checkDevice({
    required String sensorId,
    required String password,
  }) async {
    final sensor = await api.getSensor(sensorId);
    if (sensor == null) return "ERROR:NOT_FOUND";

    if (sensor["password"] != password) return "ERROR:WRONG_PASSWORD";

    return "OK";
  }

  Future<void> addDevice({
    required String sensorId,
    required String name,
    required String userId,
  }) async {
    await api.assignOwner(userId: userId, sensorId: sensorId, name: name);
  }
}
