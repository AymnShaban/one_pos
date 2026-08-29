import '../../customer_account_imports.dart';
import '../models/report_source_request_model.dart';



abstract class CustomerStatementDataSource {
  Future<
      Either<
          Failure,
          List<CustomerAccountStatementResponseModel>
      >
  > getReport(
      CustomerStatementRequestModel request,
      );
}

class CustomerStatementDataSourceImpl
    implements CustomerStatementDataSource {
  final GenericDataSource genericDataSource;

  CustomerStatementDataSourceImpl({
    required this.genericDataSource,
  });

  @override
  Future<
      Either<
          Failure,
          List<CustomerAccountStatementResponseModel>
      >
  > getReport(
      CustomerStatementRequestModel request,
      ) async {
    return genericDataSource
        .postData<List<CustomerAccountStatementResponseModel>>(
      endpoint: EndPoints.customerStatementReport,
      data: request.toJson(),
      fromJsonListOrMap: (
          List<dynamic>? list,
          Map<String, dynamic>? map,
          ) {
        // Success
        if (list != null) {
          return list
              .whereType<Map<String, dynamic>>()
              .map(
            CustomerAccountStatementResponseModel.fromJson,
          )
              .toList();
        }

        // No Data
        if (map != null) {
          return const [];
        }

        return const [];
      },
    );
  }
}