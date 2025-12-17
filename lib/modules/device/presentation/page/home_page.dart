import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/helpers/navigation_helper.dart';
import '../../../device/general/device_module_routes.dart';
import '../../../../core/utils/globals.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Stream<Map?> _userDevicesStream(String userId) {
    final db = FirebaseDatabase.instance.ref();
    return db.child("users/$userId/devices").onValue.map(
          (event) => event.snapshot.value as Map?,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = Globals.globalUserUUID ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Thiết bị của tôi"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Modular.to.pushNamed('/device/add');
            },
          ),
        ],
      ),
      body: StreamBuilder<Map?>(
        stream: _userDevicesStream(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text("Không có thiết bị nào"));
          }

          final devices = snapshot.data!;
          if (devices.isEmpty) {
            return const Center(child: Text("Chưa thêm thiết bị nào"));
          }

          final sensorIds = devices.keys.toList();

          return ListView.builder(
            itemCount: sensorIds.length,
            itemBuilder: (context, index) {
              final sensorId = sensorIds[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text("Thiết bị: $sensorId"),
                  subtitle: const Text("Chạm để xem chi tiết"),
                  onTap: () {
                    Modular.to.pushNamed(
                      '${AppRoutes.moduleDevice}${DeviceModuleRoutes.detail}',
                      arguments: {"sensorId": sensorId},
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
