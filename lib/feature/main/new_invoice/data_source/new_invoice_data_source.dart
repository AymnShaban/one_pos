part of '../new_invoice_imports.dart';

abstract interface class NewInvoiceDataSource {
  Future<Either<Failure, List<PaymentWayModel>>> getPayWays();
  Future<Either<Failure, int>> getLastInvoiceId(int patternId);
  Future<Either<Failure, String>> createInvoice(CreateInvoiceRequest request);
  Future<Either<Failure, String>> editInvoice(EditInvoiceRequest request);
  Future<Either<Failure, InvoiceDetailsModel>> getInvoiceForEdit({
    required int invoiceId,
    required int invoiceNo,
  });
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
    debugPrint("Creating invoice with data: ${request.toJson()}");
    return _genericDataSource.postData<String>(
      endpoint: EndPoints.createSalesInvoice,
      data:    {
        "invoiceID":           request.invoicePatternId,
        "invoiceDate":        request. invoiceDate,
        "companyBranchID":     request.companyBranchId,
        "remainder":          request. remainder,
        "prePaid":            request. prePaid,
        "currencyID":        request.  currencyId,
        "rate":              request.  currencyRate,
        "customerID":        request.  customerId,
        "totalValue":        request.  totalValue,
        "totalAddition":      request. totalAddition,
        "totalDiscount":      request. totalDiscount,
        "finalValue":         request. finalValue,
        "payingType":        request.  payingType,
        "salesInvoiceItems":  request. items.map((e) => e.toInvoiceJson()).toList(),
        "salesInvoicePayWays":request. payWays.map((e) => e.toJson()).toList(),
        "address":            request. address,
        "createdBy":          request. createdBy,
        "latitude":           request. latitude,
        "longitude":          request. longitude,
      } ,
    );
  }

  @override
  Future<Either<Failure, String>> editInvoice(EditInvoiceRequest request) {
    return _genericDataSource.updateData<String>(
      endpoint: EndPoints.editSalesInvoice,
      data:     request.toJson(),
    );
  }

  @override
  Future<Either<Failure, InvoiceDetailsModel>> getInvoiceForEdit({
    required int invoiceId,
    required int invoiceNo,
  }) {
    return _genericDataSource.fetchResult<InvoiceDetailsModel>(
      endpoint: EndPoints.getInvoiceForEdit,
      queryParameters: {
        'invoiceId': invoiceId,
        'invoiceNo': invoiceNo,
      },
      fromJson: InvoiceDetailsModel.fromJson,
    );
  }
}