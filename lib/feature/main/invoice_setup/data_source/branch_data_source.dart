part of '../invoice_setup_imports.dart';

/// One endpoint, one data source — purposely split from
/// [InvoiceSetupDataSource] so consumers (Sales tab, Invoice Collection,
/// New Invoice) can load branches lazily on their own initState without
/// pulling currencies / patterns along for the ride.
abstract interface class BranchDataSource {
  Future<Either<Failure, List<BranchModel>>> getBranches();
}

class BranchDataSourceImpl implements BranchDataSource {
  final GenericDataSource _generic;

  BranchDataSourceImpl(this._generic);

  @override
  Future<Either<Failure, List<BranchModel>>> getBranches() {
    return _generic.fetchData<BranchModel>(
      endpoint: EndPoints.getCompanyBranchesByUser,
      fromJson: BranchModel.fromJson,
    );
  }
}
