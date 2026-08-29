import '../../items_movement_import.dart';

class ItemMovementBloc extends Bloc<
    ItemMovementEvent,
    BaseState<ItemMovementResponseModel>
> {
  final ItemMovementDataSource dataSource;

  ItemMovementBloc({
    required this.dataSource,
  }) : super(
    const BaseState<ItemMovementResponseModel>(),
  ) {
    on<LoadItemMovementReport>(
      _onLoadItemMovementReport,
    );

    on<ClearItemMovementReport>(
      _onClearItemMovementReport,
    );
  }

  Future<void> _onLoadItemMovementReport(
      LoadItemMovementReport event,
      Emitter<BaseState<ItemMovementResponseModel>> emit,
      ) async {
    emit(
      state.copyWith(
        status: Status.loading,
        errorMessage: null,
        failure: null,
      ),
    );

    final result = await dataSource.getReport(event.request);

    result.fold(
          (failure) {
        emit(
          state.copyWith(
            status: Status.failure,
            errorMessage: failure.message,
            failure: failure,
          ),
        );
      },
          (report) {
        emit(
          state.copyWith(
            status: Status.success,
            data: report,
            errorMessage: null,
            failure: null,
          ),
        );
      },
    );
  }

  void _onClearItemMovementReport(
      ClearItemMovementReport event,
      Emitter<BaseState<ItemMovementResponseModel>> emit,
      ) {
    emit(
      const BaseState<ItemMovementResponseModel>(
        status: Status.initial,
      ),
    );
  }
}