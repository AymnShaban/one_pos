import '../../../revenue_analysis_import.dart';

class RevenueReportBloc extends Bloc<RevenueReportEvent, RevenueReportState> {
  final RevenueReportDataSource dataSource;

  RevenueReportBloc({required this.dataSource})
      : super(const RevenueReportState()) {
    on<LoadRevenueReport>(_onLoadRevenueReport);
    on<ClearRevenueReport>(_onClearRevenueReport);
  }

  Future<void> _onLoadRevenueReport(
      LoadRevenueReport event,
      Emitter<RevenueReportState> emit,
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

  void _onClearRevenueReport(
      ClearRevenueReport event,
      Emitter<RevenueReportState> emit,
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