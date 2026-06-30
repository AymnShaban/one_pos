part of '../invoice_setup_imports.dart';

abstract interface class InvoiceSetupDataSource {
  /// Branch-scoped patterns. The server narrows the result to the given
  /// branch — callers don't need to filter by `branchId` on the client.
  Future<Either<Failure, List<InvoicePatternModel>>> getPatternsByBranch(
    int branchId,
  );

  Future<Either<Failure, List<CurrencyModel>>> getCurrencies();
}

class InvoiceSetupDataSourceImpl implements InvoiceSetupDataSource {
  final GenericDataSource _genericDataSource;

  InvoiceSetupDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<InvoicePatternModel>>> getPatternsByBranch(
    int branchId,
  ) {
    return _genericDataSource.fetchData<InvoicePatternModel>(
      endpoint: EndPoints.getInvoiceSettingByBranch,
      queryParameters: {'branchId': branchId},
      fromJson: InvoicePatternModel.fromJson,
    );
  }

  @override
  Future<Either<Failure, List<CurrencyModel>>> getCurrencies() {
    return _genericDataSource.fetchData<CurrencyModel>(
      endpoint: EndPoints.getCurrencies,
      fromJson: CurrencyModel.fromJson,
    );
  }
}
