import '../../customer_account_imports.dart';
abstract class CustomerAccountReportSourceDataSource {
  Future<Either<Failure, List<CustomerAccountReportSourceModel>>>
      getReportSources();
}

class CustomerAccountReportSourceDataSourceImpl
    implements CustomerAccountReportSourceDataSource {
  final GenericDataSource genericDataSource;

  CustomerAccountReportSourceDataSourceImpl({
    required this.genericDataSource,
  });

  @override
  Future<Either<Failure, List<CustomerAccountReportSourceModel>>>
      getReportSources() async {
    return genericDataSource
        .fetchData<CustomerAccountReportSourceModel>(
      endpoint: EndPoints.getCustomerAccountReportSources,
      queryParameters: {
        'culture': 'ar',
      },
      fromJson: CustomerAccountReportSourceModel.fromJson,
    );
  }
}