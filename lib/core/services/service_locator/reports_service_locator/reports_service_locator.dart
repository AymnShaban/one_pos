part of '../services_imports.dart';

class ReportsServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerLazySingleton<ReportsDataSource>(
          () => ReportsDataSourceImpl(getIt<GenericDataSource>()),
    );
    getIt.registerFactory<ReportsBloc>(
          () => ReportsBloc(dataSource: getIt<ReportsDataSource>()),
    );
  }
}