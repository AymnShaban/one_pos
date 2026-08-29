import '../../items_movement_import.dart';
abstract class MTIReportSourceDataSource {
  Future<Either<Failure, List<MTIReportSourceModel>>> getReportSources();
}

class MTIReportSourceDataSourceImpl
    implements MTIReportSourceDataSource {
  final GenericDataSource genericDataSource;

  MTIReportSourceDataSourceImpl({
    required this.genericDataSource,
  });

  @override
  Future<Either<Failure, List<MTIReportSourceModel>>>
  getReportSources() async {
    return genericDataSource.fetchData<MTIReportSourceModel>(
      endpoint: EndPoints.getReportSourcesMti,
      fromJson: MTIReportSourceModel.fromJson,
    );
  }
}