part of '../sales_imports.dart';

abstract interface class SalesCategoryDataSource {
  Future<Either<Failure, List<SalesCategoryModel>>> getCategories();
}

class SalesCategoryDataSourceImpl implements SalesCategoryDataSource {
  final GenericDataSource _genericDataSource;

  SalesCategoryDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<SalesCategoryModel>>> getCategories() {
    return _genericDataSource.fetchData<SalesCategoryModel>(
      endpoint: EndPoints.getSubCategory,
      fromJson: SalesCategoryModel.fromJson,
    );
  }
}
