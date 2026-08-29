


import '../../../data/datasource/bill_revenue_report_datasource.dart';
import '../../../invoice_profit_imports.dart';

class InvoiceProfitBloc
    extends Bloc<InvoiceProfitEvent, BaseState<InvoiceProfitResponseModel>> {
  final InvoiceProfitDataSource dataSource;

  InvoiceProfitBloc({
    required this.dataSource,
  }) : super(const BaseState<InvoiceProfitResponseModel>()) {
    on<LoadInvoiceProfitReport>(_onLoadInvoiceProfitReport);
    on<ClearInvoiceProfitReport>(_onClearInvoiceProfitReport);
  }

  Future<void> _onLoadInvoiceProfitReport(
      LoadInvoiceProfitReport event,
      Emitter<BaseState<InvoiceProfitResponseModel>> emit,
      ) async {
    emit(
      state.copyWith(
        status: Status.loading,
        errorMessage: null,
        data: null,
      ),
    );

    final result = await dataSource.getReport(event.request);

    result.fold(
          (failure) => emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: failure.message,
          failure: failure,
        ),
      ),
          (report) => emit(
        state.copyWith(
          status: Status.success,
          data: report,
          errorMessage: null,
          failure: null,
        ),
      ),
    );
  }

  void _onClearInvoiceProfitReport(
      ClearInvoiceProfitReport event,
      Emitter<BaseState<InvoiceProfitResponseModel>> emit,
      ) {
    emit(
      const BaseState<InvoiceProfitResponseModel>(
        status: Status.initial,
      ),
    );
  }
}