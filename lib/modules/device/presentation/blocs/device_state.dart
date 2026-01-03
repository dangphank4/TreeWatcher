import 'package:equatable/equatable.dart';

abstract class DeviceState extends Equatable {
  const DeviceState();

  @override
  List<Object?> get props => [];
}

class DeviceInitial extends DeviceState {}

class DeviceLoading extends DeviceState {}

class DeviceLoaded extends DeviceState {
  final List<Map<String, dynamic>> devices;

  const DeviceLoaded(this.devices);

  @override
  List<Object?> get props => [devices];
}

class DeviceSuccess extends DeviceState {
  final String message;

  const DeviceSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class DeviceFailure extends DeviceState {
  final String error;

  const DeviceFailure(this.error);

  @override
  List<Object?> get props => [error];
}
