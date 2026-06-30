part of '../../sales_imports.dart';

class SalesBloc extends Bloc<SalesEvent, BaseState<ItemModel>> {
  final SalesDataSource _dataSource;
  late final PaginationHandler<ItemModel, SalesBloc> _paginationHandler;

  // Both ids are required by /api/Product/GetProductsByPatternIdAndGroupIdV1.
  // We hold them locally and refetch whenever either side changes.
  int? _selectedCategoryId;
  int? _selectedPatternId;

  SalesBloc({required SalesDataSource dataSource})
      : _dataSource = dataSource,
        super(const BaseState()) {
    _paginationHandler = PaginationHandler(bloc: this);
    on<FilterByCategory>(_onFilterByCategory);
    on<LoadMoreProducts>(_onLoadMore);
    on<ReloadProducts>(_onReloadProducts);
    on<SetActivePattern>(_onSetActivePattern);
  }

  bool get _isReady =>
      (_selectedCategoryId ?? 0) > 0 && (_selectedPatternId ?? 0) > 0;

  Future<void> _reloadFirstPage() {
    return _paginationHandler.loadFirstPage(
      (page, limit, [params]) => _dataSource.getProducts(
        page: page,
        limit: limit,
        patternId: _selectedPatternId ?? 0,
        groupId: _selectedCategoryId ?? 0,
      ),
    );
  }

  Future<void> _onReloadProducts(
      ReloadProducts event, Emitter<BaseState<ItemModel>> emit) async {
    if (!_isReady) return;
    await _reloadFirstPage();
  }

  Future<void> _onFilterByCategory(
      FilterByCategory event, Emitter<BaseState<ItemModel>> emit) async {
    _selectedCategoryId = event.categoryId;
    if (!_isReady) return;
    await _reloadFirstPage();
  }

  Future<void> _onSetActivePattern(
      SetActivePattern event, Emitter<BaseState<ItemModel>> emit) async {
    _selectedPatternId = event.patternId;
    if (!_isReady) return;
    await _reloadFirstPage();
  }

  Future<void> _onLoadMore(
      LoadMoreProducts event, Emitter<BaseState<ItemModel>> emit) async {
    if (!_isReady) return;
    await _paginationHandler.fetchData(
      (page, limit, [params]) => _dataSource.getProducts(
        page: page,
        limit: limit,
        patternId: _selectedPatternId ?? 0,
        groupId: _selectedCategoryId ?? 0,
      ),
    );
  }
}
