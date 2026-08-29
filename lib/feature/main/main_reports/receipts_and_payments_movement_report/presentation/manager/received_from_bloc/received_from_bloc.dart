import '../../../receipts_and_payments_movement_report_import.dart';
class ReceivedFromBloc
    extends Bloc<ReceivedFromEvent, ReceivedFromState> {
  final ReceivedFromDataSource dataSource;

  ReceivedFromBloc({
    required this.dataSource,
  }) : super(const ReceivedFromState()) {
    on<LoadReceivedFrom>(_onLoadReceivedFrom);
    on<SelectReceivedFrom>(_onSelectReceivedFrom);
  }

  Future<void> _onLoadReceivedFrom(
      LoadReceivedFrom event,
      Emitter<ReceivedFromState> emit,
      ) async {
    emit(
      state.copyWith(
        status: Status.loading,
      ),
    );

    final result = await dataSource.getReceivedFrom(
      search: event.search,
    );

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

  void _onSelectReceivedFrom(
      SelectReceivedFrom event,
      Emitter<ReceivedFromState> emit,
      ) {
    final name = event.name;

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