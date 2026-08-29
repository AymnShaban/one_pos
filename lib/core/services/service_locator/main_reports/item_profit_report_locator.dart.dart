



import '../../../../feature/main/main_reports/item_profit_report/item_profit_import.dart';


class ItemProfitServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    // Data Sources
    getIt.registerLazySingleton<ItemProfitDataSource>(
          () => ItemProfitDataSourceImpl(
        genericDataSource: getIt<GenericDataSource>(),
      ),
    );


    getIt.registerFactory<ItemProfitBloc>(
          () => ItemProfitBloc(
        dataSource: getIt<ItemProfitDataSource>(),
      ),
    );
  }
}