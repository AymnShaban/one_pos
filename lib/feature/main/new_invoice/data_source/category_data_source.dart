part of '../new_invoice_imports.dart';

abstract interface class CategoryDataSource {
  Future<Either<Failure, List<CategoryModel>>> getMainCategories();
  Future<Either<Failure, List<CategoryModel>>> getSubCategories(int parentId);
}

class CategoryDataSourceImpl implements CategoryDataSource {
  final GenericDataSource _genericDataSource;

  CategoryDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<CategoryModel>>> getMainCategories() {
    return _genericDataSource.fetchData<CategoryModel>(
      endpoint: EndPoints.getMainCategory,
      fromJson: CategoryModel.fromJson,
    );
  }

  @override
  Future<Either<Failure, List<CategoryModel>>> getSubCategories(int parentId) {
    return _genericDataSource.fetchData<CategoryModel>(
      endpoint: EndPoints.getSubCategory,
      queryParameters: {'Parent': parentId},
      fromJson: CategoryModel.fromJson,
    );
  }
}