part of '../services_imports.dart';



class DetailsServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    // NOTE: AddToBasketDataSource and AddToBasketBloc are registered by
    // BasketServiceLocator; do not re-register them here or GetIt throws
    // "Type ... is already registered".
    getIt.registerLazySingleton<ProductDetailsDataSource>(
          () => ProductDetailsDataSourceImpl(getIt<GenericDataSource>()),
    );
    getIt.registerFactory<ProductDetailsBloc>(
          () => ProductDetailsBloc(dataSource: getIt<ProductDetailsDataSource>()),
    );
  }
}
