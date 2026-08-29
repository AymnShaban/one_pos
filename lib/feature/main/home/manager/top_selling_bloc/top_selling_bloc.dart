part of '../../home_imports.dart';

class TopSellingBloc
    extends Bloc<TopSellingEvent, BaseState<List<TopSellingItemModel>>> {
  final TopSellingDataSource _dataSource;

  TopSellingBloc({required TopSellingDataSource dataSource})
      : _dataSource = dataSource,
        super(const BaseState<List<TopSellingItemModel>>()) {
    on<LoadTopSellingItems>(_onLoadTopSellingItems);
    on<RefreshTopSellingItems>(_onRefreshTopSellingItems);
  }

  Future<void> _onLoadTopSellingItems(
      LoadTopSellingItems event,
      Emitter<BaseState<List<TopSellingItemModel>>> emit,
      ) async {
    if (state.status == Status.loading) return;

    emit(state.copyWith(
      status: Status.loading,
      errorMessage: null,
      data: null,
    ));

    final result = await _dataSource.getTopSellingItems(
      top: event.top,
      sortBy: event.sortBy,
    );

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

  Future<void> _onRefreshTopSellingItems(
      RefreshTopSellingItems event,
      Emitter<BaseState<List<TopSellingItemModel>>> emit,
      ) async {
    add(LoadTopSellingItems(top: event.top, sortBy: event.sortBy));
  }
}