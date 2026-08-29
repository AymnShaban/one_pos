import '../../../revenue_analysis_import.dart';

class RevenueAccountsBloc extends Bloc<RevenueAccountsEvent, RevenueAccountsState> {
  final RevenueAccountsDataSource dataSource;

  RevenueAccountsBloc({required this.dataSource})
      : super(const RevenueAccountsState()) {
    on<LoadRevenueAccounts>(_onLoadRevenueAccounts);
    on<SelectRevenueAccount>(_onSelectRevenueAccount);
    on<ClearRevenueAccounts>(_onClearRevenueAccounts);
  }

  Future<void> _onLoadRevenueAccounts(
      LoadRevenueAccounts event,
      Emitter<RevenueAccountsState> emit,
      ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await dataSource.getRevenueAccounts(search: event.search);

    result.fold(
          (failure) => emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: failure.message,
        ),
      ),
          (accounts) {
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

  void _onSelectRevenueAccount(
      SelectRevenueAccount event,
      Emitter<RevenueAccountsState> emit,
      ) {
    emit(
      state.copyWith(
        selectedAccountId: event.accountId,
      ),
    );
  }

  void _onClearRevenueAccounts(
      ClearRevenueAccounts event,
      Emitter<RevenueAccountsState> emit,
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