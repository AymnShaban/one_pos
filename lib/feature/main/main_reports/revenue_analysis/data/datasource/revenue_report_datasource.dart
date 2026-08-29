import '../../revenue_analysis_import.dart';
abstract class RevenueReportDataSource {
  Future<Either<Failure, RevenueReportResponseModel>> getReport(
      RevenueReportRequestModel request,
      );
}

class RevenueReportDataSourceImpl implements RevenueReportDataSource {
  final GenericDataSource genericDataSource;

  RevenueReportDataSourceImpl({required this.genericDataSource});

  @override
  Future<Either<Failure, RevenueReportResponseModel>> getReport(
      RevenueReportRequestModel request,
      ) async {
    return genericDataSource.postData<RevenueReportResponseModel>(
      endpoint: EndPoints.revenueReport,
 data: request.toJson(),
      fromJson: (json) => RevenueReportResponseModel.fromJson(json),
    );
  }
}