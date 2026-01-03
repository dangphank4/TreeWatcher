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
          final raw = capture.barcodes.first.rawValue;
          if (raw == null) return;

          Navigator.pop(context, raw.trim());
        },
      ),
    );
  }
}

