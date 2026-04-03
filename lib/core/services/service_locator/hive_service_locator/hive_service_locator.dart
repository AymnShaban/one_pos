part of '../services_imports.dart';

class HiveServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerLazySingleton<HiveServiceImpl>(
      () => HiveServiceImpl.instance,
    );
    getIt.registerLazySingleton<IUserCache>(() => HiveServiceImpl.instance);
    getIt.registerLazySingleton<IPaginatedCache<ItemModel>>(() => GenericPaginatedCache<ItemModel>(HiveServiceImpl.instance));
  }
}
