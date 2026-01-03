import 'package:equatable/equatable.dart';

abstract class DeviceEvent extends Equatable {
  const DeviceEvent();

  @override
  List<Object?> get props => [];
}

/// Load danh sách thiết bị
class LoadDevices extends DeviceEvent {
  final String userId;
  const LoadDevices(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// Đăng ký / thêm thiết bị
class RegisterDevice extends DeviceEvent {
  final String userId;
  final String deviceId;
  final String deviceName;
  final String password;

  const RegisterDevice({
    required this.userId,
    required this.deviceId,
    required this.deviceName,
    required this.password,
  });

  @override
  List<Object?> get props => [userId, deviceId, deviceName];
}

/// Đổi tên thiết bị
class RenameDevice extends DeviceEvent {
  final String userId;
  final String deviceId;
  final String newName;

  const RenameDevice({
    required this.userId,
    required this.deviceId,
    required this.newName,
  });

  @override
  List<Object?> get props => [userId, deviceId, newName];
}

/// Xoá thiết bị
class DeleteDevice extends DeviceEvent {
  final String userId;
  final String deviceId;

  const DeleteDevice({
    required this.userId,
    required this.deviceId,
  });

  @override
  List<Object?> get props => [userId, deviceId];
}
