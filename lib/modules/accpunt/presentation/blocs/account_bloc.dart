import 'package:flutter_api/modules/accpunt/data/repositories/account_repository.dart';
import 'package:flutter_api/modules/accpunt/presentation/blocs/account_event.dart';
import 'package:flutter_api/modules/accpunt/presentation/blocs/account_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class AccountBloc extends HydratedBloc<AccountEvent, AccountState> {
  final AccountRepository repository;

  AccountBloc({required this.repository}) : super(AccountState.initial()) {
    on<AccountEvent>((event, emit) async {});
  }

  @override
  AccountState? fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic>? toJson(AccountState state) {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}