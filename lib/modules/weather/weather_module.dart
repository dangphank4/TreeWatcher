import 'package:flutter_api/modules/weather/data/datasource/weather_api.dart';
import 'package:flutter_api/modules/weather/data/repositories/weather_repository.dart';
import 'package:flutter_api/modules/weather/general/weather_module_routes.dart';
import 'package:flutter_api/modules/weather/presentation/blocs/weather_bloc.dart';
import 'package:flutter_api/modules/weather/presentation/blocs/weather_state.dart';
import 'package:flutter_api/modules/weather/presentation/pages/weather_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class WeatherModule extends Module {
  @override
  void binds(Injector i) {
    super.binds(i);
  }

  @override
  void exportedBinds(Injector i) {
    super.exportedBinds(i);

    i.addSingleton(() => WeatherApi());
    i.addSingleton(() => WeatherRepository(api: Modular.get<WeatherApi>()));
    i.addSingleton(
        () => WeatherBloc(repository: Modular.get<WeatherRepository>())
    );
  }

  @override
  void routes(RouteManager r) {
    super.routes(r);
    r.child(WeatherModuleRoutes.weather, child: (context) => WeatherPage());
  }
}