import '../../invoice_profit_imports.dart';
import '../models/employee_model.dart';

abstract class EmployeesDataSource {
  Future<Either<Failure, List<EmployeeModel>>> getEmployees({
    String? searchText,
  });
}

class EmployeesDataSourceImpl implements EmployeesDataSource {
  final GenericDataSource genericDataSource;

  EmployeesDataSourceImpl({
    required this.genericDataSource,
  });

  @override
  Future<Either<Failure, List<EmployeeModel>>> getEmployees({
    String? searchText,
  }) async {
    final queryParameters = <String, dynamic>{};

    if (searchText != null && searchText.isNotEmpty) {
      queryParameters['searchText'] = searchText;
    }

    return genericDataSource.fetchData<EmployeeModel>(
      endpoint: EndPoints.getInvoiceProfitEmployees,
      queryParameters: queryParameters,
      fromJson: EmployeeModel.fromJson,
    );
  }
}