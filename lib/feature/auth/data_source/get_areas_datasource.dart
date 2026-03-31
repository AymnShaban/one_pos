import '../../../../../core/constant/end_points.dart';
import '../../../../../core/datasource/generic_data_source.dart';
import '../../../../../core/helper/logger.dart';
import '../../../../../core/http/either.dart';
import '../../../../../core/http/failure.dart';
import '../models/areas_model.dart';
import '../models/governorates_model.dart';

abstract interface class GetAreasDataSource {
  Future<Either<Failure, List<AreasModel>>> getAreas();
  Future<Either<Failure, List<GovernoratesModel>>> getGovernorates();
  Future<Either<Failure, List<AreasModel>>> getAreasByGovernorateId({required int governorateId});
}


class GetAreasDataSourceImpl implements GetAreasDataSource {
  final GenericDataSource _dataSource;
  GetAreasDataSourceImpl(this._dataSource);
  @override
  Future<Either<Failure, List<AreasModel>>> getAreas() {
    final result = _dataSource.fetchData<AreasModel>(
      endpoint: EndPoints.getAreas,
      fromJson: AreasModel.fromJson,
    );
    loggerInfo(result);

    return result;
  }

  @override
  Future<Either<Failure, List<GovernoratesModel>>> getGovernorates() {
    final result = _dataSource.fetchData<GovernoratesModel>(
      endpoint: EndPoints.governorates,
      fromJson: GovernoratesModel.fromJson,
    );
    return result;
  }

  @override
  Future<Either<Failure, List<AreasModel>>> getAreasByGovernorateId({required int governorateId}) {
      final result = _dataSource.fetchData<AreasModel>(
      endpoint: "${EndPoints.getAreaByGovernorateId}?GovernorateId=$governorateId",
      fromJson: AreasModel.fromJson,
    );
    return result;
  }
}
