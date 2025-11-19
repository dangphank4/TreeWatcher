import 'package:flutter_api/modules/app/data/repositories/app_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends HydratedBloc<AppEvent, AppState> {
  final AppRepository repository;
  AppBloc({required this.repository}) : super(AppState.initial()) {
    on<AppEvent>((event, emit) async {
    });
  }

  @override
  AppState? fromJson(Map<String, dynamic> json) {
    return AppState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(AppState state) {
    return state.toJson();
  }
}
