part of '../services_imports.dart';

class InvoiceSetupServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerLazySingleton<InvoiceSetupDataSource>(
          () => InvoiceSetupDataSourceImpl(getIt<GenericDataSource>()),
    );
    getIt.registerFactory<InvoiceSetupBloc>(
          () => InvoiceSetupBloc(
        dataSource: getIt<InvoiceSetupDataSource>(),
      ),
    );
  }
}