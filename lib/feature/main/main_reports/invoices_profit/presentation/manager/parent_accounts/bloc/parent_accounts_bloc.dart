import '../../../../data/datasource/parent_accounts_datasource.dart';
import '../../../../invoice_profit_imports.dart';
class ParentAccountsBloc extends Bloc<ParentAccountsEvent, ParentAccountsState> {
  final ParentAccountsDataSource dataSource;

  ParentAccountsBloc({required this.dataSource})
      : super(const ParentAccountsState()) {
    on<LoadParentAccounts>(_onLoadParentAccounts);
    on<SelectParentAccount>(_onSelectParentAccount);
  }

  Future<void> _onLoadParentAccounts(
      LoadParentAccounts event,
      Emitter<ParentAccountsState> emit,
      ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await dataSource.getParentAccounts();

    result.fold(
          (failure) => emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: failure.message,
        ),
      ),
          (accounts) {
       // final selectedId = accounts.isNotEmpty ? accounts.first.acID : null;
        emit(
          state.copyWith(
            status: Status.success,
            parentAccounts: accounts,
            selectedParentAccountId: null,
            errorMessage: null,
          ),
        );
      },
    );
  }

  void _onSelectParentAccount(
      SelectParentAccount event,
      Emitter<ParentAccountsState> emit,
      ) {
    emit(
      state.copyWith(
        selectedParentAccountId: event.parentAccountId,
      ),
    );
  }
}