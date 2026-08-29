import '../../expense_analysis_imports.dart';
abstract class ExpenseAccountsDataSource {
  Future<Either<Failure, List<ExpenseAccountModel>>> getExpenseAccounts({
    String? search,
  });
}

class ExpenseAccountsDataSourceImpl implements ExpenseAccountsDataSource {
  final GenericDataSource genericDataSource;

  ExpenseAccountsDataSourceImpl({required this.genericDataSource});

  @override
  Future<Either<Failure, List<ExpenseAccountModel>>> getExpenseAccounts({
    String? search,
  }) async {
    final queryParameters = <String, dynamic>{};
    if (search != null && search.isNotEmpty) {
      queryParameters['search'] = search;
    }

    return genericDataSource.fetchData<ExpenseAccountModel>(
      endpoint: EndPoints.expenseAccounts,

      queryParameters: queryParameters,
      fromJson:ExpenseAccountModel.fromJson
    );
  }
}