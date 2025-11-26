import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event login
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// Event register
class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthRegisterRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// Event logout
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthResetPasswordRequested extends AuthEvent {
  final String email;

  const AuthResetPasswordRequested({required this.email});
}

class AuthUpdatePasswordRequested extends AuthEvent {
  final String currentPassword;
  final String newPassword;

  const AuthUpdatePasswordRequested({required this.currentPassword, required this.newPassword});
}
