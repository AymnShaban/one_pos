



import '../../../../feature/main/main_reports/item_movement_balance/item_movement_balance_import.dart';

class ItemMovementBalanceServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    // Data Source
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
  }
}