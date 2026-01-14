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

class SetMotorTimeout extends DeviceDetailEvent {
  final String deviceId;
  final int timeoutSeconds;

  SetMotorTimeout({
    required this.deviceId,
    required this.timeoutSeconds,
  });
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

// === NEW CONTROL EVENTS ===

class SetMotorManual extends DeviceDetailEvent {
  final String deviceId;
  final bool on;

  SetMotorManual({
    required this.deviceId,
    required this.on,
  });
}

class SetAutoMode extends DeviceDetailEvent {
  final String deviceId;
  final bool auto;

  SetAutoMode({
    required this.deviceId,
    required this.auto,
  });
}

class SetHumidityRange extends DeviceDetailEvent {
  final String deviceId;
  final int minHum;
  final int maxHum;

  SetHumidityRange({
    required this.deviceId,
    required this.minHum,
    required this.maxHum,
  });
}

class SetScheduleTime extends DeviceDetailEvent {
  final String deviceId;
  final String time;

  SetScheduleTime({
    required this.deviceId,
    required this.time,
  });
}


class DeviceDetailState {
  final Map<String, dynamic>? sensor;
  final Map<String, dynamic>? controller;
  final List<Map<String, dynamic>> logs;
  final bool loading;
  final bool? isOnline;
  final int? lastSeen;
  final bool controlLoading; // Loading riêng cho control actions
  final String? error;
  final String? controlError; // Error riêng cho control actions
  final String? successMessage; // Thông báo thành công

  const DeviceDetailState({
    this.sensor,
    this.controller,
    this.logs = const [],
    this.loading = false,
    this.controlLoading = false,
    this.isOnline,
    this.lastSeen,
    this.error,
    this.controlError,
    this.successMessage,
  });

  DeviceDetailState copyWith({
    Map<String, dynamic>? sensor,
    Map<String, dynamic>? controller,
    List<Map<String, dynamic>>? logs,
    bool? loading,
    bool? controlLoading,
    bool? isOnline,
    int? lastSeen,
    String? error,
    String? controlError,
    String? successMessage,
  }) {
    return DeviceDetailState(
      sensor: sensor ?? this.sensor,
      controller: controller ?? this.controller,
      logs: logs ?? this.logs,
      loading: loading ?? this.loading,
      controlLoading: controlLoading ?? this.controlLoading,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      error: error,
      controlError: controlError,
      successMessage: successMessage,
    );
  }

