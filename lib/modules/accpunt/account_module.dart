import 'package:flutter_api/modules/accpunt/data/datasource/account_api.dart';
import 'package:flutter_api/modules/accpunt/data/repositories/account_repository.dart';
import 'package:flutter_api/modules/accpunt/general/account_module_route.dart';
import 'package:flutter_api/modules/accpunt/presentation/blocs/account_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

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
    //r.child(AccountModuleRoute.account, child: (context) => AccountPage());
  }

}