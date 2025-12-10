import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/datasource/device_api.dart';
import 'data/repositories/device_repository.dart';
import 'presentation/blocs/device_bloc.dart';
import 'presentation/page/add_device_page.dart';
import 'presentation/page/qr_scan_page.dart';
import 'general/device_module_routes.dart';

class DeviceModule extends Module {
  @override
  void binds(Injector i) {
    i.addSingleton<DeviceApi>(DeviceApi.new);

    i.addSingleton<DeviceRepository>(
            () => DeviceRepository(api: i.get<DeviceApi>())
    );
  }

  @override
  void routes(RouteManager r) {
    r.child(
      DeviceModuleRoutes.addDevice,
      child: (_) => BlocProvider(
        create: (context) => DeviceBloc(
          repo: Modular.get<DeviceRepository>(),
        ),
        child: const AddDevicePage(),
      ),
    );

    r.child( DeviceModuleRoutes.scanQr, child: (_) => const QrScanPage());
    r.child( DeviceModuleRoutes.addDevice, child: (_) => const AddDevicePage());
  }
}