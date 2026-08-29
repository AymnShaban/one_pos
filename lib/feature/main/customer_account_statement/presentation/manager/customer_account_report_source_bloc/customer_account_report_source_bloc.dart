import '../../../customer_account_imports.dart';
class CustomerAccountReportSourceBloc extends Bloc<
    CustomerAccountReportSourceEvent,
    CustomerAccountReportSourceState> {
  final CustomerAccountReportSourceDataSource dataSource;

  CustomerAccountReportSourceBloc({
    required this.dataSource,
  }) : super(const CustomerAccountReportSourceState()) {
    on<LoadCustomerAccountReportSources>(
      _onLoadReportSources,
    );

    on<SelectCustomerAccountReportSource>(
      _onSelectReportSource,
    );

    on<ClearCustomerAccountReportSources>(
      _onClearReportSources,
    );
  }

  Future<void> _onLoadReportSources(
      LoadCustomerAccountReportSources event,
      Emitter<CustomerAccountReportSourceState> emit,
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
        // العناصر التي API محدد أنها checked
        final selectedItems = items
            .where((item) => item.checked)
            .map((item) => item.value)
            .toSet();

        final selectedItem = selectedItems.isNotEmpty
            ? selectedItems.first
            : null;

        emit(
          state.copyWith(
            status: Status.success,
            items: items,
            selectedItems: selectedItems,
            selectedItem: selectedItem,
            errorMessage: null,
          ),
        );
      },
    );
  }

  void _onSelectReportSource(
      SelectCustomerAccountReportSource event,
      Emitter<CustomerAccountReportSourceState> emit,
      ) {
    final exists = state.items.any(
          (item) => item.value == event.value,
    );

    if (!exists) return;

    final selectedItems = {...state.selectedItems};

    if (selectedItems.contains(event.value)) {
      selectedItems.remove(event.value);
    } else {
      selectedItems.add(event.value);
    }

    emit(
      state.copyWith(
        selectedItems: selectedItems,
        selectedItem: event.value,
      ),
    );
  }

  void _onClearReportSources(
      ClearCustomerAccountReportSources event,
      Emitter<CustomerAccountReportSourceState> emit,
      ) {
    emit(
      state.copyWith(
        selectedItems: const {},
        clearSelected: true,
      ),
    );
  }
}