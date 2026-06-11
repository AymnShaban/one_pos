part of '../../invoice_collection_imports.dart';

/// Powers the invoice picker screen launched from the collection form's
/// "فاتورة" button. Holds a [BaseState<CollectionInvoiceRowModel>] — same
/// shape the rest of the codebase uses for list/search blocs.
class InvoiceSearchBloc
    extends Bloc<InvoiceSearchEvent, BaseState<CollectionInvoiceRowModel>> {
  final InvoiceCollectionDataSource _dataSource;

  InvoiceSearchBloc({required InvoiceCollectionDataSource dataSource})
      : _dataSource = dataSource,
        super(const BaseState<CollectionInvoiceRowModel>()) {
    on<SearchInvoicesByNumber>(_onByNumber);
    on<SearchInvoicesByName>(_onByName);
    on<LoadAllInvoicesForCustomer>(_onAll);
  }

  Future<void> _onByNumber(
    SearchInvoicesByNumber event,
    Emitter<BaseState<CollectionInvoiceRowModel>> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _dataSource.searchInvoicesByNumber(event.invoiceNo);
    _emit(result, emit);
  }

  Future<void> _onByName(
    SearchInvoicesByName event,
    Emitter<BaseState<CollectionInvoiceRowModel>> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    final result =
        await _dataSource.searchInvoicesByCustomerName(event.name);
    _emit(result, emit);
  }

  Future<void> _onAll(
    LoadAllInvoicesForCustomer event,
    Emitter<BaseState<CollectionInvoiceRowModel>> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _dataSource.getInvoicesByCustomer(event.customerId);
    _emit(result, emit);
  }

  void _emit(
    Either<Failure, List<CollectionInvoiceRowModel>> result,
    Emitter<BaseState<CollectionInvoiceRowModel>> emit,
  ) {
    result.fold(
      (failure) => emit(state.copyWith(
        status: Status.failure,
        errorMessage: failure.message,
      )),
      (items) => emit(state.copyWith(
        status: Status.success,
        items: items,
      )),
    );
  }
}
