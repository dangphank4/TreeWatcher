import 'package:flutter_api/modules/weather/data/repositories/weather_repository.dart';
import 'package:flutter_api/modules/weather/presentation/blocs/weather_event.dart';
import 'package:flutter_api/modules/weather/presentation/blocs/weather_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class WeatherBloc extends HydratedBloc<WeatherEvent, WeatherState> {
  final WeatherRepository repository;

  WeatherBloc({required this.repository}) : super(WeatherState.initial()) {
    on<WeatherEvent>((event, emit) async {
    });
  }

  @override
  WeatherState? fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic>? toJson(WeatherState state) {
    // TODO: implement toJson
    throw UnimplementedError();
  }


}