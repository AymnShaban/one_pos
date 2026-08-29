import '../../invoice_profit_imports.dart';
import '../models/user_model.dart';
abstract class UsersDataSource {
  Future<Either<Failure, List<UserModel>>> getUsers();
}

class UsersDataSourceImpl implements UsersDataSource {
  final GenericDataSource genericDataSource;

  UsersDataSourceImpl({required this.genericDataSource});

  @override
  Future<Either<Failure, List<UserModel>>> getUsers() async {
    return genericDataSource.fetchData<UserModel>(
      endpoint: EndPoints.getInvoiceProfitUsers,

      fromJson: UserModel.fromJson
    );
  }
}