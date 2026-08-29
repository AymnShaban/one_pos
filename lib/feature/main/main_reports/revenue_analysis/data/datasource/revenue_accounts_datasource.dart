import '../../revenue_analysis_import.dart';
abstract class RevenueAccountsDataSource {
  Future<Either<Failure, List<RevenueAccountModel>>> getRevenueAccounts({
    String? search,
  });
}

class RevenueAccountsDataSourceImpl implements RevenueAccountsDataSource {
  final GenericDataSource genericDataSource;

  RevenueAccountsDataSourceImpl({required this.genericDataSource});

  @override
  Future<Either<Failure, List<RevenueAccountModel>>> getRevenueAccounts({
    String? search,
  }) async {
    final queryParameters = <String, dynamic>{};
    if (search != null && search.isNotEmpty) {
      queryParameters['Search'] = search;
    }

    return genericDataSource.fetchData<RevenueAccountModel>(
      endpoint: EndPoints.revenueAccounts,

      queryParameters: queryParameters,
      fromJson: RevenueAccountModel.fromJson
    );
  }
}