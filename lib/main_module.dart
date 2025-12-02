import 'package:dio/dio.dart';
import 'package:flutter_api/modules/accpunt/account_module.dart';
import 'package:flutter_api/modules/weather/weather_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/app_evironment.dart';
import 'core/constants/app_routes.dart';
import 'core/helpers/shared_preference_helper.dart';
import 'core/network/dio_client.dart';
import 'modules/app/app_module.dart';
import 'modules/auth/auth_module.dart';

class MainModule extends Module {
  final SharedPreferences sharedPreferences;

  MainModule({required this.sharedPreferences});

  @override
  void binds(Injector i) {
    super.binds(i);
    i.addSingleton(
      () => SharedPreferenceHelper(sharedPreferences: sharedPreferences),
    );

    i.addSingleton(() => Dio());

    i.addSingleton(() => DioClient(Modular.get<Dio>(), AppEnvironment.baseUrl));
  }

  @override
  List<Module> get imports => [AppModule(),AuthModule(), WeatherModule(), AccountModule()];

  @override
  void routes(RouteManager r) {
    super.routes(r);

    r.module(AppRoutes.moduleApp, module: AppModule());
    r.module(AppRoutes.moduleAuth, module: AuthModule());
    r.module(AppRoutes.moduleWeather, module: WeatherModule());
    r.module(AppRoutes.moduleAccount, module: AccountModule());
  }
}
