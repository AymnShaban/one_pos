import '../../customer_account_imports.dart';
abstract class CustomerSupplierDataSource {
  Future<Either<Failure, List<CustomerSupplierModel>>> getCustomerSuppliers();
}

class CustomerSupplierDataSourceImpl implements CustomerSupplierDataSource {
  final GenericDataSource genericDataSource;

  CustomerSupplierDataSourceImpl({required this.genericDataSource});

  @override
  Future<Either<Failure, List<CustomerSupplierModel>>> getCustomerSuppliers() async {
    return genericDataSource.fetchData<CustomerSupplierModel>(
      endpoint: EndPoints.customerSuppliers,
      fromJson: CustomerSupplierModel.fromJson,
    );
  }
}