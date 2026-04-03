part of '../../reports_imports.dart';

class ReportsBloc extends Bloc<ReportsEvent, BaseState<ReportSummaryModel>> {
  final ReportsDataSource _dataSource;

  ReportType  _selectedType   = ReportType.dailySales;
  ReportPeriod _selectedPeriod = ReportPeriod.today;

  ReportsBloc({required ReportsDataSource dataSource})
      : _dataSource = dataSource,
        super(const BaseState()) {
    on<FetchReport>(_onFetch);
    on<ChangeReportType>(_onChangeType);
    on<ChangeReportPeriod>(_onChangePeriod);
    on<ExportReportPdf>(_onExport);
  }

  ReportType   get selectedType   => _selectedType;
  ReportPeriod get selectedPeriod => _selectedPeriod;

  Future<void> _onFetch(
      FetchReport event,
      Emitter<BaseState<ReportSummaryModel>> emit,
      ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await _dataSource.getReport(
      type:   _selectedType.apiValue,
      period: _selectedPeriod.apiValue,
    );

    result.fold(
          (failure) => emit(state.copyWith(
        status:       Status.failure,
        errorMessage: failure.message,
      )),
          (data) => emit(state.copyWith(
        status: Status.success,
        items:  [data],
      )),
    );
  }

  Future<void> _onChangeType(
      ChangeReportType event,
      Emitter<BaseState<ReportSummaryModel>> emit,
      ) async {
    _selectedType = event.type;
    add(const FetchReport());
  }

  Future<void> _onChangePeriod(
      ChangeReportPeriod event,
      Emitter<BaseState<ReportSummaryModel>> emit,
      ) async {
    _selectedPeriod = event.period;
    add(const FetchReport());
  }

  void _onExport(
      ExportReportPdf event,
      Emitter<BaseState<ReportSummaryModel>> emit,
      ) {
    // PDF export logic goes here
  }
}