part of '../sales_imports.dart';

abstract interface class SalesDataSource {
  Future<Either<Failure, List<ItemModel>>> getProducts({
    required int page,
    required int limit,
   required int categoryId,
  });
}

class SalesDataSourceImpl implements SalesDataSource {
  final GenericDataSource _genericDataSource;

  SalesDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<ItemModel>>> getProducts({
    required int page,
    required int limit,
   required int categoryId,
  }) {
    return _genericDataSource.fetchData<ItemModel>(
      endpoint: EndPoints.subCategoryProducts,
      paginationParams: PaginationParams(page: page, limit: limit),
      queryParameters: {
      'categoryId': categoryId,
      },
      fromJson: ItemModel.fromJson,
    );
  }
}
