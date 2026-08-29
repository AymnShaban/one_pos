
import '../../../../feature/main/main_reports/shared/shared_imports.dart';
import '../../../../feature/main/main_reports/items_movement/items_movement_import.dart';

class ItemMovementServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    // Item Movement Report
    getIt.registerLazySingleton<ItemMovementDataSource>(
          () => ItemMovementDataSourceImpl(
        genericDataSource: getIt<GenericDataSource>(),
      ),
    );

    // Groups
    getIt.registerLazySingleton<GroupsDataSource>(
          () => GroupsDataSourceImpl(
 getIt<GenericDataSource>(),
      ),
    );

    // Products
    getIt.registerLazySingleton<ProductsDataSource>(
          () => ProductsDataSourceImpl(
    getIt<GenericDataSource>(),
      ),
    );
 getIt.registerLazySingleton<MTIReportSourceDataSource>(
          () => MTIReportSourceDataSourceImpl(
  genericDataSource:   getIt<GenericDataSource>(),
      ),
    );

    // Stores
    getIt.registerLazySingleton<StoresDataSource>(
          () => StoresDataSourceImpl(
        getIt<GenericDataSource>(),
      ),
    );

    // Item Movement Report Bloc
    getIt.registerFactory<ItemMovementBloc>(
          () => ItemMovementBloc(
        dataSource: getIt<ItemMovementDataSource>(),
      ),
    );

    // Groups Bloc
    getIt.registerFactory<GroupsBloc>(
          () => GroupsBloc(
        dataSource: getIt<GroupsDataSource>(),
      ),
    );

    // Products Bloc
    getIt.registerFactory<ProductsBloc>(
          () => ProductsBloc(
        dataSource: getIt<ProductsDataSource>(),
      ),
    );

    // Stores Bloc
    getIt.registerFactory<StoresBloc>(
          () => StoresBloc(
        dataSource: getIt<StoresDataSource>(),
      ),
    ); getIt.registerFactory<MTIReportSourceBloc>(
          () => MTIReportSourceBloc(
        dataSource: getIt<MTIReportSourceDataSource>(),
      ),
    );
  }
}