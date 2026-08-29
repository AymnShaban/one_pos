
import '../../invoice_profit_imports.dart';
import '../models/parent_account_model.dart';

abstract interface class ParentAccountsDataSource {
  Future<Either<Failure, List<ParentAccountModel>>> getParentAccounts();
}

class ParentAccountsDataSourceImpl implements ParentAccountsDataSource {
  final GenericDataSource _generic;

  ParentAccountsDataSourceImpl(this._generic, );

  @override
  Future<Either<Failure, List<ParentAccountModel>>> getParentAccounts() {
    return _generic.fetchData<ParentAccountModel>(
      endpoint: EndPoints.getInvoiceProfitParentAccounts,
      fromJson: ParentAccountModel.fromJson,
    );
  }}