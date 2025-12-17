import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/globals.dart';
import '../../data/repositories/device_repository.dart';
import 'device_event.dart';
import 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  final DeviceRepository repo;

  DeviceBloc({required this.repo}) : super(DeviceInitial()) {
    on<DeviceCheckRequested>(_onCheckDevice);
    on<DeviceAddRequested>(_onAddDevice);
  }

  Future<void> _onCheckDevice(
      DeviceCheckRequested event,
      Emitter<DeviceState> emit,
      ) async {
    emit(DeviceLoading());

    final result = await repo.checkDevice(
      sensorId: event.sensorId,
      password: event.password,
    );

    switch (result) {
      case "OK":
        emit(DeviceCheckSuccess(sensorId: event.sensorId));
        break;

      case "ERROR:NOT_FOUND":
        emit(const DeviceFailure("Thiết bị không tồn tại"));
        break;

      case "ERROR:WRONG_PASSWORD":
        emit(const DeviceFailure("Sai mật khẩu thiết bị"));
        break;

      default:
        emit(const DeviceFailure("Lỗi không xác định"));
        break;
    }
  }

  Future<void> _onAddDevice(
      DeviceAddRequested event,
      Emitter<DeviceState> emit,
      ) async {
    emit(DeviceLoading());

    await repo.addDevice(
      sensorId: event.sensorId,
      name: event.deviceName,
      userId: Globals.globalUserUUID!,
    );

    emit(DeviceSuccess(deviceName: event.deviceName));
  }
}