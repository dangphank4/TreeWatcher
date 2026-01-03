import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/device_repository.dart';
import 'device_event.dart';
import 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  final DeviceRepository _repo;

  DeviceBloc(this._repo) : super(DeviceInitial()) {
    on<LoadDevices>(_onLoadDevices);
    on<RegisterDevice>(_onRegisterDevice);
    on<RenameDevice>(_onRenameDevice);
    on<DeleteDevice>(_onDeleteDevice);
    on<ChangeDevicePassword>(_onChangeDevicePassword);
  }

  Future<void> _onLoadDevices(
      LoadDevices event,
      Emitter<DeviceState> emit,
      ) async {
    emit(DeviceLoading());

    final result = await _repo.getDevices(event.userId);

    if (result.isSuccess) {
      emit(DeviceLoaded(result.data!));
    } else {
      emit(DeviceFailure(result.error!));
    }
  }

  Future<void> _onRegisterDevice(
      RegisterDevice event,
      Emitter<DeviceState> emit,
      ) async {
    emit(DeviceLoading());

    final result = await _repo.registerDevice(
      userId: event.userId,
      deviceId: event.deviceId,
      deviceName: event.deviceName,
      password: event.password,
    );

    if (result.isSuccess) {
      emit(const DeviceSuccess('Thêm thiết bị thành công'));
      // reload list
      add(LoadDevices(event.userId));
    } else {
      emit(DeviceFailure(result.error!));
      print(result.error);
    }
  }

  Future<void> _onRenameDevice(
      RenameDevice event,
      Emitter<DeviceState> emit,
      ) async {
    emit(DeviceLoading());

    final result = await _repo.renameDevice(
      userId: event.userId,
      deviceId: event.deviceId,
      newName: event.newName,
    );

    if (result.isSuccess) {
      emit(const DeviceSuccess('Đổi tên thiết bị thành công'));
      add(LoadDevices(event.userId));
    } else {
      emit(DeviceFailure(result.error!));
    }
  }

  Future<void> _onDeleteDevice(
      DeleteDevice event,
      Emitter<DeviceState> emit,
      ) async {
    emit(DeviceLoading());

    final result = await _repo.deleteDevice(
      userId: event.userId,
      deviceId: event.deviceId,
    );

    if (result.isSuccess) {
      emit(const DeviceSuccess('Xoá thiết bị thành công'));
      add(LoadDevices(event.userId));
    } else {
      emit(DeviceFailure(result.error!));
    }
  }

  Future<void> _onChangeDevicePassword(
      ChangeDevicePassword event,
      Emitter<DeviceState> emit,
      ) async {
    emit(DeviceLoading());

    final result = await _repo.changeDevicePassword(
      deviceId: event.deviceId,
      oldPassword: event.oldPassword,
      newPassword: event.newPassword,
    );

    if (result.isSuccess) {
      emit(const DeviceSuccess('Đổi mật khẩu thiết bị thành công'));
    } else {
      emit(DeviceFailure(result.error!));
    }
  }
}
