part of '../../home_imports.dart';

class LowStockBloc
    extends Bloc<LowStockEvent, BaseState<List<LowStockItemModel>>> {
  final LowStockDataSource _dataSource;

  LowStockBloc({required LowStockDataSource dataSource})
      : _dataSource = dataSource,
        super(const BaseState<List<LowStockItemModel>>()) {
    on<LoadLowStockItems>(_onLoadLowStockItems);
    on<RefreshLowStockItems>(_onRefreshLowStockItems);
  }

  Future<void> _onLoadLowStockItems(
      LoadLowStockItems event,
      Emitter<BaseState<List<LowStockItemModel>>> emit,
      ) async {
    if (state.status == Status.loading) return;

    emit(state.copyWith(
      status: Status.loading,
      errorMessage: null,
      data: null,
    ));

    final result = await _dataSource.getLowStockItems(top: event.top);

    result.fold(
          (failure) => emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: failure.message,
          failure: failure,
        ),
      ),
          (items) => emit(
        state.copyWith(
          status: Status.success,
          data: items,
          errorMessage: null,
          failure: null,
        ),
      ),
    );
  }

  Future<void> _onRefreshLowStockItems(
      RefreshLowStockItems event,
      Emitter<BaseState<List<LowStockItemModel>>> emit,
      ) async {
    add(LoadLowStockItems(top: event.top));
  }
}