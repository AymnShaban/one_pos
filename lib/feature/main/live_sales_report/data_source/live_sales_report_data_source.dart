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
    final result = await _generic.postData<String>(
      endpoint: EndPoints.salesMovementsReport,
      data: request.toJson(),
    );
    return result.fold(
      (failure) => Left(failure),
      (jsonStr) {
        try {
          final map = jsonDecode(jsonStr) as Map<String, dynamic>;
          return Right(SalesMovementsReportResponse.fromJson(map));
        } catch (e) {
          return Left(
            ParsingFailure(message: 'Could not parse report: $e'),
          );
        }
      },
    );
  }
}
