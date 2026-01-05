import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/device_detail_repository.dart';

/// =======================
/// EVENTS
/// =======================

abstract class DeviceDetailEvent {}

class WatchDevice extends DeviceDetailEvent {
  final String deviceId;
  WatchDevice(this.deviceId);
}

class LoadDeviceLogs extends DeviceDetailEvent {
  final String deviceId;
  final DateTime from;
  final DateTime to;

  LoadDeviceLogs({
    required this.deviceId,
    required this.from,
    required this.to,
  });
}

/// =======================
/// STATE
/// =======================

class DeviceDetailState {
  final Map<String, dynamic>? sensor;
  final Map<String, dynamic>? controller;
  final List<Map<String, dynamic>> logs;
  final bool loading;
  final String? error;

  const DeviceDetailState({
    this.sensor,
    this.controller,
    this.logs = const [],
    this.loading = false,
    this.error,
  });

  DeviceDetailState copyWith({
    Map<String, dynamic>? sensor,
    Map<String, dynamic>? controller,
    List<Map<String, dynamic>>? logs,
    bool? loading,
    String? error,
  }) {
    return DeviceDetailState(
      sensor: sensor ?? this.sensor,
      controller: controller ?? this.controller,
      logs: logs ?? this.logs,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}

/// =======================
/// BLOC
/// =======================

class DeviceDetailBloc extends Bloc<DeviceDetailEvent, DeviceDetailState> {
  final DeviceDetailRepository repo;

  DeviceDetailBloc(this.repo) : super(const DeviceDetailState()) {
    on<WatchDevice>(_onWatchDevice);
    on<LoadDeviceLogs>(_onLoadLogs);
  }

  Future<void> _onWatchDevice(
      WatchDevice event,
      Emitter<DeviceDetailState> emit,
      ) async {
    emit(state.copyWith(loading: true));

    emit.forEach<Map<String, dynamic>>(
      repo.watchDeviceView(event.deviceId),
      onData: (sensor) {
        return state.copyWith(
          sensor: sensor,
          loading: false,
          error: null,
        );
      },
      onError: (e, _) {
        return state.copyWith(
          loading: false,
          error: e.toString(),
        );
      },
    );

    emit.forEach<Map<String, dynamic>>(
      repo.watchDeviceController(event.deviceId),
      onData: (controller) {
        return state.copyWith(
          controller: controller,
          error: null,
        );
      },
      onError: (e, _) {
        return state.copyWith(
          error: e.toString(),
        );
      },
    );
  }

  Future<void> _onLoadLogs(
      LoadDeviceLogs event,
      Emitter<DeviceDetailState> emit,
      ) async {
    emit(state.copyWith(loading: true));

    try {
      final logs = await repo.getDeviceLogs(
        deviceId: event.deviceId,
        from: event.from,
        to: event.to,
      );

      emit(state.copyWith(
        logs: logs,
        loading: false,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        loading: false,
        error: e.toString(),
      ));
    }
  }
}
