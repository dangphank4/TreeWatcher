import 'package:flutter_api/modules/device/presentation/blocs/device_detail_bloc.dart';
import 'package:flutter_api/modules/device/presentation/page/add_device_page.dart';
import 'package:flutter_api/modules/device/presentation/page/detail_device_page.dart';
import 'package:flutter_api/modules/device/presentation/page/device_control_page.dart';
import 'package:flutter_api/modules/device/presentation/page/device_setting_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/datasource/device_api.dart';
import 'data/datasource/device_realtime_datasource.dart';
import 'data/datasource/device_log_datasource.dart';
import 'data/repositories/device_detail_repository.dart';
import 'data/repositories/device_repository.dart';
import 'presentation/blocs/device_bloc.dart';
import 'presentation/page/qr_scan_page.dart';
import 'general/device_module_routes.dart';

class DeviceModule extends Module {
  @override
  void binds(Injector i) {
    super.binds(i);

    // 🔥 ĐĂNG KÝ DATASOURCES
    i.addSingleton<DeviceRealtimeDatasource>(
          () => DeviceRealtimeDatasource(),
    );

    i.addSingleton<DeviceLogDatasource>(
          () => DeviceLogDatasource(),
    );
  }

  @override
  void exportedBinds(Injector i) {
    // API Layer
    i.addSingleton<DeviceApi>(() => DeviceApi());

    // Repository Layer
    i.addSingleton<DeviceRepository>(
          () => DeviceRepository(api: Modular.get<DeviceApi>()),
    );

    // DeviceDetailRepository
    i.add<DeviceDetailRepository>(
          () => DeviceDetailRepository(
        Modular.get<DeviceRealtimeDatasource>(),
        Modular.get<DeviceLogDatasource>(),
      ),
    );

    // BLoC Layer
    i.addSingleton<DeviceBloc>(
          () => DeviceBloc(repository: Modular.get<DeviceRepository>()),
    );

    // DeviceDetailBloc - tạo mới mỗi lần navigate
    i.add<DeviceDetailBloc>(
          () => DeviceDetailBloc(
        Modular.get<DeviceDetailRepository>(),
      ),
    );
  }

  @override
  void routes(RouteManager r) {
    r.child(
      DeviceModuleRoutes.addDevice,
      child: (context) => AddDevicePage(),
    );

    r.child(
      DeviceModuleRoutes.scanQr,
      child: (context) => QrScanPage(),
    );

    r.child(
      DeviceModuleRoutes.detail,
      child: (context) => BlocProvider<DeviceDetailBloc>(
        create: (context) => Modular.get<DeviceDetailBloc>(),
        child: const DetailDevicePage(),
      ),
    );

    r.child(
      DeviceModuleRoutes.setting,
      child: (context) => BlocProvider<DeviceDetailBloc>(
        create: (context) => Modular.get<DeviceDetailBloc>(),
        child: const DeviceSettingPage(),
      ),
    );

    r.child(
      DeviceModuleRoutes.control,
      child: (context) => BlocProvider<DeviceDetailBloc>(
        create: (context) => Modular.get<DeviceDetailBloc>(),
        child: DeviceControlPage(),
      ),
    );
  }
}