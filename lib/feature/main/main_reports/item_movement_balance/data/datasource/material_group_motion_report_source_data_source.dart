import '../../item_movement_balance_import.dart';
abstract class MaterialGroupMotionReportSourceDataSource {
  Future<Either<Failure, List<MaterialGroupMotionReportSourceModel>>>
  getMaterialGroupMotionReportSources();
}

class MaterialGroupMotionReportSourceDataSourceImpl
    implements MaterialGroupMotionReportSourceDataSource {
  final GenericDataSource genericDataSource;

  MaterialGroupMotionReportSourceDataSourceImpl({
    required this.genericDataSource,
  });

  @override
  Future<Either<Failure, List<MaterialGroupMotionReportSourceModel>>>
  getMaterialGroupMotionReportSources() async {
    return genericDataSource
        .fetchData<MaterialGroupMotionReportSourceModel>(
      endpoint: EndPoints.getMaterialGroupMotionReportSources,
      fromJson: MaterialGroupMotionReportSourceModel.fromJson,
    );
  }
}