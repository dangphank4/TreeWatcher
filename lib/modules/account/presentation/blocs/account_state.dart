import 'package:equatable/equatable.dart';
import 'package:flutter_api/core/models/user_model.dart';

sealed class AccountState extends Equatable{
  const AccountState();
  @override
  List<Object?> get props => [];

}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class AccountError extends AccountState {
  final String message;
  const AccountError(this.message);
}

class ProfileIncomplete extends AccountState {}
class ProfileCompleted extends AccountState {}
