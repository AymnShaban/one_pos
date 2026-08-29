import '../../invoice_profit_imports.dart';

abstract class InvoiceProfitDataSource {
  Future<Either<Failure, InvoiceProfitResponseModel>> getReport(
      BillRevenueRequestModel request,
      );
}

class InvoiceProfitDataSourceImpl implements InvoiceProfitDataSource {
  final GenericDataSource genericDataSource;

  InvoiceProfitDataSourceImpl({
    required this.genericDataSource,
  });

  @override
  Future<Either<Failure, InvoiceProfitResponseModel>> getReport(
      BillRevenueRequestModel request,
      ) async {
    return await genericDataSource.postData(
      endpoint: EndPoints.getInvoiceProfitReport,
      data: request.toJson(),
      fromJson: InvoiceProfitResponseModel.fromJson,
    );
  }
}