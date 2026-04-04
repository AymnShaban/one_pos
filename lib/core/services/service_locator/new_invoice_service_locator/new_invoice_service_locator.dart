part of '../services_imports.dart';

class NewInvoiceServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerLazySingleton<CategoryDataSource>(
          () => CategoryDataSourceImpl(getIt<GenericDataSource>()),
    );
    getIt.registerLazySingleton<ProductSearchDataSource>(
          () => ProductSearchDataSourceImpl(getIt<GenericDataSource>()),
    );
    getIt.registerLazySingleton<NewInvoiceDataSource>(
          () => NewInvoiceDataSourceImpl(getIt<GenericDataSource>()),
    );
    getIt.registerFactory<CategoryBloc>(
          () => CategoryBloc(dataSource: getIt<CategoryDataSource>()),
    );
    getIt.registerFactory<ProductBloc>(
          () => ProductBloc(dataSource: getIt<ProductSearchDataSource>()),
    );
    getIt.registerFactory<CartBloc>(() => CartBloc());
    getIt.registerFactory<NewInvoiceBloc>(
          () => NewInvoiceBloc(dataSource: getIt<NewInvoiceDataSource>()),
    );
  }
}