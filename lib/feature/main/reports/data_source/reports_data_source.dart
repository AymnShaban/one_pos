part of '../reports_imports.dart';


abstract interface class ReportsDataSource {
  Future<Either<Failure, ReportSummaryModel>> getReport({
    required String type,
    required String period,
  });
}

class ReportsDataSourceImpl implements ReportsDataSource {
  final GenericDataSource _genericDataSource;

  ReportsDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, ReportSummaryModel>> getReport({
    required String type,
    required String period,
  }) {
    return _genericDataSource.fetchResult<ReportSummaryModel>(
      endpoint: EndPoints.getReport,
      queryParameters: {
        'type':   type,
        'period': period,
      },
      fromJson: ReportSummaryModel.fromJson,
    );
  }
}