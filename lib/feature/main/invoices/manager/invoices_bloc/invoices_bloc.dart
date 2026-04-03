part of '../../invoices_imports.dart';

class InvoicesBloc extends Bloc<InvoicesEvent, BaseState<InvoiceModel>> {
  final InvoicesDataSource _dataSource;
  late final PaginationHandler<InvoiceModel, InvoicesBloc> _paginationHandler;

  String? _searchQuery;
  InvoiceStatus _selectedStatus = InvoiceStatus.all;

  InvoicesBloc({required InvoicesDataSource dataSource})
      : _dataSource = dataSource,
        super(const BaseState()) {
    _paginationHandler = PaginationHandler(bloc: this);
    on<FetchInvoices>(_onFetch);
    on<SearchInvoices>(_onSearch);
    on<FilterInvoicesByStatus>(_onFilterByStatus);
    on<LoadMoreInvoices>(_onLoadMore);
    on<DeleteInvoice>(_onDelete);
  }

  InvoiceStatus get selectedStatus => _selectedStatus;

  Future<void> _onFetch(
      FetchInvoices event,
      Emitter<BaseState<InvoiceModel>> emit,
      ) async {
    await _paginationHandler.loadFirstPage(_fetchFn);
  }

  Future<void> _onSearch(
      SearchInvoices event,
      Emitter<BaseState<InvoiceModel>> emit,
      ) async {
    _searchQuery = event.query;
    await _paginationHandler.loadFirstPage(_fetchFn);
  }

  Future<void> _onFilterByStatus(
      FilterInvoicesByStatus event,
      Emitter<BaseState<InvoiceModel>> emit,
      ) async {
    _selectedStatus = event.status;
    await _paginationHandler.loadFirstPage(_fetchFn);
  }

  Future<void> _onLoadMore(
      LoadMoreInvoices event,
      Emitter<BaseState<InvoiceModel>> emit,
      ) async {
    await _paginationHandler.fetchData(_fetchFn);
  }

  Future<void> _onDelete(
      DeleteInvoice event,
      Emitter<BaseState<InvoiceModel>> emit,
      ) async {
    final result = await _dataSource.deleteInvoice(event.invoiceId);
    result.fold(
          (failure) => emit(state.copyWith(
        status: Status.failure,
        errorMessage: failure.message,
      )),
          (_) {
        final updated = state.items
            .where((inv) => inv.invoiceId != event.invoiceId)
            .toList();
        emit(state.copyWith(status: Status.success, items: updated));
      },
    );
  }

  PaginateFunc<InvoiceModel> get _fetchFn =>
          (page, limit, [params]) => _dataSource.getInvoices(
        page: page,
        limit: limit,
        search: _searchQuery,
        status: _selectedStatus.apiValue,
      );
}