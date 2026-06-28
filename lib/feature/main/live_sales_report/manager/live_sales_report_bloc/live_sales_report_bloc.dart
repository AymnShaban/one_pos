part of '../../live_sales_report_imports.dart';

/// One bloc per endpoint. Holds the latest preview result as
/// `state.items` (= list of `SalesMovementsReportPage`).
class LiveSalesReportBloc
    extends Bloc<LiveSalesReportEvent, BaseState<SalesMovementsReportPage>> {
  final LiveSalesReportDataSource _dataSource;

  LiveSalesReportBloc({required LiveSalesReportDataSource dataSource})
      : _dataSource = dataSource,
        super(const BaseState<SalesMovementsReportPage>()) {
    on<LoadLiveSalesReport>(_onLoad);
  }

  Future<void> _onLoad(
    LoadLiveSalesReport event,
    Emitter<BaseState<SalesMovementsReportPage>> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    final request = SalesMovementsReportRequest(
      fromDate: event.fromDate,
      toDate: event.toDate,
      branchIds: event.branchIds,
      delegateIds: event.delegateIds,
      allBranchesChecked: event.allBranchesChecked,
      // Sellers feature isn't wired yet — keep "all" true so the server
      // doesn't filter them out by mistake.
      allSalesManChecked: true,
      showSalesManChecked: event.showSalesManChecked,
      weightChecked: event.weightChecked,
      showByBranchCurrencyChecked: event.showByBranchCurrencyChecked,
      cultureName: event.cultureName,
    );

    final result = await _dataSource.getReport(request);
    result.fold(
      (failure) => emit(state.copyWith(
        status: Status.failure,
        errorMessage: failure.message,
      )),
      (data) => emit(state.copyWith(
        status: Status.success,
        items: data.pages,
      )),
    );
  }
}
