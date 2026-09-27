



import '../../../../feature/main/main_reports/item_movement_balance/item_movement_balance_import.dart';

class ItemMovementBalanceServiceLocator {
  static Future<void> init({required GetIt getIt}) async {

    getIt.registerLazySingleton<ItemMovementBalanceDataSource>(
          () => ItemMovementBalanceDataSourceImpl(
        genericDataSource: getIt<GenericDataSource>(),
      ),
    );

    // Bloc
    getIt.registerFactory<ItemMovementBalanceBloc>(
          () => ItemMovementBalanceBloc(
        dataSource: getIt<ItemMovementBalanceDataSource>(),
      ),
    );


    getIt.registerLazySingleton<
        MaterialGroupMotionReportSourceDataSource>(
          () => MaterialGroupMotionReportSourceDataSourceImpl(
        genericDataSource: getIt<GenericDataSource>(),
      ),
    );

    getIt.registerFactory<MaterialGroupMotionReportSourceBloc>(
          () => MaterialGroupMotionReportSourceBloc(
        dataSource:
        getIt<MaterialGroupMotionReportSourceDataSource>(),
      ),
    );
  }
}