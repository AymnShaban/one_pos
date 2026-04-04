part of '../new_invoice_imports.dart';

abstract interface class NewInvoiceDataSource {
  Future<Either<Failure, List<PaymentWayModel>>> getPayWays();
  Future<Either<Failure, int>> getLastInvoiceId(int patternId);
  Future<Either<Failure, String>> createInvoice(CreateInvoiceRequest request);
  Future<Either<Failure, String>> editInvoice(EditInvoiceRequest request);
}

class NewInvoiceDataSourceImpl implements NewInvoiceDataSource {
  final GenericDataSource _genericDataSource;

  NewInvoiceDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<PaymentWayModel>>> getPayWays() {
    return _genericDataSource.fetchData<PaymentWayModel>(
      endpoint: EndPoints.getPayWays,
      fromJson: PaymentWayModel.fromJson,
    );
  }

  @override
  Future<Either<Failure, int>> getLastInvoiceId(int patternId) async {
    final result = await _genericDataSource.fetchResult<String>(
      endpoint: EndPoints.getLastInvoiceByPattern,
      queryParameters: {'InvoiceID': patternId},
    );
    return result.fold(
          (failure) => Left(failure),
          (data) => Right((int.tryParse(data) ?? 0) + 1),
    );
  }

  @override
  Future<Either<Failure, String>> createInvoice(
      CreateInvoiceRequest request) {
    return _genericDataSource.postData<String>(
      endpoint: EndPoints.createSalesInvoice,
      data:     request.toJson(),
    );
  }

  @override
  Future<Either<Failure, String>> editInvoice(EditInvoiceRequest request) {
    return _genericDataSource.updateData<String>(
      endpoint: EndPoints.editSalesInvoice,
      data:     request.toJson(),
    );
  }
}