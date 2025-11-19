import 'package:flutter_api/modules/app/presentation/blocs/app_bloc.dart';
import 'package:flutter_api/modules/app/presentation/pages/main_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'data/datasources/app_api.dart';
import 'data/repositories/app_repository.dart';
import 'general/app_module_routes.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    super.binds(i);
  }
  @override
  void exportedBinds(Injector i) {
    super.exportedBinds(i);

    i.addSingleton(() => AppApi());
    i.addSingleton(() => AppRepository(api: Modular.get<AppApi>()));
    i.addSingleton(() => AppBloc(repository: Modular.get<AppRepository>()));
  }

  @override
  void routes(RouteManager r) {
    super.routes(r);
    r.child(AppModuleRoutes.main, child: (context) => const MainPage());
  }
}