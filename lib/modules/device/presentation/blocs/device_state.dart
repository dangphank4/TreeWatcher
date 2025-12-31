import 'package:equatable/equatable.dart';

final class DeviceState extends Equatable {
  final bool isLoading;
  final String? sensorId;
  final String? deviceName;
  final String? errorMessage;

  const DeviceState._({
    this.isLoading = false,
    this.sensorId,
    this.deviceName,
    this.errorMessage,
  });

  const DeviceState.initial() : this._();

  DeviceState setState({
    bool? isLoading,
    String? sensorId,
    String? deviceName,
    String? errorMessage,
  }) {
    return DeviceState._(
      isLoading: isLoading ?? this.isLoading,
      sensorId: sensorId ?? this.sensorId,
      deviceName: deviceName ?? this.deviceName,
      errorMessage: errorMessage,
    );
  }

  DeviceState reset() {
    return const DeviceState.initial();
  }

  factory DeviceState.fromJson(Map<String, dynamic> json) {
    return DeviceState._(
      isLoading: json['isLoading'] ?? false,
      sensorId: json['sensorId'],
      deviceName: json['deviceName'],
      errorMessage: json['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() => {
    'isLoading': isLoading,
    'sensorId': sensorId,
    'deviceName': deviceName,
    'errorMessage': errorMessage,
  };

  @override
  List<Object?> get props => [
    isLoading,
    sensorId,
    deviceName,
    errorMessage,
  ];
}
