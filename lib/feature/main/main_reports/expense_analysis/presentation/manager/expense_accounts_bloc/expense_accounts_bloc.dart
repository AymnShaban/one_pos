import '../../../expense_analysis_imports.dart';

class ExpenseAccountsBloc extends Bloc<ExpenseAccountsEvent, ExpenseAccountsState> {
  final ExpenseAccountsDataSource dataSource;

  ExpenseAccountsBloc({required this.dataSource})
      : super(const ExpenseAccountsState()) {
    on<LoadExpenseAccounts>(_onLoadExpenseAccounts);
    on<SelectExpenseAccount>(_onSelectExpenseAccount);
    on<ClearExpenseAccounts>(_onClearExpenseAccounts);
  }

  Future<void> _onLoadExpenseAccounts(
      LoadExpenseAccounts event,
      Emitter<ExpenseAccountsState> emit,
      ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await dataSource.getExpenseAccounts(search: event.search);

    result.fold(
          (failure) => emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: failure.message,
        ),
      ),
          (accounts) {
        // ✅ اختار أول عنصر تلقائياً
        final selectedId = accounts.isNotEmpty ? accounts.first.id : null;
        emit(
          state.copyWith(
            status: Status.success,
            accounts: accounts,
            selectedAccountId: selectedId,
            errorMessage: null,
          ),
        );
      },
    );
  }

  void _onSelectExpenseAccount(
      SelectExpenseAccount event,
      Emitter<ExpenseAccountsState> emit,
      ) {
    emit(
      state.copyWith(
        selectedAccountId: event.accountId,
      ),
    );
  }

  void _onClearExpenseAccounts(
      ClearExpenseAccounts event,
      Emitter<ExpenseAccountsState> emit,
      ) {
    emit(
      state.copyWith(
        status: Status.initial,
        accounts: [],
        clearSelected: true,
        errorMessage: null,
      ),
    );
  }
}