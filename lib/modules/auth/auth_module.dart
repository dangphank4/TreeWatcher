import 'package:flutter_api/modules/auth/presentation/blocs/auth_bloc.dart';
import 'package:flutter_api/modules/auth/presentation/page/sign_in_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'data/datasource/auth_api.dart';
import 'data/repositories/auth_respository.dart';
import 'general/auth_module_routes.dart';

class AuthModule extends Module {
  @override
  void exportedBinds(Injector i) {
    super.exportedBinds(i);
    i.addSingleton(() => AuthApi());
    i.addSingleton(() => AuthRepository(api: Modular.get<AuthApi>()));
    i.addSingleton(
          () => AuthBloc(repository: Modular.get<AuthRepository>()),
    );
  }

  @override
  void routes(RouteManager r) {
    super.routes(r);
    r.child(AuthModuleRoutes.signIn, child: (context) => SignInPage());
  }
}
