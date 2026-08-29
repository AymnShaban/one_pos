import '../../../shared_imports.dart';
class StoresBloc extends Bloc<StoresEvent, BaseState<List<StoreModel>>> {
  final StoresDataSource dataSource;

  StoresBloc({required this.dataSource})
      : super(const BaseState<List<StoreModel>>()) {
    on<LoadStores>(_onLoadStores);
    on<ClearStores>(_onClearStores);
  }

  Future<void> _onLoadStores(
      LoadStores event,
      Emitter<BaseState<List<StoreModel>>> emit,
      ) async {
    emit(state.copyWith(
      status: Status.loading,
      errorMessage: null,
      data: null,
    ));

    final result = await dataSource.getStores();

    result.fold(
          (failure) => emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: failure.message,
          failure: failure,
        ),
      ),
          (stores) => emit(
        state.copyWith(
          status: Status.success,
          data: stores,
          errorMessage: null,
          failure: null,
        ),
      ),
    );
  }

  void _onClearStores(
      ClearStores event,
      Emitter<BaseState<List<StoreModel>>> emit,
      ) {
    emit(const BaseState<List<StoreModel>>());
  }
}