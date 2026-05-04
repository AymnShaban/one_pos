part of '../sales_imports.dart';

abstract interface class SubCategoryDataSource {
  Future<Either<Failure, List<SubCategoryModel>>> getSubCategories({
    required int parentCategoryId,
    int branchId,
  });
}

class SubCategoryDataSourceImpl implements SubCategoryDataSource {
  final GenericDataSource _genericDataSource;

  SubCategoryDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<SubCategoryModel>>> getSubCategories({
    required int parentCategoryId,
    int branchId = 1,
  }) {
    return _genericDataSource.fetchData<SubCategoryModel>(
      endpoint: EndPoints.getSubCategory,
      queryParameters: {
        'Parent': parentCategoryId,
        'GBranchID': branchId,
      },
      fromJson: SubCategoryModel.fromJson,
    );
  }
}
