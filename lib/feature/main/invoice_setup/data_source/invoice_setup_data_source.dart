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
    // NOTE: /api/CompanyBranch/GetBranches returns 404. The working endpoint
    // (mirrors the invoice_collection feature) is GetCompanyBranchesByUserID
    // and needs the user id + server credentials from the activation config.
    final hive = HiveServiceImpl.instance;
    return _genericDataSource.fetchData<BranchModel>(
      // getCompanyBranchesByUser has no leading slash (it's consumed by the
      // invoice_collection feature's own Dio); the shared Dio concatenates
      // baseUrl + path, so force the slash to avoid ".../TheOneApiapi/...".
      endpoint: '/${EndPoints.getCompanyBranchesByUser}',
      queryParameters: {
        'UserID':       hive.getUserId(),
        'serverName':   hive.getIpAddress(),
        'UserName':     hive.getServerUserName(),
        'UserPassword': hive.getServerPassword(),
        'DBName':       hive.getDatabaseName(),
      },
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