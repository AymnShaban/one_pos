part of '../new_invoice_imports.dart';



abstract interface class ProductSearchDataSource {
  Future<Either<Failure, List<ItemModel>>> getProductsByCategory({
    required int categoryId,
    required int branchId,
    required int customerId,
    required PaginationParams params,
  });

  Future<Either<Failure, List<ItemModel>>> searchProducts(String searchKey);
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
        'GBranchID':  branchId,
        'ACID':       customerId,
      },
      fromJson: ItemModel.fromJson,
    );
  }

  @override
  Future<Either<Failure, List<ItemModel>>> searchProducts(String searchKey) {
    return _genericDataSource.fetchData<ItemModel>(
      endpoint: EndPoints.searchProducts,
      queryParameters: {'searchKey': searchKey},
      fromJson: ItemModel.fromJson,
    );
  }

  @override
  Future<Either<Failure, List<ItemModel>>> searchByBarcode(String barcode) {
    return _genericDataSource.fetchData<ItemModel>(
      endpoint: EndPoints.searchProductByBarcode,
      queryParameters: {'Barcode': barcode},
      fromJson: ItemModel.fromJson,
    );
  }
}