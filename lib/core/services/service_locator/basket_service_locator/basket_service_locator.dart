part of '../services_imports.dart';

class BasketServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerLazySingleton<BasketDataSource>(
      () => BasketDataSourceImpl(getIt<IBasket>()),
    );
    getIt.registerLazySingleton<DeleteBasketDataSource>(
      () => DeleteBasketDataSourceImpl(getIt<IBasket>()),
    );
    getIt.registerLazySingleton<AddToBasketDataSource>(
      () => AddToBasketDataSourceImpl(getIt<IBasket>()),
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

    getIt.registerLazySingleton<AccountSearchDataSource>(
      () => AccountSearchDataSourceImpl(getIt<GenericDataSource>()),
    );
    getIt.registerFactory<AccountSearchBloc>(
      () => AccountSearchBloc(dataSource: getIt<AccountSearchDataSource>()),
    );

    getIt.registerLazySingleton<PayWaysDataSource>(
      () => PayWaysDataSourceImpl(getIt<GenericDataSource>()),
    );
    getIt.registerFactory<PayWaysBloc>(
      () => PayWaysBloc(dataSource: getIt<PayWaysDataSource>()),
    );
  }
}