  // Helper để clear messages
  DeviceDetailState clearMessages() {
    return copyWith(
      error: null,
      controlError: null,
      successMessage: null,
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

    // Register new control events
    on<SetMotorManual>(_onSetMotorManual);
    on<SetAutoMode>(_onSetAutoMode);
    on<SetHumidityRange>(_onSetHumidityRange);
    on<SetScheduleTime>(_onSetScheduleTime);
    on<SetMotorTimeout>(_onSetMotorTimeout);
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

    emit.forEach<bool>(
      repo.watchDeviceOnline(event.deviceId),
      onData: (isOnline) {
        return state.copyWith(
          isOnline: isOnline,
        );
      },
      onError: (e, _) {
        return state.copyWith(
          isOnline: false,
        );
      },
    );

    // Fetch lastSeen ONCE (không stream)
    try {
      final lastSeen = await repo.getDeviceLastSeen(event.deviceId);
      emit(state.copyWith(lastSeen: lastSeen));
    } catch (_) {
    }
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

  // === NEW CONTROL HANDLERS ===

  Future<void> _onSetMotorManual(
      SetMotorManual event,
      Emitter<DeviceDetailState> emit,
      ) async {
    emit(state.copyWith(controlLoading: true, controlError: null));

    try {
      await repo.setMotorManual(
        deviceId: event.deviceId,
        on: event.on,
      );

      emit(state.copyWith(
        controlLoading: false,
        successMessage: 'Motor ${event.on ? "bật" : "tắt"} thành công',
      ));

      // Clear success message sau 3 giây
      await Future.delayed(const Duration(seconds: 3));
      emit(state.copyWith(successMessage: null));
    } catch (e) {
      emit(state.copyWith(
        controlLoading: false,
        controlError: 'Lỗi điều khiển motor: ${e.toString()}',
      ));
    }
  }

  Future<void> _onSetAutoMode(
      SetAutoMode event,
      Emitter<DeviceDetailState> emit,
      ) async {
    emit(state.copyWith(controlLoading: true, controlError: null));

    try {
      await repo.setAuto(
        deviceId: event.deviceId,
        auto: event.auto,
      );

      emit(state.copyWith(
        controlLoading: false,
        successMessage: 'Chế độ ${event.auto ? "tự động" : "thủ công"} đã được bật',
      ));

      await Future.delayed(const Duration(seconds: 3));
      emit(state.copyWith(successMessage: null));
    } catch (e) {
      emit(state.copyWith(
        controlLoading: false,
        controlError: 'Lỗi chuyển chế độ: ${e.toString()}',
      ));
    }
  }

  Future<void> _onSetHumidityRange(
      SetHumidityRange event,
      Emitter<DeviceDetailState> emit,
      ) async {
    // Validate
    if (event.minHum >= event.maxHum) {
      emit(state.copyWith(
        controlError: 'Độ ẩm tối thiểu phải nhỏ hơn độ ẩm tối đa',
      ));
      return;
    }

    emit(state.copyWith(controlLoading: true, controlError: null));

    try {
      await repo.setHumidityRange(
        deviceId: event.deviceId,
        minHum: event.minHum,
        maxHum: event.maxHum,
      );

      emit(state.copyWith(
        controlLoading: false,
        successMessage: 'Cập nhật ngưỡng độ ẩm thành công',
      ));

      await Future.delayed(const Duration(seconds: 3));
      emit(state.copyWith(successMessage: null));
    } catch (e) {
      emit(state.copyWith(
        controlLoading: false,
        controlError: 'Lỗi cập nhật độ ẩm: ${e.toString()}',
      ));
    }
  }

  Future<void> _onSetScheduleTime(
      SetScheduleTime event,
      Emitter<DeviceDetailState> emit,
      ) async {
    emit(state.copyWith(controlLoading: true, controlError: null));

    try {
      await repo.setScheduleTime(
        deviceId: event.deviceId,
        time: event.time,
      );

      emit(state.copyWith(
        controlLoading: false,
        successMessage: 'Cập nhật lịch tưới thành công',
      ));

      await Future.delayed(const Duration(seconds: 3));
      emit(state.copyWith(successMessage: null));
    } catch (e) {
      emit(state.copyWith(
        controlLoading: false,
        controlError: 'Lỗi cập nhật lịch: ${e.toString()}',
      ));
    }
  }

  Future<void> _onSetMotorTimeout(
      SetMotorTimeout event,
      Emitter<DeviceDetailState> emit,
      ) async {
    if (event.timeoutSeconds <= 0) {
      emit(state.copyWith(
        controlError: 'Thời gian timeout không hợp lệ',
      ));
      return;
    }

    if (event.timeoutSeconds < 1) {
      emit(state.copyWith(
        controlError: 'Thời gian bơm tối thiểu là 1 giây',
      ));
      return;
    }

    emit(state.copyWith(controlLoading: true, controlError: null));

    try {
      await repo.setMotorTimeout(
        deviceId: event.deviceId,
        timeoutSeconds: event.timeoutSeconds,
      );

      emit(state.copyWith(
        controlLoading: false,
        successMessage:
        'Đã cập nhật thời gian bơm (${event.timeoutSeconds}s)',
      ));

      await Future.delayed(const Duration(seconds: 3));
      emit(state.copyWith(successMessage: null));
    } catch (e) {
      emit(state.copyWith(
        controlLoading: false,
        controlError: 'Lỗi cập nhật timeout: $e',
      ));
    }
  }

}