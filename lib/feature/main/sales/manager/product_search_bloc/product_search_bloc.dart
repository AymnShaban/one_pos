part of '../../sales_imports.dart';

class ProductSearchBloc extends Bloc<ProductSearchEvent, BaseState<ItemModel>> {
  final ProductSearchDataSource _dataSource;
  final int patternId;
  late final PaginationHandler<ItemModel, ProductSearchBloc> _paginationHandler;
  String _query = '';

  ProductSearchBloc({
    required ProductSearchDataSource dataSource,
    required this.patternId,
  })  : _dataSource = dataSource,
        super(const BaseState()) {
    _paginationHandler = PaginationHandler(bloc: this);
    on<SearchProducts>(_onSearch);
    on<LoadMoreSearchResults>(_onLoadMore);
  }

  Future<void> _onSearch(
      SearchProducts event, Emitter<BaseState<ItemModel>> emit) async {
    _query = event.query.trim();
    if (_query.isEmpty) {
      emit(const BaseState<ItemModel>(status: Status.success, items: []));
      return;
    }
    await _paginationHandler.loadFirstPage(
      (page, limit, [params]) => _dataSource.searchProducts(
        page: page,
        limit: limit,
        patternId: patternId,
        search: _query,
      ),
    );
  }

  Future<void> _onLoadMore(
      LoadMoreSearchResults event, Emitter<BaseState<ItemModel>> emit) async {
    if (_query.isEmpty) return;
    await _paginationHandler.fetchData(
      (page, limit, [params]) => _dataSource.searchProducts(
        page: page,
        limit: limit,
        patternId: patternId,
        search: _query,
      ),
    );
  }
}
