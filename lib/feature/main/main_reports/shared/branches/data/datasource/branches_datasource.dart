
import '../../branches_import.dart';


abstract interface class BranchesDataSource {
  Future<Either<Failure, List<BranchModel>>> getBranches();
}

class BranchesDataSourceImpl implements BranchesDataSource {
  final GenericDataSource _generic;

  BranchesDataSourceImpl(this._generic);

  @override
  Future<Either<Failure, List<BranchModel>>> getBranches() {
    return _generic.fetchData<BranchModel>(
      endpoint: EndPoints.getInvoiceProfitCompanyBranches,
      fromJson: BranchModel.fromJson,
    );
  }
}