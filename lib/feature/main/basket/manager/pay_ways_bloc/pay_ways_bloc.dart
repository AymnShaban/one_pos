part of '../../basket_imports.dart';

class PayWaysBloc extends Bloc<PayWaysEvent, BaseState<PayWayModel>> {
  final PayWaysDataSource _dataSource;

  PayWaysBloc({required PayWaysDataSource dataSource})
      : _dataSource = dataSource,
        super(const BaseState<PayWayModel>()) {
    on<FetchPayWays>(_onFetch);
  }

  Future<void> _onFetch(
    FetchPayWays event,
    Emitter<BaseState<PayWayModel>> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await _dataSource.getPayWays();

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
