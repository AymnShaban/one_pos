part of '../services_imports.dart';

class BasketServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerLazySingleton<BasketDataSource>(
      () => BasketDataSourceImpl(getIt<GenericDataSource>()),
    );
    getIt.registerLazySingleton<DeleteBasketDataSource>(
      () => DeleteBasketDataSourceImpl(getIt<GenericDataSource>()),
    );
    getIt.registerLazySingleton<AddToBasketDataSource>(
      () => AddToBasketDataSourceImpl(getIt<GenericDataSource>()),
    );

    getIt.registerLazySingleton<BasketBloc>(
      () => BasketBloc(
        basketDataSource: getIt<BasketDataSource>(),
        deleteBasketDataSource: getIt<DeleteBasketDataSource>(),
      ),
    );
    getIt.registerLazySingleton<AddToBasketBloc>(
          () => AddToBasketBloc(addToBasketDataSource: getIt<AddToBasketDataSource>()),
    );
  }
}
