part of '../sales_imports.dart';

abstract interface class SalesDataSource {
  Future<Either<Failure, List<ItemModel>>> getProducts({
    required int page,
    required int limit,
    required int patternId,
    required int groupId,
  });
}

class SalesDataSourceImpl implements SalesDataSource {
  final GenericDataSource _genericDataSource;

  SalesDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<ItemModel>>> getProducts({
    required int page,
    required int limit,
    required int patternId,
    required int groupId,
  }) {
    return _genericDataSource.fetchData<ItemModel>(
      endpoint: EndPoints.subCategoryProducts,
      queryParameters: {
        'patternId': patternId,
        'groupId': groupId,
        // TODO: server-side pagination not wired yet — add `page`/`pageSize`
        //       (or whatever the endpoint accepts) here once supported.
        // 'page': page,
        // 'pageSize': limit,
      },
      fromJson: ItemModel.fromJson,
    );
  }
}
