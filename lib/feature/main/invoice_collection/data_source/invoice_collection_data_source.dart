part of '../invoice_collection_imports.dart';

abstract interface class InvoiceCollectionDataSource {
  Future<Either<Failure, List<BondTypeModel>>> getBondTypes();
  Future<Either<Failure, List<BondTypeModel>>> getBondTypesByBranch(
      int branchId);
  Future<Either<Failure, List<Map<String, dynamic>>>> getCurrencies();
  Future<Either<Failure, List<Map<String, dynamic>>>> getPayWays();

  Future<Either<Failure, VoucherResponseModel>> addCollection(
      CollectionRequestModel request);
  Future<Either<Failure, VoucherResponseModel>> editCollection(
      CollectionRequestModel request);

  // ── Invoice picker (the "فاتورة" button on the collection screen). The
  // three modes mirror the old InvoiceSearchCubit so by-number / by-name /
  // all-for-customer all stay accessible.
  Future<Either<Failure, List<CollectionInvoiceRowModel>>>
      searchInvoicesByNumber(String invoiceNo);
  Future<Either<Failure, List<CollectionInvoiceRowModel>>>
      searchInvoicesByCustomerName(String name);
  Future<Either<Failure, List<CollectionInvoiceRowModel>>>
      getInvoicesByCustomer(int customerId);
}

/// Routes every call through [GenericDataSource] so the shared Dio's auth
/// header + encryption interceptor are honoured — same convention every
/// other data source in the app follows. The old implementation built its
/// own `Dio(BaseOptions(baseUrl: ...))` which skipped both.
class InvoiceCollectionDataSourceImpl implements InvoiceCollectionDataSource {
  final GenericDataSource _generic;

  InvoiceCollectionDataSourceImpl(this._generic);

  @override
  Future<Either<Failure, List<BondTypeModel>>> getBondTypes() {
    return _generic.fetchData<BondTypeModel>(
      endpoint: '/${EndPoints.getReceiptsVouchersTypes}',
      fromJson: BondTypeModel.fromJson,
    );
  }

  @override
  Future<Either<Failure, List<BondTypeModel>>> getBondTypesByBranch(
      int branchId) {
    return _generic.fetchData<BondTypeModel>(
      endpoint: '/${EndPoints.getReceiptsVouchersTypesByBranch}',
      queryParameters: {'BranchID': branchId},
      fromJson: BondTypeModel.fromJson,
    );
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getCurrencies() {
    return _generic.fetchData<Map<String, dynamic>>(
      endpoint: EndPoints.getCurrencies,
      fromJson: (json) => json,
    );
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getPayWays() {
    return _generic.fetchData<Map<String, dynamic>>(
      endpoint: EndPoints.getPayWays,
      fromJson: (json) => json,
    );
  }

  @override
  Future<Either<Failure, VoucherResponseModel>> addCollection(
      CollectionRequestModel request) async {
    final result = await _generic.postData<String>(
      endpoint: '/${EndPoints.invoiceCollecting}',
      data: request.toMap(),
    );
    return result.fold(
      (failure) => Left(failure),
      (jsonStr) {
        try {
          final map = jsonDecode(jsonStr) as Map<String, dynamic>;
          return Right(VoucherResponseModel.fromJson(map));
        } catch (e) {
          return Left(ParsingFailure(
              message: 'Could not parse voucher response: $e'));
        }
      },
    );
  }

  @override
  Future<Either<Failure, VoucherResponseModel>> editCollection(
      CollectionRequestModel request) async {
    final result = await _generic.updateData<String>(
      endpoint: '/${EndPoints.updateInvoiceCollecting}',
      data: request.toMap(),
    );
    return result.fold(
      (failure) => Left(failure),
      (jsonStr) {
        try {
          final map = jsonDecode(jsonStr) as Map<String, dynamic>;
          return Right(VoucherResponseModel.fromJson(map));
        } catch (e) {
          return Left(ParsingFailure(
              message: 'Could not parse voucher response: $e'));
        }
      },
    );
  }

  // ── Invoice picker ────────────────────────────────────────────────────
  @override
  Future<Either<Failure, List<CollectionInvoiceRowModel>>>
      searchInvoicesByNumber(String invoiceNo) {
    return _generic.fetchData<CollectionInvoiceRowModel>(
      endpoint: '/${EndPoints.getSalesInvoiceByNumber}',
      queryParameters: {'InvoiceNo': invoiceNo},
      fromJson: CollectionInvoiceRowModel.fromJson,
    );
  }

  @override
  Future<Either<Failure, List<CollectionInvoiceRowModel>>>
      searchInvoicesByCustomerName(String name) {
    return _generic.fetchData<CollectionInvoiceRowModel>(
      endpoint: '/${EndPoints.getSalesInvoiceByCustomerName}',
      queryParameters: {'CustomerName': name},
      fromJson: CollectionInvoiceRowModel.fromJson,
    );
  }

  @override
  Future<Either<Failure, List<CollectionInvoiceRowModel>>>
      getInvoicesByCustomer(int customerId) {
    return _generic.fetchData<CollectionInvoiceRowModel>(
      endpoint: '/${EndPoints.getAllSalesInvoicesByCustomerId}',
      queryParameters: {'CustomerID': customerId},
      fromJson: CollectionInvoiceRowModel.fromJson,
    );
  }
}
