import '../../invoice_profit_imports.dart';
import '../models/customer_model.dart';

abstract class CustomersDataSource {
  Future<Either<Failure, List<CustomerModel>>> getCustomers({
    String? search,
  });
}

class CustomersDataSourceImpl implements CustomersDataSource {
  final GenericDataSource genericDataSource;

  CustomersDataSourceImpl({required this.genericDataSource});

  @override
  Future<Either<Failure, List<CustomerModel>>> getCustomers({
    String? search,
  }) async {
    final queryParameters = <String, dynamic>{};
    if (search != null && search.isNotEmpty) {
      queryParameters['search'] = search;
    }

    return genericDataSource.fetchData<CustomerModel>(
      endpoint: EndPoints.getInvoiceProfitCustomers,

      queryParameters: queryParameters,
        fromJson: CustomerModel.fromJson,


    );
  }
}