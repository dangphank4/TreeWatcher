import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../account/data/repositories/account_repository.dart';
import '../blocs/device_bloc.dart';
import '../blocs/device_event.dart';
import '../blocs/device_state.dart';

class AddDevicePage extends StatefulWidget {
  const AddDevicePage({super.key});

  @override
  State<AddDevicePage> createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> {
  String? userId;
  bool loadingUser = true;

  final idCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool showQrScanner = false;
  bool _waitingRename = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final accountRepo = Modular.get<AccountRepository>();
    final user = await accountRepo.getCurrentUser();

    setState(() {
      userId = user?.userId;
      loadingUser = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loadingUser) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (userId == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_off, size: 80, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              const Text(
                'Bạn chưa đăng nhập',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Thêm thiết bị mới"),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocConsumer<DeviceBloc, DeviceState>(
        listener: (context, state) async {
          if (state is DeviceSuccess && !_waitingRename) {
            _waitingRename = true;

            final deviceId = idCtrl.text.trim();
            final newName = await _showRenameDialog(context);

            if (!mounted) return;

            if (newName != null && newName.isNotEmpty) {
              ModularWatchExtension(context).read<DeviceBloc>().add(
                RenameDevice(
                  userId: userId!,
                  deviceId: deviceId,
                  newName: newName,
                ),
              );
            } else {
              _waitingRename = false;
              _showSuccessSnackBar('Thêm thiết bị thành công! 🎉');
              Navigator.pop(context, true);
            }
          }

          if (state is DeviceLoaded && _waitingRename) {
            _waitingRename = false;
            _showSuccessSnackBar('Thêm thiết bị thành công! 🎉');
            Navigator.pop(context, true);
          }

          if (state is DeviceFailure) {
            _waitingRename = false;
            _showErrorSnackBar(state.error);
          }
        },
        builder: (context, state) {
          final loading = state is DeviceLoading;

          return SingleChildScrollView(
            child: Column(
              children: [
                // ===== HEADER =====
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.sensors,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Kết nối thiết bị IoT',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        showQrScanner
                            ? 'Quét mã QR trên thiết bị'
                            : 'Nhập thông tin thiết bị để kết nối',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // ===== CONTENT =====
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      OutlinedButton.icon(
                        onPressed: loading
                            ? null
                            : () {
                          setState(
                                  () => showQrScanner = !showQrScanner);
                        },
                        icon: Icon(showQrScanner
                            ? Icons.keyboard
                            : Icons.qr_code_scanner),
                        label: Text(showQrScanner
                            ? 'Nhập thủ công'
                            : 'Quét mã QR'),
                      ),
                      const SizedBox(height: 24),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: showQrScanner
                            ? _buildQrScanner()
                            : _buildForm(loading, userId!),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildForm(bool loading, String userId) {
    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey('form'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildInputCard(
            title: 'Mã thiết bị',
            icon: Icons.sensors,
            child: TextFormField(
              controller: idCtrl,
              enabled: !loading,
              decoration: _inputDecoration('Ví dụ: device_001', Icons.tag),
              validator: (v) =>
              v == null || v.trim().isEmpty ? 'Nhập mã thiết bị' : null,
            ),
          ),
          const SizedBox(height: 16),
          _buildInputCard(
            title: 'Mật khẩu',
            icon: Icons.lock,
            child: TextFormField(
              controller: passCtrl,
              enabled: !loading,
              obscureText: true,
              decoration:
              _inputDecoration('Nhập mật khẩu thiết bị', Icons.key),
              validator: (v) =>
              v == null || v.trim().isEmpty ? 'Nhập mật khẩu' : null,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: loading ? null : () => _handleAddDevice(userId),
            child: loading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Thêm thiết bị'),
          ),
        ],
      ),
    );
  }

  Widget _buildQrScanner() {
    return Card(
      child: SizedBox(
        height: 350,
        child: MobileScanner(
          onDetect: (capture) {
            final raw = capture.barcodes.first.rawValue;
            if (raw == null) return;

            idCtrl.text = raw.trim();
            setState(() => showQrScanner = false);
          },
        ),
      ),
    );
  }

  void _handleAddDevice(String userId) {
    if (!_formKey.currentState!.validate()) return;

    ModularWatchExtension(context).read<DeviceBloc>().add(
      RegisterDevice(
        userId: userId,
        deviceId: idCtrl.text.trim(),
        deviceName: 'Thiết bị ${idCtrl.text.trim()}',
        password: passCtrl.text.trim(),
      ),
    );
  }

  Future<String?> _showRenameDialog(BuildContext context) {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Đặt tên thiết bị'),
        content: TextField(controller: ctrl),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Bỏ qua'),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(context, ctrl.text.trim().isEmpty ? null : ctrl.text.trim()),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(icon), const SizedBox(width: 8), Text(title)]),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    idCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }
}
