part of '../services_imports.dart';

class BarrenServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerFactory<InvoiceCubit>(
      () => InvoiceCubit(
        searchDataSource: getIt<ProductSearchDataSource>(),
        invoiceCache: getIt<InvoiceCache>(),
      ),
    );
  }
}
