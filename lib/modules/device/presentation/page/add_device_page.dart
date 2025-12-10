import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/device_bloc.dart';
import '../blocs/device_event.dart';
import '../blocs/device_state.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AddDevicePage extends StatefulWidget {
  const AddDevicePage({super.key});

  @override
  State<AddDevicePage> createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> {
  final idCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController();

  bool showNameField = false;
  String lastSensorId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thêm thiết bị")),
      body: BlocConsumer<DeviceBloc, DeviceState>(
        listener: (context, state) {
          if (state is DeviceCheckSuccess) {
            setState(() {
              showNameField = true;
              lastSensorId = state.sensorId;
            });
          }

          if (state is DeviceSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Đã thêm thiết bị: ${state.deviceName}")),
            );
            Modular.to.pop();
          }

          if (state is DeviceFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: idCtrl,
                  decoration: const InputDecoration(labelText: "Sensor ID"),
                ),
                TextField(
                  controller: passCtrl,
                  decoration: const InputDecoration(labelText: "Mật khẩu thiết bị"),
                ),

                if (showNameField)
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: "Tên thiết bị"),
                  ),

                const SizedBox(height: 20),

                ElevatedButton(
                  child: Text(showNameField ? "Lưu thiết bị" : "Kiểm tra thiết bị"),
                  onPressed: () {
                    // Sử dụng context.read thay vì ModularWatchExtension
                    final bloc = Modular.get<DeviceBloc>();

                    if (!showNameField) {
                      bloc.add(
                        DeviceCheckRequested(
                          sensorId: idCtrl.text.trim(),
                          password: passCtrl.text.trim(),
                        ),
                      );
                    } else {
                      bloc.add(
                        DeviceAddRequested(
                          sensorId: lastSensorId,
                          deviceName: nameCtrl.text.trim(),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}