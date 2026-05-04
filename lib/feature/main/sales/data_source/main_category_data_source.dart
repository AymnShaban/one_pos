part of '../sales_imports.dart';

abstract interface class MainCategoryDataSource {
  Future<Either<Failure, List<MainCategoryModel>>> getMainCategories();
}

class MainCategoryDataSourceImpl implements MainCategoryDataSource {
  final GenericDataSource _genericDataSource;

  MainCategoryDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<MainCategoryModel>>> getMainCategories() {
    return _genericDataSource.fetchData<MainCategoryModel>(
      endpoint: EndPoints.getMainCategory,
      fromJson: MainCategoryModel.fromJson,
    );
  }
}
