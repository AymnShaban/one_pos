part of '../home_imports.dart';

abstract class TopSellingDataSource {
  Future<Either<Failure, List<TopSellingItemModel>>> getTopSellingItems({
    int top = 5,
    String sortBy = 'qty',
  });
}

class TopSellingDataSourceImpl implements TopSellingDataSource {
  final GenericDataSource _generic;

  TopSellingDataSourceImpl(this._generic);

  @override
  Future<Either<Failure, List<TopSellingItemModel>>> getTopSellingItems({
    int top = 10,
    String sortBy = 'qty',
  }) {
    return _generic.fetchData<TopSellingItemModel>(
      endpoint: EndPoints.getTopSellingItems,
      queryParameters: {
        'top': top,
        'sortBy': sortBy,
      },
      fromJson: (json) => TopSellingItemModel.fromJson(json),
    );
  }
}