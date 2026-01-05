import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceLogDatasource {
  final FirebaseFirestore _fs = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getLogs({
    required String deviceId,
    required DateTime from,
    required DateTime to,
  }) async {
    final query = await _fs
        .collection('log')
        .doc(deviceId)
        .collection('view')
        .where('logged_at', isGreaterThanOrEqualTo: from)
        .where('logged_at', isLessThanOrEqualTo: to)
        .orderBy('logged_at')
        .get();

    return query.docs.map((d) => d.data()).toList();
  }
}
