
import '../../item_profit_import.dart';

class ItemProfitBloc extends Bloc<ItemProfitEvent, BaseState<ItemProfitResponseModel>> {
  final ItemProfitDataSource dataSource;

  ItemProfitBloc({required this.dataSource})
      : super(const BaseState<ItemProfitResponseModel>()) {
    on<LoadItemProfitReport>(_onLoadItemProfitReport);
    on<ClearItemProfitReport>(_onClearItemProfitReport);
  }

  Future<void> _onLoadItemProfitReport(
      LoadItemProfitReport event,
      Emitter<BaseState<ItemProfitResponseModel>> emit,
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

  void _onClearItemProfitReport(
      ClearItemProfitReport event,
      Emitter<BaseState<ItemProfitResponseModel>> emit,
      ) {
    emit(
      const BaseState<ItemProfitResponseModel>(
        status: Status.initial,
      ),
    );
  }
}