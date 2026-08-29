import '../../../shared_imports.dart';
abstract class CostCentersDataSource {
  Future<Either<Failure, List<CostCenterModel>>> getCostCenters();
}

class CostCentersDataSourceImpl implements CostCentersDataSource {
  final GenericDataSource genericDataSource;

  CostCentersDataSourceImpl({required this.genericDataSource});

  @override
  Future<Either<Failure, List<CostCenterModel>>> getCostCenters() async {
    return genericDataSource.fetchData<CostCenterModel>(
      endpoint: EndPoints.getInvoiceProfitCostCenters,

      fromJson: CostCenterModel.fromJson,
    );
  }
}