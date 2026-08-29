part of '../services_imports.dart';

class HomeServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    // ── Dashboard ──────────────────────────────────────────────────────
    getIt.registerLazySingleton<DashboardDataSource>(
          () => DashboardDataSourceImpl(getIt<GenericDataSource>()),
    );
    getIt.registerFactory<HomeBloc>(
          () => HomeBloc(dashboard: getIt<DashboardDataSource>()),
    );

    // ── Daily Operations ──────────────────────────────────────────────
    getIt.registerLazySingleton<DailyOperationDataSource>(
          () => DailyOperationDataSourceImpl(getIt<GenericDataSource>()),
    );
    getIt.registerFactory<DailyOperationsBloc>(
          () => DailyOperationsBloc(dataSource: getIt<DailyOperationDataSource>()),
    );

    // ──  Top Selling ──────────────────────────────────────────────────
    getIt.registerLazySingleton<TopSellingDataSource>(
          () => TopSellingDataSourceImpl(getIt<GenericDataSource>()),
    );
    getIt.registerFactory<TopSellingBloc>(
          () => TopSellingBloc(dataSource: getIt<TopSellingDataSource>()),
    );

    // ──  Low Stock ────────────────────────────────────────────────────
    getIt.registerLazySingleton<LowStockDataSource>(
          () => LowStockDataSourceImpl(getIt<GenericDataSource>()),
    );
    getIt.registerFactory<LowStockBloc>(
          () => LowStockBloc(dataSource: getIt<LowStockDataSource>()),
    );

    // ── Navigation ─────────────────────────────────────────────────────
    getIt.registerFactory<NavBloc>(() => NavBloc());
  }
}
