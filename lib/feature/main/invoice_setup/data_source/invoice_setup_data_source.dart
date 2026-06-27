part of '../invoice_setup_imports.dart';

abstract interface class InvoiceSetupDataSource {
  /// Returns every pattern across all categories. Callers filter
  /// client-side by branch ([InvoicePatternModel.branchId]), category
  /// ([PatternCategory]) and operation ([SupposeType]) — the server endpoint
  /// is intentionally shared across the whole app.
  Future<Either<Failure, List<InvoicePatternModel>>> getAllPatterns();

  Future<Either<Failure, List<CurrencyModel>>> getCurrencies();
}

class InvoiceSetupDataSourceImpl implements InvoiceSetupDataSource {
  final GenericDataSource _genericDataSource;

  InvoiceSetupDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<InvoicePatternModel>>> getAllPatterns() {
    return _genericDataSource.fetchData<InvoicePatternModel>(
      endpoint: EndPoints.getInvoicePatterns,
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
