import 'package:equatable/equatable.dart';

sealed class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object?> get props => [];
}
// Event check profile hoàn thành hay chưa
class CheckProfileRequested extends AccountEvent {}
