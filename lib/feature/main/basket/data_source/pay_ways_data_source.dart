part of '../basket_imports.dart';

abstract interface class PayWaysDataSource {
  Future<Either<Failure, List<PayWayModel>>> getPayWays();
}

class PayWaysDataSourceImpl implements PayWaysDataSource {
  final GenericDataSource _genericDataSource;

  PayWaysDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<PayWayModel>>> getPayWays() {
    return _genericDataSource.fetchData<PayWayModel>(
      endpoint: EndPoints.getPayWays,
      fromJson: PayWayModel.fromJson,
    );
  }
}
