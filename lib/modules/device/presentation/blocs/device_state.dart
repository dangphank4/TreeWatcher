import 'package:equatable/equatable.dart';

sealed class DeviceState extends Equatable {
  const DeviceState();

  @override
  List<Object?> get props => [];
}

final class DeviceInitial extends DeviceState {}

final class DeviceLoading extends DeviceState {}

final class DeviceCheckSuccess extends DeviceState {
  final String sensorId;

  const DeviceCheckSuccess({required this.sensorId});

  @override
  List<Object?> get props => [sensorId];
}

final class DeviceSuccess extends DeviceState {
  final String deviceName;

  const DeviceSuccess({required this.deviceName});

  @override
  List<Object?> get props => [deviceName];
}

final class DeviceFailure extends DeviceState {
  final String message;

  const DeviceFailure(this.message);

  @override
  List<Object?> get props => [message];
}