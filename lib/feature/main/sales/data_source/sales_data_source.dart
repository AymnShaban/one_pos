part of '../sales_imports.dart';

abstract interface class SalesDataSource {
  Future<Either<Failure, List<ItemModel>>> getProducts({
    required int page,
    required int limit,
    String? search,
    String? categoryId,
  });
}

class SalesDataSourceImpl implements SalesDataSource {
  final GenericDataSource _genericDataSource;

  SalesDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<ItemModel>>> getProducts({
    required int page,
    required int limit,
    String? search,
    String? categoryId,
  }) {
    return _genericDataSource.fetchData<ItemModel>(
      endpoint: EndPoints.subCategoryProducts,
      paginationParams: PaginationParams(page: page, limit: limit),
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (categoryId != null && categoryId.isNotEmpty) 'categoryId': categoryId,
      },
      fromJson: ItemModel.fromJson,
    );
  }
}