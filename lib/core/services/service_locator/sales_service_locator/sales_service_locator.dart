part of '../services_imports.dart';

class SalesServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerLazySingleton<SalesDataSource>(
          () => SalesDataSourceImpl(getIt<GenericDataSource>()),
    );
    getIt.registerFactory<SalesBloc>(
          () => SalesBloc(dataSource: getIt<SalesDataSource>()),
    );
  }
}