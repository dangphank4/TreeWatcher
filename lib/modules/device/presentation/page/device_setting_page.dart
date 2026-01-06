import 'package:flutter/material.dart';
import 'package:flutter_api/core/components/confirm_dialog.dart';
import 'package:flutter_api/core/constants/app_styles.dart';
import 'package:flutter_api/core/extensions/localized_extendsion.dart';
import 'package:flutter_api/core/extensions/num_extendsion.dart';
import 'package:flutter_api/core/helpers/navigation_helper.dart';
import 'package:flutter_api/core/utils/utils.dart';
import 'package:flutter_api/modules/device/presentation/blocs/device_bloc.dart';
import 'package:flutter_api/modules/device/presentation/blocs/device_event.dart';
import 'package:flutter_api/modules/device/presentation/blocs/device_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DeviceSettingPage extends StatefulWidget {
  const DeviceSettingPage({super.key});

  @override
  State<DeviceSettingPage> createState() => _DeviceSettingPageState();
}

class _DeviceSettingPageState extends State<DeviceSettingPage> {
  late final DeviceBloc _deviceBloc;

  final _nameController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  late final String deviceId;
  late final String deviceName;
  late final String userId;

  bool _expandPassword = false;

  @override
  void initState() {
    super.initState();
    final args = Modular.args.data as Map<String, dynamic>;

    deviceId = args['deviceId'];
    deviceName = args['deviceName'];
    userId = args['userId'];

    _deviceBloc = Modular.get<DeviceBloc>();
    _nameController.text = deviceName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF000D00), // dark navy
      appBar: AppBar(
        backgroundColor: Color(0xFF001600),
        elevation: 0,
        title: Text(
          context.localization.deviceSettingsTitle,
          style: Styles.h5.smb.copyWith(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: BlocListener<DeviceBloc, DeviceState>(
        bloc: _deviceBloc,
        listener: (context, state) {
          if (state is DeviceSuccess) {
            Utils.debugLog(state.message);
            if (state.message.toLowerCase().contains('xóa')) {
              Navigator.pop(context);
            }
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _headerCard(),
            24.verticalSpace,
            _renameCard(),
            16.verticalSpace,
            _passwordCard(),
            24.verticalSpace,
            _saveButton(),
            32.verticalSpace,
            _dangerZone(),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _headerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: Color(0xFF22C55E),
            child: Icon(Icons.devices, color: Colors.black),
          ),
          16.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(deviceName,
                    style: Styles.large.smb.copyWith(color: Colors.white)),
                4.verticalSpace,
                Text(
                  context.localization.deviceIdLabel(deviceId),
                  style: Styles.small.regular
                      .copyWith(color: Colors.white60),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= RENAME =================
  Widget _renameCard() {
    return _settingCard(
      icon: Icons.edit,
      title: context.localization.deviceRenameTitle,
      child: _darkInput(
        controller: _nameController,
        hint: context.localization.deviceRenameHint,
      ),
    );
  }

  // ================= PASSWORD =================
  Widget _passwordCard() {
    return _settingCard(
      icon: Icons.lock_outline,
      title: context.localization.deviceSettingsTitle,
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        iconColor: Colors.white70,
        collapsedIconColor: Colors.white38,
        onExpansionChanged: (v) => setState(() => _expandPassword = v),
        title: Text(
          context.localization.deviceChangePassword,
          style: Styles.medium.smb.copyWith(color: Colors.white),
        ),
        children: [
          12.verticalSpace,
          _darkInput(
            controller: _oldPasswordController,
            label: context.localization.deviceOldPassword,
            obscure: true,
          ),
          12.verticalSpace,
          _darkInput(
            controller: _newPasswordController,
            label: context.localization.deviceNewPassword,
            obscure: true,
          ),
        ],
      ),
    );
  }

  // ================= SAVE =================
  Widget _saveButton() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [Color(0xFF22C55E), Color(0xFF4ADE80)],
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: _onSavePressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.save, color: Colors.black),
            SizedBox(width: 8),
            Text(
              'Lưu thay đổi',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  // ================= DELETE =================
  Widget _dangerZone() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              SizedBox(width: 8),
              Text(
                'Vùng nguy hiểm',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          12.verticalSpace,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.delete),
              label: const Text('Xóa thiết bị'),
              onPressed: _onDeletePressed,
            ),
          ),
        ],
      ),
    );
  }

  // ================= COMMON =================
  Widget _settingCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF22C55E)),
              8.horizontalSpace,
              Text(
                title,
                style: Styles.medium.smb.copyWith(color: Colors.white),
              ),
            ],
          ),
          12.verticalSpace,
          child,
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: const Color(0xFF002200),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        blurRadius: 20,
        offset: const Offset(0, 10),
        color: Colors.black.withValues(alpha: 0.35),
      ),
    ],
  );

  Widget _darkInput({
    required TextEditingController controller,
    String? hint,
    String? label,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white60),
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: const Color(0xFF020617),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // ================= LOGIC =================
  Future<void> _onSavePressed() async {
    final newName = _nameController.text.trim();
    final oldPass = _oldPasswordController.text.trim();
    final newPass = _newPasswordController.text.trim();

    bool willRename = newName.isNotEmpty && newName != deviceName;
    bool willChangePassword = _expandPassword &&
        oldPass.isNotEmpty &&
        newPass.isNotEmpty &&
        newPass.length >= 6 &&
        oldPass != newPass;

    if (!willRename && !willChangePassword) {
      _showSnack(
        context.localization.noChanges,
      );
      return;
    }

    // ✅ Hỏi xác nhận
    final confirm = await showConfirmDialog(
      context: context,
      title: context.localization.saveChanges,
      content: context.localization.confirmSaveChanges(deviceName),
    );

    if (confirm != true) return;

    // ===== THỰC HIỆN THAY ĐỔI =====
    if (willRename) {
      _deviceBloc.add(
        RenameDevice(
          deviceId: deviceId,
          newName: newName,
          userId: userId,
        ),
      );
    }

    if (willChangePassword) {
      _deviceBloc.add(
        ChangeDevicePassword(
          deviceId: deviceId,
          oldPassword: oldPass,
          newPassword: newPass,
        ),
      );

      _oldPasswordController.clear();
      _newPasswordController.clear();
    }
    NavigationHelper.goBack();
  }


  Future<void> _onDeletePressed() async {
    final confirm = await showConfirmDialog(
      context: context,
      title: 'Xóa thiết bị',
      content: 'Bạn có chắc chắn muốn xóa thiết bị này?',
    );

    if (confirm == true) {
      _deviceBloc.add(DeleteDevice(
        userId: userId,
        deviceId: deviceId,
      ));
    }
    NavigationHelper.goBack();
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
      ),
    );
  }

}
