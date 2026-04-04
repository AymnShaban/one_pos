part of '../../new_invoice_imports.dart';

class ProductBloc extends PaginatedBloc<ItemModel> {
  final ProductSearchDataSource _dataSource;

  ProductBloc({required ProductSearchDataSource dataSource})
      : _dataSource = dataSource,
        super(
        fetchPage: (page, limit, query, params) =>
            dataSource.getProductsByCategory(
              categoryId: params?['categoryId'] ?? 0,
              branchId:   params?['branchId']   ?? 0,
              customerId: params?['customerId']  ?? -1,
              params:     PaginationParams(page: page, limit: limit),
            ),
        cacheKeyBuilder: (_, params) =>
        'products_cat_${params?['categoryId']}_branch_${params?['branchId']}',
      );
}