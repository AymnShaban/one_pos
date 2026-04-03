part of '../services_imports.dart';

class InvoicesServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerLazySingleton<IPaginatedCache<InvoiceModel>>(
      () => GenericPaginatedCache<InvoiceModel>(HiveServiceImpl.instance),
    );
    getIt.registerLazySingleton<InvoicesDataSource>(
          () => InvoicesDataSourceImpl(getIt<GenericDataSource>()),
    );
    getIt.registerFactory<InvoicesBloc>(
          () => InvoicesBloc(dataSource: getIt<InvoicesDataSource>()),
    );
  }
}