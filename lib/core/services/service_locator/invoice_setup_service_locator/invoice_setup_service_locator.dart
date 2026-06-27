part of '../services_imports.dart';

class InvoiceSetupServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    // Per-endpoint data sources + blocs. Each tab/screen drives its own
    // load lifecycle from its initState; the blocs are factories so a fresh
    // load runs every time a screen is mounted (the bloc itself short-
    // circuits redundant fetches once the data is in hand).
    getIt.registerLazySingleton<InvoiceSetupDataSource>(
      () => InvoiceSetupDataSourceImpl(getIt<GenericDataSource>()),
    );
    getIt.registerLazySingleton<BranchDataSource>(
      () => BranchDataSourceImpl(getIt<GenericDataSource>()),
    );

    getIt.registerFactory<InvoiceSetupBloc>(
      () => InvoiceSetupBloc(
        dataSource: getIt<InvoiceSetupDataSource>(),
      ),
    );
    getIt.registerFactory<BranchBloc>(
      () => BranchBloc(dataSource: getIt<BranchDataSource>()),
    );
  }
}
