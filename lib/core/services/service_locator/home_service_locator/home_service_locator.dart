part of '../services_imports.dart';

class HomeServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerLazySingleton<DashboardDataSource>(
      () => DashboardDataSourceImpl(getIt<GenericDataSource>()),
    );
    getIt.registerFactory<HomeBloc>(
      () => HomeBloc(dashboard: getIt<DashboardDataSource>()),
    );
    getIt.registerFactory<NavBloc>(() => NavBloc());
  }
}
