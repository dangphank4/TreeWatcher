import 'package:equatable/equatable.dart';

sealed class DeviceEvent extends Equatable {
  const DeviceEvent();

  @override
  List<Object?> get props => [];
}

final class DeviceCheckRequested extends DeviceEvent {
  final String sensorId;
  final String password;

  const DeviceCheckRequested({required this.sensorId, required this.password});

  @override
  List<Object?> get props => [sensorId, password];
}

final class DeviceAddRequested extends DeviceEvent {
  final String sensorId;
  final String deviceName;

  const DeviceAddRequested({required this.sensorId, required this.deviceName});

  @override
  List<Object?> get props => [sensorId, deviceName];
}