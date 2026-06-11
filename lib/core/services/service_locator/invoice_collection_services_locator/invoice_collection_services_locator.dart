part of '../services_imports.dart';

class InvoiceCollectionServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    // Data source — now routes through the shared GenericDataSource
    // (the previous version built its own Dio and bypassed the auth
    // header + encryption interceptor, which is why nothing authenticated).
    getIt.registerLazySingleton<InvoiceCollectionDataSource>(
      () => InvoiceCollectionDataSourceImpl(getIt<GenericDataSource>()),
    );

    getIt.registerFactory<InvoiceCollectionBloc>(
      () => InvoiceCollectionBloc(
        dataSource: getIt<InvoiceCollectionDataSource>(),
      ),
    );

    // Picker bloc for the "فاتورة" button → InvoicePickerScreen
    getIt.registerFactory<InvoiceSearchBloc>(
      () => InvoiceSearchBloc(
        dataSource: getIt<InvoiceCollectionDataSource>(),
      ),
    );
  }
}
