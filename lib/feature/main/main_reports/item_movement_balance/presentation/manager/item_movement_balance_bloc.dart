import '../../item_movement_balance_import.dart';
class ItemMovementBalanceBloc extends Bloc<ItemMovementBalanceEvent, BaseState<ItemMovementBalanceResponseModel>> {
  final ItemMovementBalanceDataSource dataSource;

  ItemMovementBalanceBloc({required this.dataSource})
      : super(const BaseState<ItemMovementBalanceResponseModel>()) {
    on<LoadItemMovementBalanceReport>(_onLoadItemMovementBalanceReport);
    on<ClearItemMovementBalanceReport>(_onClearItemMovementBalanceReport);
  }

  Future<void> _onLoadItemMovementBalanceReport(
      LoadItemMovementBalanceReport event,
      Emitter<BaseState<ItemMovementBalanceResponseModel>> emit,
      ) async {
    emit(state.copyWith(
      status: Status.loading,
      errorMessage: null,
      data: null,
    ));

    final result = await dataSource.getReport(event.request);

    result.fold(
          (failure) => emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: failure.message,
          failure: failure,
        ),
      ),
          (report) => emit(
        state.copyWith(
          status: Status.success,
          data: report,
          errorMessage: null,
          failure: null,
        ),
      ),
    );
  }

  void _onClearItemMovementBalanceReport(
      ClearItemMovementBalanceReport event,
      Emitter<BaseState<ItemMovementBalanceResponseModel>> emit,
      ) {
    emit(
      const BaseState<ItemMovementBalanceResponseModel>(
        status: Status.initial,
      ),
    );
  }
}