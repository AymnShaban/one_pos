import '../../expense_analysis_imports.dart';
abstract class ExpenseReportDataSource {
  Future<Either<Failure, ExpenseReportResponseModel>> getReport(
      ExpenseReportRequestModel request,
      );
}

class ExpenseReportDataSourceImpl implements ExpenseReportDataSource {
  final GenericDataSource genericDataSource;

  ExpenseReportDataSourceImpl({
    required this.genericDataSource,
  });


  @override
  Future<Either<Failure, ExpenseReportResponseModel>> getReport(
      ExpenseReportRequestModel request,
      ) async {
   return await genericDataSource.postData(
      endpoint: EndPoints.expenseReportDetails,
      data: request.toJson(),
      fromJson:  ExpenseReportResponseModel.fromJson
    );

  }
}