import '../../../receipts_and_payments_movement_report_import.dart';
class DeliveredToBloc extends Bloc<DeliveredToEvent, DeliveredToState> {
  final DeliveredToDataSource dataSource;

  DeliveredToBloc({required this.dataSource}) : super(const DeliveredToState()) {
    on<LoadDeliveredTo>(_onLoadDeliveredTo);
    on<SelectDeliveredTo>(_onSelectDeliveredTo);
  }

  Future<void> _onLoadDeliveredTo(
      LoadDeliveredTo event,
      Emitter<DeliveredToState> emit,
      ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await dataSource.getDeliveredTo(search: event.search);

    result.fold(
          (failure) => emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: failure.message,
        ),
      ),
            (items) {
          emit(
            state.copyWith(
              status: Status.success,
              items: items,
              selectedItem: null,
              selectedItems: const {},
              errorMessage: null,
            ),
          );
        }
    );
  }

  void _onSelectDeliveredTo(
      SelectDeliveredTo event,
      Emitter<DeliveredToState> emit,
      ) {
    final name = event.name;

    // ✅ التحقق الصحيح
    final exists = state.items.any((e) => e.name == name);

    if (exists) {
      emit(
        state.copyWith(
          selectedItem: name,
          selectedItems: {name},
        ),
      );
    }
  }
}