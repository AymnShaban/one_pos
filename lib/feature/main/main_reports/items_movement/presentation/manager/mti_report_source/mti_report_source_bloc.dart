import '../../../items_movement_import.dart';
class MTIReportSourceBloc
    extends Bloc<MTIReportSourceEvent, MTIReportSourceState> {
  final MTIReportSourceDataSource dataSource;

  MTIReportSourceBloc({
    required this.dataSource,
  }) : super(const MTIReportSourceState()) {
    on<LoadMTIReportSources>(_onLoadReportSources);
    on<SelectMTIReportSource>(_onSelectReportSource);
  }

  Future<void> _onLoadReportSources(
      LoadMTIReportSources event,
      Emitter<MTIReportSourceState> emit,
      ) async {
    emit(
      state.copyWith(
        status: Status.loading,
        errorMessage: null,
      ),
    );

    final result = await dataSource.getReportSources();

    result.fold(
          (failure) {
        emit(
          state.copyWith(
            status: Status.failure,
            errorMessage: failure.message,
          ),
        );
      },
          (items) {
        emit(
          state.copyWith(
            status: Status.success,
            items: items,
            selectedItems: const {},
            selectedItem: null,
            errorMessage: null,
          ),
        );
      },
    );
  }

  void _onSelectReportSource(
      SelectMTIReportSource event,
      Emitter<MTIReportSourceState> emit,
      ) {
    final exists = state.items.any(
          (item) => item.name == event.name,
    );

    if (!exists) return;

    final selectedItems = {...state.selectedItems};

    if (selectedItems.contains(event.name)) {
      selectedItems.remove(event.name);
    } else {
      selectedItems.add(event.name);
    }

    emit(
      state.copyWith(
        selectedItems: selectedItems,
        selectedItem: event.name,
      ),
    );
  }
}