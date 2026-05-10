part of '../services_imports.dart';



class DetailsServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerLazySingleton<ProductDetailsDataSource>(
          () => ProductDetailsDataSourceImpl(getIt<GenericDataSource>()),
    );
    getIt.registerLazySingleton<AddToBasketDataSource>(
          () => AddToBasketDataSourceImpl(getIt<GenericDataSource>()),
    );
    getIt.registerFactory<ProductDetailsBloc>(
          () => ProductDetailsBloc(dataSource: getIt<ProductDetailsDataSource>()),
    );
    getIt.registerLazySingleton<AddToBasketBloc>(
          () => AddToBasketBloc(addToBasketDataSource: getIt<AddToBasketDataSource>()),
    );
  }
}
