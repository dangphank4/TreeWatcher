import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanPage extends StatefulWidget {
  const QrScanPage({super.key});

  @override
  State<QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  bool _scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// ===== CAMERA =====
          MobileScanner(
            fit: BoxFit.cover,
            onDetect: (capture) {
              if (_scanned) return;

              final raw = capture.barcodes.first.rawValue;
              if (raw == null) return;

              _scanned = true;
              Navigator.pop(context, raw);
            },
          ),

          /// ===== DARK OVERLAY + CUTOUT =====
          _ScannerOverlay(),

          /// ===== TOP BAR =====
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close,
                        color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  const Text(
                    'Quét mã QR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),

          /// ===== GUIDE TEXT =====
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Text(
              'Đưa mã QR vào khung để quét',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScannerOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const double scanSize = 260;

    return Stack(
      children: [
        /// Dark overlay
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.55),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Center(
                child: Container(
                  width: scanSize,
                  height: scanSize,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),

        /// Corners
        Center(
          child: SizedBox(
            width: scanSize,
            height: scanSize,
            child: Stack(
              children: const [
                _Corner(top: 0, left: 0),
                _Corner(top: 0, right: 0),
                _Corner(bottom: 0, left: 0),
                _Corner(bottom: 0, right: 0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
class _Corner extends StatelessWidget {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  const _Corner({this.top, this.bottom, this.left, this.right});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border(
            top: top != null
                ? const BorderSide(color: Colors.green, width: 4)
                : BorderSide.none,
            bottom: bottom != null
                ? const BorderSide(color: Colors.green, width: 4)
                : BorderSide.none,
            left: left != null
                ? const BorderSide(color: Colors.green, width: 4)
                : BorderSide.none,
            right: right != null
                ? const BorderSide(color: Colors.green, width: 4)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}

