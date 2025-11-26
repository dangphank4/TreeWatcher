import 'package:equatable/equatable.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthAuthenticated extends AuthState {
  final Map<String, dynamic> data;

  const AuthAuthenticated({required this.data});

  @override
  List<Object?> get props => [data];
}

final class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Khi gửi email đặt lại mật khẩu thành công
final class AuthResetPasswordSuccess extends AuthState {
  final String message; // ví dụ: "Email đã được gửi"

  const AuthResetPasswordSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Khi gửi email đặt lại mật khẩu thất bại
final class AuthResetPasswordFailure extends AuthState {
  final String error; // ví dụ: "Email không tồn tại"

  const AuthResetPasswordFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

final class AuthUpdatePasswordFailure extends AuthState {
  final String error;
  const AuthUpdatePasswordFailure({required this.error});
  @override
  List<Object?> get props => [error];
}

final class AuthUpdatePasswordSuccess extends AuthState {
  final String message;
  const AuthUpdatePasswordSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

