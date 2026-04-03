part of '../services_imports.dart';
class FavoriteServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerLazySingleton<FavoriteDataSource>(
          () => FavoriteDataSourceImpl(getIt<GenericDataSource>()),
    );

    getIt.registerLazySingleton<FavoriteBloc>(
          () => FavoriteBloc(favoriteDataSource: getIt<FavoriteDataSource>()),
    );
  }
}