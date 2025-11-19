import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLoginRequest extends AuthEvent {
  final String username;
  const AuthLoginRequest({required this.username});
}

class AuthLogoutRequest extends AuthEvent {
  const AuthLogoutRequest();
}
