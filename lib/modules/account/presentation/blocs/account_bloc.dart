import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_api/modules/account/data/repositories/account_repository.dart';
import 'package:flutter_api/modules/account/presentation/blocs/account_event.dart';
import 'package:flutter_api/modules/account/presentation/blocs/account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountRepository repository;

  AccountBloc({required this.repository}) : super(AccountInitial()) {
    on<CheckProfileRequested>(_onCheckProfileRequested);
  }



  Future<void> _onCheckProfileRequested(
      CheckProfileRequested event,
      Emitter<AccountState> emit,
      ) async {
    emit(AccountLoading());

    final isCompleted = await repository.hasCompletedProfile();

    if (isCompleted) {
      emit(ProfileCompleted());
    } else {
      emit(ProfileIncomplete());
    }
  }
}
