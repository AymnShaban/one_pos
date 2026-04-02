import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/bloc/paginated_bloc/paginated_bloc.dart';
import '../../../../../core/helper/paginatation_helper.dart';
import '../../../../../core/models/item_model.dart';
import '../../data_source/sales_data_source.dart';
import 'sales_event.dart';

class SalesBloc extends Bloc<SalesEvent, BaseState<ItemModel>> {
  final SalesDataSource _dataSource;
  late final PaginationHandler<ItemModel, SalesBloc> _paginationHandler;

  String? _searchQuery;
  String? _selectedCategoryId;

  SalesBloc({required SalesDataSource dataSource})
      : _dataSource = dataSource,
        super(const BaseState()) {
    _paginationHandler = PaginationHandler(bloc: this);
    on<FetchProducts>(_onFetch);
    on<SearchProducts>(_onSearch);
    on<FilterByCategory>(_onFilterByCategory);
    on<LoadMoreProducts>(_onLoadMore);
  }

  Future<void> _onFetch(FetchProducts event, Emitter<BaseState<ItemModel>> emit) async {
    await _paginationHandler.loadFirstPage(
          (page, limit, [params]) => _dataSource.getProducts(
        page: page,
        limit: limit,
        search: _searchQuery,
        categoryId: _selectedCategoryId,
      ),
    );
  }

  Future<void> _onSearch(SearchProducts event, Emitter<BaseState<ItemModel>> emit) async {
    _searchQuery = event.query;
    await _paginationHandler.loadFirstPage(
          (page, limit, [params]) => _dataSource.getProducts(
        page: page,
        limit: limit,
        search: _searchQuery,
        categoryId: _selectedCategoryId,
      ),
    );
  }

  Future<void> _onFilterByCategory(FilterByCategory event, Emitter<BaseState<ItemModel>> emit) async {
    _selectedCategoryId = event.categoryId;
    await _paginationHandler.loadFirstPage(
          (page, limit, [params]) => _dataSource.getProducts(
        page: page,
        limit: limit,
        search: _searchQuery,
        categoryId: _selectedCategoryId,
      ),
    );
  }

  Future<void> _onLoadMore(LoadMoreProducts event, Emitter<BaseState<ItemModel>> emit) async {
    await _paginationHandler.fetchData(
          (page, limit, [params]) => _dataSource.getProducts(
        page: page,
        limit: limit,
        search: _searchQuery,
        categoryId: _selectedCategoryId,
      ),
    );
  }
}