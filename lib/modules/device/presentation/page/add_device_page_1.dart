import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api/core/constants/app_dimensions.dart';
import 'package:flutter_api/core/constants/app_styles.dart';
import 'package:flutter_api/core/extensions/localized_extendsion.dart';
import 'package:flutter_api/core/extensions/num_extendsion.dart';
import 'package:flutter_api/core/utils/utils.dart';

class AddDevicePage extends StatefulWidget {
  const AddDevicePage({super.key});

  @override
  State<AddDevicePage> createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> {
  final TextEditingController _deviceCodeController = TextEditingController();
  final TextEditingController _devicePassController = TextEditingController();
  final TextEditingController _deviceNameController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _deviceCodeController.dispose();
    _deviceNameController.dispose();
    _devicePassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.localization.addNewDevice,
          style: Styles.h3.smb.copyWith(color: Colors.white70),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.green.withValues(alpha: 0.1),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLine(),
              20.verticalSpace,
              Text(
                context.localization.scanQr,
                style: Styles.h1.smb.copyWith(color: Colors.white),
              ),
              8.verticalSpace,
              SizedBox(
                width: 300,
                child: Text(
                  context.localization.scanQrDesc,
                  style: Styles.medium.smb.copyWith(color: Colors.white70),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
              20.verticalSpace,
              _buildQrScanner(),
              20.verticalSpace,
              _buildLine(content: context.localization.manualInput),
              20.verticalSpace,
              Row(
                children: [
                  ClipOval(
                    child: Container(
                      width: 25,
                      height: 25,
                      alignment: Alignment.center,
                      color: Colors.white30,
                      child: Text(
                        '1',
                        style: Styles.medium.smb.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  8.horizontalSpace,
                  Text(
                    context.localization.deviceId,
                    style: Styles.medium.smb.copyWith(color: Colors.white),
                  ),
                ],
              ),
              8.verticalSpace,
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white12,
                  border: Border.all(width: 0.5, color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    10.horizontalSpace,
                    Icon(Icons.qr_code_2, size: 30),
                    10.horizontalSpace,
                    Expanded(
                      child: TextField(
                        controller: _deviceCodeController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'XXXX-XXXX',
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                          //isDense: true,
                        ),
                      ),
                    ),
                    10.horizontalSpace,
                    TextButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        final code = _deviceCodeController.text.trim();

                        if (code.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Vui lòng nhập hoặc quét mã thiết bị',
                              ),
                            ),
                          );
                          return;
                        }

                        Utils.debugLog('Device code: $code');
                      },
                      child: Text(
                        context.localization.scan,
                        style: Styles.large.smb.copyWith(color: Colors.green),
                      ),
                    ),
                    10.horizontalSpace,
                  ],
                ),
              ),
              20.verticalSpace,
              Row(
                children: [
                  ClipOval(
                    child: Container(
                      width: 25,
                      height: 25,
                      alignment: Alignment.center,
                      color: Colors.white30,
                      child: Text(
                        '2',
                        style: Styles.medium.smb.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  8.horizontalSpace,
                  Text(
                    context.localization.password,
                    style: Styles.medium.smb.copyWith(color: Colors.white),
                  ),
                ],
              ),
              8.verticalSpace,
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white12,
                  border: Border.all(width: 0.5, color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    10.horizontalSpace,
                    const Icon(
                      Icons.lock_outline,
                      size: 26,
                      color: Colors.white,
                    ),
                    10.horizontalSpace,

                    Expanded(
                      child: TextField(
                        controller: _devicePassController,
                        obscureText: _obscurePassword,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: '********',
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white70,
                      ),
                    ),

                    4.horizontalSpace,
                  ],
                ),
              ),
              20.verticalSpace,
              Row(
                children: [
                  ClipOval(
                    child: Container(
                      width: 25,
                      height: 25,
                      alignment: Alignment.center,
                      color: Colors.white30,
                      child: Text(
                        '3',
                        style: Styles.medium.smb.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  8.horizontalSpace,
                  Text(
                    context.localization.deviceName,
                    style: Styles.medium.smb.copyWith(color: Colors.white),
                  ),
                ],
              ),
              8.verticalSpace,
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white12,
                  border: Border.all(width: 0.5, color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    10.horizontalSpace,
                    Icon(Icons.notes_outlined, size: 30),
                    10.horizontalSpace,
                    Expanded(
                      child: TextField(
                        controller: _deviceNameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'VD: Cây rau má',
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                          //isDense: true,
                        ),
                      ),
                    ),

                    10.horizontalSpace,
                  ],
                ),
              ),
              40.verticalSpace,
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Utils.debugLog('Pressed');
                },
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 1, color: Colors.green),
                    gradient: LinearGradient(
                      colors: [Colors.green, Colors.white],
                      stops: [0.4, 0.8],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      10.horizontalSpace,
                      Text(
                        context.localization.connectDevice,
                        style: Styles.large.smb.copyWith(color: Colors.black),
                      ),
                      10.horizontalSpace,
                      Icon(Icons.arrow_forward, color: Colors.red.shade200),
                    ],
                  ),
                ),
              ),
              AppDimensions.paddingNavBar.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildQrScanner() {
  return Stack(
    children: [
      InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Utils.debugLog('Pressed');
        },
        child: Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white30,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.greenAccent),
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.camera_alt_outlined,
            size: 140,
            color: Colors.white,
          ),
        ),
      ),

      // Top left
      _buildCorner(top: 40, left: 40, isTop: true, isLeft: true),

      // Top right
      _buildCorner(top: 40, right: 40, isTop: true, isRight: true),

      // Bottom left
      _buildCorner(bottom: 40, left: 40, isBottom: true, isLeft: true),

      // Bottom right
      _buildCorner(bottom: 40, right: 40, isBottom: true, isRight: true),
    ],
  );
}

Widget _buildCorner({
  double? top,
  double? bottom,
  double? left,
  double? right,
  bool isTop = false,
  bool isBottom = false,
  bool isLeft = false,
  bool isRight = false,
}) {
  return Positioned(
    top: top,
    bottom: bottom,
    left: left,
    right: right,
    child: Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? const BorderSide(color: Colors.green, width: 4)
              : BorderSide.none,
          bottom: isBottom
              ? const BorderSide(color: Colors.green, width: 4)
              : BorderSide.none,
          left: isLeft
              ? const BorderSide(color: Colors.green, width: 4)
              : BorderSide.none,
          right: isRight
              ? const BorderSide(color: Colors.green, width: 4)
              : BorderSide.none,
        ),
      ),
    ),
  );
}

Widget _buildLine({String? content}) {
  if (content == null) {
    return Container(width: double.infinity, height: 1, color: Colors.white24);
  }

  return Row(
    children: [
      const Expanded(child: Divider(color: Colors.white24, thickness: 1)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          content,
          style: Styles.large.regular.copyWith(color: Colors.white70),
        ),
      ),
      const Expanded(child: Divider(color: Colors.white24, thickness: 1)),
    ],
  );
}
