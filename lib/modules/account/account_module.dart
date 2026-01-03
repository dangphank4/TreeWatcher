
import 'package:flutter_api/modules/account/presentation/blocs/account_bloc.dart';
import 'package:flutter_api/modules/account/presentation/page/account_page.dart';
import 'package:flutter_api/modules/account/presentation/page/help_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'data/datasource/account_api.dart';
import 'data/repositories/account_repository.dart';
import 'general/account_module_route.dart';

class AccountModule extends Module {
  @override
  void binds(Injector i) {
    // TODO: implement binds
    super.binds(i);
  }

  @override
  void exportedBinds(Injector i) {
    super.exportedBinds(i);

    i.addSingleton(() => AccountApi());
    i.addSingleton(() => AccountRepository(api: Modular.get<AccountApi>()));
    i.addSingleton(() => AccountBloc(repository: Modular.get<AccountRepository>()));
  }

  @override
  void routes(RouteManager r) {
    super.routes(r);
    r.child(AccountModuleRoute.account, child: (context) => AccountPage());
    r.child(AccountModuleRoute.help, child: (context) => HelpPage());
  }

}