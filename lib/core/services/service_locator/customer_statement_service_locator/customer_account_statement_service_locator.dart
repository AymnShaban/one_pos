
import '../../../../feature/main/customer_account_statement/customer_account_imports.dart';


class CustomerAccountStatementServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    // ==================== Data Sources ====================

    getIt.registerLazySingleton<MainAccountsDataSource>(
          () => MainAccountsDataSourceImpl(
        genericDataSource: getIt<GenericDataSource>(),
      ),
    );

    getIt.registerLazySingleton<CustomerSupplierDataSource>(
          () => CustomerSupplierDataSourceImpl(
        genericDataSource: getIt<GenericDataSource>(),
      ),
    ); getIt.registerLazySingleton<CustomerStatementDataSource>(
          () => CustomerStatementDataSourceImpl(
        genericDataSource: getIt<GenericDataSource>(),
      ),
    ); getIt.registerLazySingleton<CustomerAccountReportSourceDataSource>(
          () => CustomerAccountReportSourceDataSourceImpl(
        genericDataSource: getIt<GenericDataSource>(),
      ),
    );



    // ==================== Blocs ====================

    getIt.registerFactory<MainAccountsBloc>(
          () => MainAccountsBloc(
        dataSource: getIt<MainAccountsDataSource>(),
      ),
    );

    getIt.registerFactory<CustomerSupplierBloc>(
          () => CustomerSupplierBloc(
        dataSource: getIt<CustomerSupplierDataSource>(),
      ),
    );getIt.registerFactory<CustomerStatementReportBloc>(
          () => CustomerStatementReportBloc(
        dataSource: getIt<CustomerStatementDataSource>(),
      ),
    );getIt.registerFactory<CustomerAccountReportSourceBloc>(
          () => CustomerAccountReportSourceBloc(
        dataSource: getIt<CustomerAccountReportSourceDataSource>(),
      ),
    );


  }
}