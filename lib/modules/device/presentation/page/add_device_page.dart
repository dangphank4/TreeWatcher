import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../blocs/device_bloc.dart';
import '../blocs/device_event.dart';
import '../blocs/device_state.dart';

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
  bool showQrScanner = false;
  String lastSensorId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thêm thiết bị"),
        actions: [
          // ✅ Nút toggle QR scanner
          if (!showNameField)
            IconButton(
              icon: Icon(showQrScanner ? Icons.keyboard : Icons.qr_code_scanner),
              onPressed: () {
                setState(() {
                  showQrScanner = !showQrScanner;
                });
              },
              tooltip: showQrScanner ? "Nhập thủ công" : "Quét QR",
            ),
        ],
      ),
      body: BlocConsumer<DeviceBloc, DeviceState>(
        listener: (context, state) {
          if (state is DeviceCheckSuccess) {
            setState(() {
              showNameField = true;
              showQrScanner = false; // Tắt QR scanner khi thành công
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is DeviceLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ✅ QR Scanner hoặc Form nhập thủ công
                if (showQrScanner && !showNameField)
                  _buildQrScanner()
                else if (!showNameField)
                  _buildManualInputForm(isLoading)
                else
                  _buildNameInputForm(isLoading),

                const SizedBox(height: 20),

                // ✅ Nút hành động
                ElevatedButton(
                  onPressed: isLoading ? null : _handleButtonPress,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : Text(
                    showNameField ? "Lưu thiết bị" : "Kiểm tra thiết bị",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ✅ QR Scanner Widget
  Widget _buildQrScanner() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: MobileScanner(
          onDetect: (capture) {
            final barcode = capture.barcodes.first;
            final raw = barcode.rawValue;
            if (raw == null) return;

            final parts = raw.split("|");

            // ✅ Kiểm tra định dạng QR: id|password
            if (parts.length != 2) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("QR không đúng định dạng: id|password"),
                  backgroundColor: Colors.orange,
                ),
              );
              return;
            }

            final sensorId = parts[0].trim();
            final password = parts[1].trim();

            // ✅ Tự động điền vào form
            setState(() {
              idCtrl.text = sensorId;
              passCtrl.text = password;
              showQrScanner = false; // Tắt scanner
            });

            // ✅ Tự động kiểm tra thiết bị
            ModularWatchExtension(context).read<DeviceBloc>().add(
              DeviceCheckRequested(
                sensorId: sensorId,
                password: password,
              ),
            );
          },
        ),
      ),
    );
  }

  // ✅ Form nhập thủ công
  Widget _buildManualInputForm(bool isLoading) {
    return Column(
      children: [
        const Text(
          "Nhập thông tin thiết bị",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: idCtrl,
          decoration: const InputDecoration(
            labelText: "Sensor ID",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.sensors),
          ),
          enabled: !isLoading,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: passCtrl,
          decoration: const InputDecoration(
            labelText: "Mật khẩu thiết bị",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.lock),
          ),
          obscureText: true,
          enabled: !isLoading,
        ),
      ],
    );
  }

  // ✅ Form nhập tên thiết bị (sau khi kiểm tra thành công)
  Widget _buildNameInputForm(bool isLoading) {
    return Column(
      children: [
        const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 64,
        ),
        const SizedBox(height: 16),
        const Text(
          "Thiết bị hợp lệ!",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "ID: $lastSensorId",
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(
            labelText: "Đặt tên cho thiết bị",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.edit),
            hintText: "Ví dụ: Cảm biến phòng khách",
          ),
          enabled: !isLoading,
          autofocus: true,
        ),
      ],
    );
  }

  // ✅ Xử lý khi ấn nút
  void _handleButtonPress() {
    final bloc = ModularWatchExtension(context).read<DeviceBloc>();

    if (!showNameField) {
      // Bước 1: Kiểm tra thiết bị
      final sensorId = idCtrl.text.trim();
      final password = passCtrl.text.trim();

      if (sensorId.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Vui lòng nhập đầy đủ thông tin"),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      bloc.add(
        DeviceCheckRequested(
          sensorId: sensorId,
          password: password,
        ),
      );
    } else {
      // Bước 2: Lưu thiết bị
      final deviceName = nameCtrl.text.trim();

      if (deviceName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Vui lòng nhập tên thiết bị"),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      bloc.add(
        DeviceAddRequested(
          sensorId: lastSensorId,
          deviceName: deviceName,
        ),
      );
    }
  }

  @override
  void dispose() {
    idCtrl.dispose();
    passCtrl.dispose();
    nameCtrl.dispose();
    super.dispose();
  }
}