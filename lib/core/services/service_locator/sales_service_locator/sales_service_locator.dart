part of '../services_imports.dart';

class SalesServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerLazySingleton<SalesDataSource>(
          () => SalesDataSourceImpl(getIt<GenericDataSource>()),
    );
    getIt.registerLazySingleton<MainCategoryDataSource>(
          () => MainCategoryDataSourceImpl(getIt<GenericDataSource>()),
    );
    getIt.registerLazySingleton<SubCategoryDataSource>(
          () => SubCategoryDataSourceImpl(getIt<GenericDataSource>()),
    );
    getIt.registerFactory<SalesBloc>(
          () => SalesBloc(dataSource: getIt<SalesDataSource>()),
    );
    getIt.registerFactory<MainCategoryBloc>(
          () => MainCategoryBloc(
        mainCategoryDataSource: getIt<MainCategoryDataSource>(),
      ),
    );
    getIt.registerFactory<SubCategoryBloc>(
          () => SubCategoryBloc(
        subCategoryDataSource: getIt<SubCategoryDataSource>(),
      ),
    );
  }
}