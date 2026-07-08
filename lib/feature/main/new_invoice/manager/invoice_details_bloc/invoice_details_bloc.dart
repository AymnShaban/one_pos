part of '../../new_invoice_imports.dart';

class InvoiceDetailsBloc
    extends Bloc<InvoiceDetailsEvent, BaseState<InvoiceDetailsModel>> {
  final NewInvoiceDataSource _dataSource;

  InvoiceDetailsBloc({required NewInvoiceDataSource dataSource})
      : _dataSource = dataSource,
        super(const BaseState<InvoiceDetailsModel>()) {
    on<LoadInvoiceDetails>(_onLoad);
  }

  Future<void> _onLoad(
    LoadInvoiceDetails event,
    Emitter<BaseState<InvoiceDetailsModel>> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await _dataSource.getInvoiceForEdit(
      invoiceId: event.invoiceId,
      invoiceNo: event.invoiceNo,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: Status.failure,
        failure: failure,
        errorMessage: failure.message,
      )),
      (invoice) => emit(state.copyWith(
        status: Status.success,
        data: invoice,
      )),
    );
  }
}
