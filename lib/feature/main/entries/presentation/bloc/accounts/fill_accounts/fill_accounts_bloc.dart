// fill_accounts_bloc.dart

import '../../../../entries_imports.dart';

class FillAccountsBloc extends Bloc<AccountsEvent, BaseState<List<AccountModel>>> {
  final EntriesDataSource _dataSource;

  List<AccountModel>? _fillAccounts;

  FillAccountsBloc({
    required EntriesDataSource dataSource,
  })  : _dataSource = dataSource,
        super(const BaseState<List<AccountModel>>()) {
    on<LoadFillAccounts>(_onLoadFillAccounts);
    on<ClearFillAccounts>(_onClearFillAccounts);
  }

  List<AccountModel>? get fillAccounts => _fillAccounts;

  Future<void> _onLoadFillAccounts(
      LoadFillAccounts event,
      Emitter<BaseState<List<AccountModel>>> emit,
      ) async {
    if (state.status == Status.loading) return;

    emit(
      state.copyWith(
        status: Status.loading,
        errorMessage: null,
        failure: null,
      ),
    );

    final result = await _dataSource.getFillAccountList(
      entryType: event.entryType,
      branchId: event.branchId,
      userName: event.userName,
      limitAccessEntry: event.limitAccessEntry,
      mainAcIDs: event.mainAcIDs,
    );

    result.fold(
          (failure) {
        emit(
          state.copyWith(
            status: Status.failure,
            errorMessage: failure.message,
            failure: failure,
          ),
        );
      },
          (accounts) {
        _fillAccounts = accounts;
        emit(
          state.copyWith(
            status: Status.success,
            data: accounts,
            errorMessage: null,
            failure: null,
          ),
        );
      },
    );
  }

  void _onClearFillAccounts(
      ClearFillAccounts event,
      Emitter<BaseState<List<AccountModel>>> emit,
      ) {
    _fillAccounts = null;
    emit(const BaseState<List<AccountModel>>());
  }
}