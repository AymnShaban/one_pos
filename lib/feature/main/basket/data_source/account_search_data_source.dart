part of '../basket_imports.dart';

abstract interface class AccountSearchDataSource {
  /// Searches customer accounts by name.
  Future<Either<Failure, List<CustomerAccountModel>>> searchCustomers(
    String searchKey,
  );
}

class AccountSearchDataSourceImpl implements AccountSearchDataSource {
  final GenericDataSource _genericDataSource;

  AccountSearchDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<CustomerAccountModel>>> searchCustomers(
    String searchKey,
  ) {
    final userId = getIt<HiveServiceImpl>().getUserId();
    return _genericDataSource.fetchData<CustomerAccountModel>(
      endpoint: EndPoints.getAllCustomersByName,
      queryParameters: {
        'SearchKey': searchKey,
        'UserID': userId,
      },
      fromJson: CustomerAccountModel.fromJson,
    );
  }
}
