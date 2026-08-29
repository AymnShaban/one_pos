import '../../customer_account_imports.dart';
abstract class MainAccountsDataSource {
  Future<Either<Failure, List<MainAccountModel>>> getMainAccounts();
}

class MainAccountsDataSourceImpl implements MainAccountsDataSource {
  final GenericDataSource genericDataSource;

  MainAccountsDataSourceImpl({required this.genericDataSource});

  @override
  Future<Either<Failure, List<MainAccountModel>>> getMainAccounts() async {
    return genericDataSource.fetchData<MainAccountModel>(
      endpoint: EndPoints.mainAccounts,
      fromJson: MainAccountModel.fromJson,
    );
  }
}



