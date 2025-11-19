import 'package:flutter_api/core/helpers/shared_preference_helper.dart';
import 'package:flutter_api/modules/auth/data/repositories/auth_respository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {
  final AuthRepository repository;
  final sharedPreferenceHelper = Modular.get<SharedPreferenceHelper>();

  AuthBloc({required this.repository}) : super(const AuthState.initial()) {
    on<AuthEvent>((event, emit) async {});
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
