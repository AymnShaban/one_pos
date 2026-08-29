part of '../live_sales_report_imports.dart';

abstract interface class LiveSalesReportDataSource {
  Future<Either<Failure, SalesMovementsReportResponse>> getReport(
      SalesMovementsReportRequest request,
      );
}

class LiveSalesReportDataSourceImpl implements LiveSalesReportDataSource {
  final GenericDataSource _generic;

  LiveSalesReportDataSourceImpl(this._generic);

  @override
  Future<Either<Failure, SalesMovementsReportResponse>> getReport(
      SalesMovementsReportRequest request,
      ) async {
    return await _generic.postData<SalesMovementsReportResponse>(
      endpoint: EndPoints.salesMovementsReport,
      data: request.toJson(),
      fromJson: (json) => SalesMovementsReportResponse.fromJson(json),
    );
  }
}
