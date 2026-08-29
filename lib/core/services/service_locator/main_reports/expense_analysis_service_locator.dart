


import '../../../../feature/main/main_reports/expense_analysis/expense_analysis_imports.dart';

class ExpenseAnalysisServiceLocator {
  static Future<void> init({required GetIt getIt}) async {

    getIt.registerLazySingleton<ExpenseAccountsDataSource>(
          () => ExpenseAccountsDataSourceImpl(
        genericDataSource: getIt<GenericDataSource>(),
      ),
    );

    getIt.registerLazySingleton<ExpenseReportDataSource>(
          () => ExpenseReportDataSourceImpl(
        genericDataSource: getIt<GenericDataSource>(),
      ),
    );

    getIt.registerFactory<ExpenseAccountsBloc>(
          () => ExpenseAccountsBloc(
        dataSource: getIt<ExpenseAccountsDataSource>(),
      ),
    );

    getIt.registerFactory<ExpenseReportBloc>(
          () => ExpenseReportBloc(
        dataSource: getIt<ExpenseReportDataSource>(),
      ),
    );
  }
}