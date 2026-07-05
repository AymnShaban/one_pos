part of '../services_imports.dart';

class LiveSalesReportServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerLazySingleton<LiveSalesReportDataSource>(
      () => LiveSalesReportDataSourceImpl(getIt<GenericDataSource>()),
    );
    getIt.registerFactory<LiveSalesReportBloc>(
      () => LiveSalesReportBloc(
        dataSource: getIt<LiveSalesReportDataSource>(),
      ),
    );

    getIt.registerLazySingleton<DelegateDataSource>(
      () => DelegateDataSourceImpl(getIt<GenericDataSource>()),
    );
    getIt.registerFactory<DelegateBloc>(
      () => DelegateBloc(dataSource: getIt<DelegateDataSource>()),
    );
  }
}
