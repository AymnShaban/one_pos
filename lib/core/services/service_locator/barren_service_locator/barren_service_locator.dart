part of '../services_imports.dart';

class BarrenServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    // Stock DataSource
    getIt.registerLazySingleton<StockDataSource>(
          () => StockDataSourceImpl(
        getIt<GenericDataSource>(),
      ),
    );

    // Stock Cubit
    getIt.registerFactory<StockCubit>(
          () => StockCubit(
        getIt<StockDataSource>(),
      ),
    );

    // Invoice Cubit
    getIt.registerFactory<InvoiceCubit>(
          () => InvoiceCubit(
        searchDataSource: getIt<ProductSearchDataSource>(),
        invoiceCache: getIt<InvoiceCache>(),
      ),
    );
  }
}