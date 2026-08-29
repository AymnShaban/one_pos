part of '../home_imports.dart';

abstract class LowStockDataSource {
  Future<Either<Failure, List<LowStockItemModel>>> getLowStockItems({
    int top = 5,
  });
}

class LowStockDataSourceImpl implements LowStockDataSource {
  final GenericDataSource _generic;

  LowStockDataSourceImpl(this._generic);

  @override
  Future<Either<Failure, List<LowStockItemModel>>> getLowStockItems({
    int top = 5,
  }) {
    return _generic.fetchData<LowStockItemModel>(
      endpoint: EndPoints.getLowStockItems,
      queryParameters: {
        'top': top,
      },
      fromJson: (json) => LowStockItemModel.fromJson(json),
    );
  }
}