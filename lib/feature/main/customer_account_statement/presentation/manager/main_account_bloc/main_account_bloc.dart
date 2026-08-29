import '../../../customer_account_imports.dart';

class MainAccountsBloc extends Bloc<MainAccountEvent, BaseState<List<MainAccountModel>>> {
  final MainAccountsDataSource dataSource;

  MainAccountsBloc({required this.dataSource})
      : super(const BaseState<List<MainAccountModel>>()) {
    on<LoadMainAccounts>(_onLoadMainAccounts);
  }

  Future<void> _onLoadMainAccounts(
      LoadMainAccounts event,
      Emitter<BaseState<List<MainAccountModel>>> emit,
      ) async {
    emit(state.copyWith(
      status: Status.loading,
      errorMessage: null,
      data: null,
    ));

    final result = await dataSource.getMainAccounts();

    result.fold(
          (failure) => emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: failure.message,
          failure: failure,
        ),
      ),
          (accounts) => emit(
        state.copyWith(
          status: Status.success,
          data: accounts,
          errorMessage: null,
          failure: null,
        ),
      ),
    );
  }
}