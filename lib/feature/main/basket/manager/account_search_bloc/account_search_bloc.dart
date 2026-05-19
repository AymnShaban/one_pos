part of '../../basket_imports.dart';

class AccountSearchBloc
    extends Bloc<AccountSearchEvent, BaseState<CustomerAccountModel>> {
  final AccountSearchDataSource _dataSource;

  AccountSearchBloc({required AccountSearchDataSource dataSource})
      : _dataSource = dataSource,
        super(const BaseState<CustomerAccountModel>()) {
    on<SearchAccounts>(_onSearch);
  }

  Future<void> _onSearch(
    SearchAccounts event,
    Emitter<BaseState<CustomerAccountModel>> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(const BaseState<CustomerAccountModel>(
        status: Status.success,
        items: [],
      ));
      return;
    }

    emit(state.copyWith(status: Status.loading));

    final result = await _dataSource.searchCustomers(query);

    result.fold(
      (failure) => emit(state.copyWith(
        status: Status.failure,
        failure: failure,
        errorMessage: failure.message,
      )),
      (items) => emit(state.copyWith(
        status: Status.success,
        items: items,
      )),
    );
  }
}
