import '../../receipts_and_payments_movement_report_import.dart';
abstract class VouchersDataSource {
  Future<Either<Failure, EtMovementReportResponseModel>> getReport(
      EtMovementReportRequestModel request,
      );
}

class VouchersDataSourceImpl implements VouchersDataSource {
  final GenericDataSource genericDataSource;

  VouchersDataSourceImpl({required this.genericDataSource});

  @override
  Future<Either<Failure, EtMovementReportResponseModel>> getReport(
      EtMovementReportRequestModel request,
      ) async {
    return genericDataSource.postData(
      endpoint: EndPoints.getVouchersReport,
      data: request.toJson(),
      fromJson: EtMovementReportResponseModel.fromJson,
    );
  }
}
