part of '../new_invoice_imports.dart';



abstract interface class ProductSearchDataSource {
  Future<Either<Failure, List<ItemModel>>> getProductsByCategory({
    required int categoryId,
    required int branchId,
    required int customerId,
    required PaginationParams params,
  });

  Future<Either<Failure, List<ItemModel>>> searchProducts({
    required int page,
    required int limit,
    required int patternId,
    required String search,
  });
  Future<Either<Failure, List<ItemModel>>> searchByBarcode(String barcode);
}

class ProductSearchDataSourceImpl implements ProductSearchDataSource {
  final GenericDataSource _genericDataSource;

  ProductSearchDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<ItemModel>>> getProductsByCategory({
    required int categoryId,
    required int branchId,
    required int customerId,
    required PaginationParams params,
  }) {
    return _genericDataSource.fetchData<ItemModel>(
      endpoint: EndPoints.getProductsByCategory,
      paginationParams: params,
      queryParameters: {
        'categoryId': categoryId,
        'ACID':       customerId,
      },
      fromJson: ItemModel.fromJson,
    );
  }

  @override
  Future<Either<Failure, List<ItemModel>>> searchProducts({
    required int page,
    required int limit,
    required int patternId,
    required String search,
  }) {
    return _genericDataSource.fetchData<ItemModel>(
      endpoint: EndPoints.searchProducts,
      queryParameters: {
        'patternId': patternId,
        'Search': search,
        'Page': page,
        'PageSize': limit,
      },
      fromJson: ItemModel.fromJson,
    );
  }

  @override
  Future<Either<Failure, List<ItemModel>>> searchByBarcode(String barcode) async {
    // New endpoint puts the barcode on the path and returns ONE product
    // object (not a list). We still hand a `List<ItemModel>` back to
    // callers so their existing `items.first`/`items.isEmpty` code keeps
    // working unchanged.
    final result = await _genericDataSource.fetchResult<ItemModel>(
      endpoint: '${EndPoints.productByBarcode}$barcode',
      fromJson: ItemModel.fromJson,
    );
    return result.fold(
      (failure) => Left(failure),
      (item) => Right([item]),
    );
  }
}