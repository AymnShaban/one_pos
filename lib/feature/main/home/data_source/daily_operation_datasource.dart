part of '../home_imports.dart';



abstract class DailyOperationDataSource {
  Future<Either<Failure, List<DailyOperationModel>>> getDailyOperations();
}

class DailyOperationDataSourceImpl implements DailyOperationDataSource {
  final GenericDataSource _generic;

  DailyOperationDataSourceImpl(this._generic);

  @override
  Future<Either<Failure, List<DailyOperationModel>>> getDailyOperations() {
    return _generic.fetchData<DailyOperationModel>(
      endpoint: EndPoints.getDailyOperation,
      fromJson: DailyOperationModel.fromJson,
    );
  }
}