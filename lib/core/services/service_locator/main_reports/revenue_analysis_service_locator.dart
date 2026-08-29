

import '../../../../feature/main/main_reports/revenue_analysis/revenue_analysis_import.dart';

class RevenueAnalysisServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    // Data Sources
    getIt.registerLazySingleton<RevenueAccountsDataSource>(
          () => RevenueAccountsDataSourceImpl(
        genericDataSource: getIt<GenericDataSource>(),
      ),
    );

    getIt.registerLazySingleton<RevenueReportDataSource>(
          () => RevenueReportDataSourceImpl(
        genericDataSource: getIt<GenericDataSource>(),
      ),
    );

    // Blocs
    getIt.registerFactory<RevenueAccountsBloc>(
          () => RevenueAccountsBloc(
        dataSource: getIt<RevenueAccountsDataSource>(),
      ),
    );

    getIt.registerFactory<RevenueReportBloc>(
          () => RevenueReportBloc(
        dataSource: getIt<RevenueReportDataSource>(),
      ),
    );
  }
}