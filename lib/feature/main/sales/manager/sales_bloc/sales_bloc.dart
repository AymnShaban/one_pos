part of '../../sales_imports.dart';

class SalesBloc extends Bloc<SalesEvent, BaseState<ItemModel>> {
  final SalesDataSource _dataSource;
  late final PaginationHandler<ItemModel, SalesBloc> _paginationHandler;

  int? _selectedCategoryId;

  SalesBloc({required SalesDataSource dataSource})
      : _dataSource = dataSource,
        super(const BaseState()) {
    _paginationHandler = PaginationHandler(bloc: this);
    on<FilterByCategory>(_onFilterByCategory);
    on<LoadMoreProducts>(_onLoadMore);
  }

  Future<void> _onFilterByCategory(
      FilterByCategory event, Emitter<BaseState<ItemModel>> emit) async {
    _selectedCategoryId = event.categoryId;
    await _paginationHandler.loadFirstPage(
      (page, limit, [params]) => _dataSource.getProducts(
        page: page,
        limit: limit,
        categoryId: _selectedCategoryId ?? 0,
      ),
    );
  }

  Future<void> _onLoadMore(
      LoadMoreProducts event, Emitter<BaseState<ItemModel>> emit) async {
    await _paginationHandler.fetchData(
      (page, limit, [params]) => _dataSource.getProducts(
        page: page,
        limit: limit,
        categoryId: _selectedCategoryId ?? 0,
      ),
    );
  }
}
