
import '../../../../feature/main/main_reports/invoices_profit/data/datasource/bill_revenue_report_datasource.dart';
import '../../../../feature/main/main_reports/invoices_profit/invoice_profit_imports.dart';

class InvoiceProfitServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    // Data Sources
    getIt.registerLazySingleton<ParentAccountsDataSource>(
          () => ParentAccountsDataSourceImpl(
       getIt<GenericDataSource>(),
      ),
    );

    getIt.registerLazySingleton<CustomersDataSource>(
          () => CustomersDataSourceImpl(
        genericDataSource: getIt<GenericDataSource>(),
      ),
    );

    getIt.registerLazySingleton<EmployeesDataSource>(
          () => EmployeesDataSourceImpl(
        genericDataSource: getIt<GenericDataSource>(),
      ),
    );

    getIt.registerLazySingleton<CostCentersDataSource>(
          () => CostCentersDataSourceImpl(
        genericDataSource: getIt<GenericDataSource>(),
      ),
    );

    getIt.registerLazySingleton<CurrenciesDataSource>(
          () => CurrenciesDataSourceImpl(
        genericDataSource: getIt<GenericDataSource>(),
      ),
    );

    getIt.registerLazySingleton<UsersDataSource>(
          () => UsersDataSourceImpl(
        genericDataSource: getIt<GenericDataSource>(),
      ),
    );

    getIt.registerLazySingleton<BranchesDataSource>(
          () => BranchesDataSourceImpl(
        getIt<GenericDataSource>(),
      ),
    );

    getIt.registerLazySingleton<PayWaysDataSource>(
          () => PayWaysDataSourceImpl(
        genericDataSource: getIt<GenericDataSource>(),
      ),
    );

    getIt.registerLazySingleton<BillSourcesDataSource>(
          () => BillSourcesDataSourceImpl(
        genericDataSource: getIt<GenericDataSource>(),
      ),
    );
    getIt.registerLazySingleton<InvoiceProfitDataSource>(
          () => InvoiceProfitDataSourceImpl(
        genericDataSource: getIt<GenericDataSource>(),
      ),
    );


    // Blocs
    getIt.registerFactory<ParentAccountsBloc>(
          () => ParentAccountsBloc(
        dataSource: getIt<ParentAccountsDataSource>(),
      ),
    );

    getIt.registerFactory<CustomersBloc>(
          () => CustomersBloc(
        dataSource: getIt<CustomersDataSource>(),
      ),
    );

    getIt.registerFactory<EmployeesBloc>(
          () => EmployeesBloc(
        dataSource: getIt<EmployeesDataSource>(),
      ),
    );

    getIt.registerFactory<CostCentersBloc>(
          () => CostCentersBloc(
        dataSource: getIt<CostCentersDataSource>(),
      ),
    );

    getIt.registerFactory<CurrenciesBloc>(
          () => CurrenciesBloc(
        dataSource: getIt<CurrenciesDataSource>(),
      ),
    );

    getIt.registerFactory<UsersBloc>(
          () => UsersBloc(
        dataSource: getIt<UsersDataSource>(),
      ),
    );

    getIt.registerFactory<BranchesBloc>(
          () => BranchesBloc(
        dataSource: getIt<BranchesDataSource>(),
      ),
    );

    getIt.registerFactory<PayWaysBloc>(
          () => PayWaysBloc(
        dataSource: getIt<PayWaysDataSource>(),
      ),
    );

    getIt.registerFactory<BillSourcesBloc>(
          () => BillSourcesBloc(
        dataSource: getIt<BillSourcesDataSource>(),
      ),
    );
    getIt.registerFactory<InvoiceProfitBloc>(
          () => InvoiceProfitBloc(
        dataSource: getIt<InvoiceProfitDataSource>(),
      ),
    );

  }
}