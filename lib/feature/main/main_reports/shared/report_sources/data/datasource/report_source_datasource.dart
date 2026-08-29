import '../../../shared_imports.dart';
abstract class ReportSourceDataSource {
  Future<Either<Failure, List<ReportSourceModel>>> getReportSources();
}

class ReportSourceDataSourceImpl implements ReportSourceDataSource {
  final GenericDataSource genericDataSource;

  ReportSourceDataSourceImpl({required this.genericDataSource});

  @override
  Future<Either<Failure, List<ReportSourceModel>>> getReportSources() async {
    return genericDataSource.fetchData<ReportSourceModel>(
      endpoint: EndPoints.getReportSources,
      fromJson: ReportSourceModel.fromJson,
    );
  }
}
