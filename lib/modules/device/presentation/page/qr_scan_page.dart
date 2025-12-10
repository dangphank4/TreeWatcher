import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../blocs/device_bloc.dart';
import '../blocs/device_event.dart';

class QrScanPage extends StatelessWidget {
  const QrScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quét QR thiết bị")),
      body: MobileScanner(
        onDetect: (capture) {
          final barcode = capture.barcodes.first;
          final raw = barcode.rawValue;
          if (raw == null) return;

          final parts = raw.split("|");

          /// Kiểm tra QR phải có đúng 2 phần: id | pass
          if (parts.length != 2) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("QR không đúng định dạng: id|pass")),
            );
            return;
          }

          final sensorId = parts[0].trim();
          final password = parts[1].trim();

          /// Step 1: Gửi CHECK DEVICE → DeviceBloc
          context.read<DeviceBloc>().add(
            DeviceCheckRequested(
              sensorId: sensorId,
              password: password,
            ),
          );

          Navigator.pop(context);
        },
      ),
    );
  }
}
