part of '../../live_sales_report_imports.dart';

class DelegateBloc extends Bloc<DelegateEvent, BaseState<DelegateModel>> {
  final DelegateDataSource _dataSource;

  DelegateBloc({required DelegateDataSource dataSource})
      : _dataSource = dataSource,
        super(const BaseState<DelegateModel>()) {
    on<LoadDelegates>(_onLoad);
  }

  Future<void> _onLoad(
    LoadDelegates event,
    Emitter<BaseState<DelegateModel>> emit,
  ) async {
    // Idempotent: don't refetch while loading or already populated.
    if (state.status == Status.loading) return;
    if (state.status == Status.success && state.items.isNotEmpty) return;

    emit(state.copyWith(status: Status.loading));

    final result = await _dataSource.getDelegates(search: '');
    result.fold(
      (failure) => emit(state.copyWith(
        status: Status.failure,
        errorMessage: failure.message,
      )),
      (items) => emit(state.copyWith(status: Status.success, items: items)),
    );
  }
}
