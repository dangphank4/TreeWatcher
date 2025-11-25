import 'package:flutter_api/core/constants/app_routes.dart';
import 'package:flutter_api/core/constants/app_store.dart';
import 'package:flutter_api/core/helpers/navigation_helper.dart';
import 'package:flutter_api/core/helpers/shared_preference_helper.dart';
import 'package:flutter_api/core/utils/globals.dart';
import 'package:flutter_api/modules/auth/data/repositories/auth_respository.dart';
import 'package:flutter_api/modules/auth/general/auth_module_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  final sharedPreferenceHelper = Modular.get<SharedPreferenceHelper>();

  AuthBloc({required this.authRepository}) : super(const AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested); // thêm sự kiện register
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  // Xử lý login
  Future<void> _onLoginRequested(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final data = await authRepository.login(
      email: event.email,
      password: event.password,
    );

    if (data != null) {
      // Cập nhật Globals
      Globals.globalAccessToken = data['token'];
      Globals.globalUserId = data['userId'];
      Globals.globalUsername = data['username'];

      // Lưu vào SharedPreferences
      await sharedPreferenceHelper.set(
          key: AppStores.kAccessToken, value: data['token']!);
      await sharedPreferenceHelper.set(
          key: AppStores.kUserId, value: data['userId']!);
      await sharedPreferenceHelper.set(
          key: AppStores.kUsername, value: data['username']!);

      emit(AuthAuthenticated(data: data));
    } else {
      emit(const AuthFailure('Login failed'));
    }
  }

  // Xử lý register
  Future<void> _onRegisterRequested(
      AuthRegisterRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final data = await authRepository.register(
      email: event.email,
      password: event.password,
    );

    if (data != null) {
      Globals.globalAccessToken = data['token'];
      Globals.globalUserId = data['userId'];
      Globals.globalUsername = data['username'];

      await sharedPreferenceHelper.set(
          key: AppStores.kAccessToken, value: data['token']!);
      await sharedPreferenceHelper.set(
          key: AppStores.kUserId, value: data['userId']!);
      await sharedPreferenceHelper.set(
          key: AppStores.kUsername, value: data['username']!);

      emit(AuthAuthenticated(data: data));
    } else {
      emit(const AuthFailure('Register failed'));
    }
  }

  // Xử lý logout
  Future<void> _onLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    await authRepository.logout();

    // Xóa globals
    Globals.globalAccessToken = null;
    Globals.globalUserId = null;
    Globals.globalUsername = null;

    // Xóa SharedPreferences
    await sharedPreferenceHelper.remove(key: AppStores.kAccessToken);
    await sharedPreferenceHelper.remove(key: AppStores.kUserId);
    await sharedPreferenceHelper.remove(key: AppStores.kUsername);

    NavigationHelper.reset(
      '${AppRoutes.moduleAuth}${AuthModuleRoutes.signIn}',
    );

    emit(const AuthUnauthenticated());
  }
}
