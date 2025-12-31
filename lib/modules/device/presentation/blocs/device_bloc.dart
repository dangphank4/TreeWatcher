import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/globals.dart';
import '../../data/repositories/device_repository.dart';
import 'device_event.dart';
import 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  final DeviceRepository repo;

  DeviceBloc({required this.repo}) : super(const DeviceState.initial()) {
    on<DeviceCheckRequested>(_onCheckDevice);
    on<DeviceAddRequested>(_onAddDevice);
  }

  Future<void> _onCheckDevice(
      DeviceCheckRequested event,
      Emitter<DeviceState> emit,
      ) async {
    // Loading
    emit(state.setState(
      isLoading: true,
      errorMessage: null,
    ));

    final result = await repo.checkDevice(
      sensorId: event.sensorId,
      password: event.password,
    );

    switch (result) {
      case "OK":
        emit(state.setState(
          isLoading: false,
          sensorId: event.sensorId,
          errorMessage: null,
        ));
        break;

      case "ERROR:NOT_FOUND":
        emit(state.setState(
          isLoading: false,
          errorMessage: "Thiết bị không tồn tại",
        ));
        break;

      case "ERROR:WRONG_PASSWORD":
        emit(state.setState(
          isLoading: false,
          errorMessage: "Sai mật khẩu thiết bị",
        ));
        break;

      default:
        emit(state.setState(
          isLoading: false,
          errorMessage: "Lỗi không xác định",
        ));
        break;
    }
  }

  Future<void> _onAddDevice(
      DeviceAddRequested event,
      Emitter<DeviceState> emit,
      ) async {
    emit(state.setState(
      isLoading: true,
      errorMessage: null,
    ));

    await repo.addDevice(
      sensorId: event.sensorId,
      name: event.deviceName,
      userId: Globals.globalUserUUID!,
    );

    emit(state.setState(
      isLoading: false,
      deviceName: event.deviceName,
      errorMessage: null,
    ));
  }
}
