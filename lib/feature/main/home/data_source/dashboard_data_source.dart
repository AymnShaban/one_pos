part of '../home_imports.dart';

abstract class DashboardDataSource {
  Future<Either<Failure, DashboardBalancesModel>> getBalances();

}

class DashboardDataSourceImpl implements DashboardDataSource {
  final GenericDataSource _generic;

  DashboardDataSourceImpl(this._generic);

  @override
  Future<Either<Failure, DashboardBalancesModel>> getBalances() {
    return _generic.fetchResult<DashboardBalancesModel>(
      endpoint: EndPoints.getDashboardBalances,
      fromJson: DashboardBalancesModel.fromJson,
    );
  }


}