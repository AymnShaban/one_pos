import '../../../../entries_imports.dart';

class MainAccountsBloc extends Bloc<AccountsEvent, BaseState<List<AccountModel>>> {
  final EntriesDataSource _dataSource;

  AccountBalanceModel? _accountBalance;

  MainAccountsBloc({
    required EntriesDataSource dataSource,
  })  : _dataSource = dataSource,
        super(const BaseState<List<AccountModel>>()) {
    on<LoadMainAccounts>(_onLoadMainAccounts);
    on<LoadMainAccountBalance>(_onLoadMainAccountBalance);
    on<ClearMainAccounts>(_onClearMainAccounts);
  }

  AccountBalanceModel? get accountBalance => _accountBalance;

  Future<void> _onLoadMainAccounts(
      LoadMainAccounts event,
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

    final result = await _dataSource.getAllAccounts();

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

  Future<void> _onLoadMainAccountBalance(
      LoadMainAccountBalance event,
      Emitter<BaseState<List<AccountModel>>> emit,
      ) async {
    final result = await _dataSource.getAccountBalance(event.acId);

    result.fold(
          (failure) {
        _accountBalance = null;
      },
          (balance) {
        _accountBalance = balance;
      },
    );
  }

  void _onClearMainAccounts(
      ClearMainAccounts event,
      Emitter<BaseState<List<AccountModel>>> emit,
      ) {
    _accountBalance = null;
    emit(const BaseState<List<AccountModel>>());
  }
}