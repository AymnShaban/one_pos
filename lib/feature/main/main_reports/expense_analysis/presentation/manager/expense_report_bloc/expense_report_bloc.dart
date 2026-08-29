import '../../../expense_analysis_imports.dart';

class ExpenseReportBloc extends Bloc<ExpenseReportEvent, ExpenseReportState> {
  final ExpenseReportDataSource dataSource;

  ExpenseReportBloc({required this.dataSource})
      : super(const ExpenseReportState()) {
    on<LoadExpenseReport>(_onLoadExpenseReport);
    on<ClearExpenseReport>(_onClearExpenseReport);
  }

  Future<void> _onLoadExpenseReport(
      LoadExpenseReport event,
      Emitter<ExpenseReportState> emit,
      ) async {
    emit(state.copyWith(
      status: Status.loading,
      clearError: true,
      clearReport: true,
    ));

    final result = await dataSource.getReport(event.request);

    result.fold(
          (failure) => emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: failure.message,
        ),
      ),
          (report) => emit(
        state.copyWith(
          status: Status.success,
          reportData: report,
          errorMessage: null,
        ),
      ),
    );
  }

  void _onClearExpenseReport(
      ClearExpenseReport event,
      Emitter<ExpenseReportState> emit,
      ) {
    emit(
      state.copyWith(
        status: Status.initial,
        clearReport: true,
        clearError: true,
      ),
    );
  }
}