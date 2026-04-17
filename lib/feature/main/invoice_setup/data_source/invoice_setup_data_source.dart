part of '../invoice_setup_imports.dart';

abstract interface class InvoiceSetupDataSource {
  Future<Either<Failure, List<BranchModel>>> getBranches();

  Future<Either<Failure, List<InvoicePatternModel>>> getInvoicePatterns({
    required int branchId,
  });

  Future<Either<Failure, List<InvoicePatternModel>>> getQuotePatterns({
    required int branchId,
  });

  Future<Either<Failure, List<CurrencyModel>>> getCurrencies();
}

class InvoiceSetupDataSourceImpl
    implements InvoiceSetupDataSource {
  final GenericDataSource _genericDataSource;

  InvoiceSetupDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<BranchModel>>> getBranches() {
    return _genericDataSource.fetchData<BranchModel>(
      endpoint:  EndPoints.getBranches,
      fromJson:  BranchModel.fromJson,
    );
  }

  @override
  Future<Either<Failure, List<InvoicePatternModel>>> getInvoicePatterns({
    required int branchId,
  }) {
    return _genericDataSource.fetchData<InvoicePatternModel>(
      endpoint:        EndPoints.getInvoicePatterns,
      queryParameters: {'BranchID': branchId},
      fromJson:        InvoicePatternModel.fromJson,
    );
  }

  @override
  Future<Either<Failure, List<InvoicePatternModel>>> getQuotePatterns({
    required int branchId,
  }) {
    return _genericDataSource.fetchData<InvoicePatternModel>(
      endpoint:        EndPoints.getQuotePatterns,
      queryParameters: {'BranchID': branchId},
      fromJson:        InvoicePatternModel.fromJson,
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