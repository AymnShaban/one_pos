//
//
//
//
// import '../../../feature/main/main_reports/invoices_profit/data/datasource/bill_sources_datasource.dart';
// import '../../../feature/main/main_reports/invoices_profit/data/datasource/branches_datasource.dart';
// import '../../../feature/main/main_reports/invoices_profit/data/datasource/cost_centers_datasource.dart';
// import '../../../feature/main/main_reports/invoices_profit/data/datasource/currencies_datasource.dart';
// import '../../../feature/main/main_reports/invoices_profit/data/datasource/customers_datasource.dart';
// import '../../../feature/main/main_reports/invoices_profit/data/datasource/employees_datasource.dart';
// import '../../../feature/main/main_reports/invoices_profit/data/datasource/parent_accounts_datasource.dart';
// import '../../../feature/main/main_reports/invoices_profit/data/datasource/pay_ways_datasource.dart' show PayWaysDataSourceImpl, PayWaysDataSource;
// import '../../../feature/main/main_reports/invoices_profit/data/datasource/users_datasource.dart';
// import '../../../feature/main/main_reports/invoices_profit/invoice_profit_imports.dart';
//
// class InvoiceProfitServiceLocator {
//   static Future<void> execute({required GetIt getIt}) async {
//     // ============================================================
//     // DATA SOURCES
//     // ============================================================
//     getIt.registerLazySingleton<ParentAccountsDataSource>(
//           () => ParentAccountsDataSourceImpl(
//             genericDataSource:
//         getIt<GenericDataSource>(),
//       ),
//     );
//
//     getIt.registerLazySingleton<CustomersDataSource>(
//           () => CustomersDataSourceImpl(
//         genericDataSource: getIt<GenericDataSource>(),
//       ),
//     );
//
//     getIt.registerLazySingleton<EmployeesDataSource>(
//           () => EmployeesDataSourceImpl(
//         genericDataSource: getIt<GenericDataSource>(),
//       ),
//     );
//
//     getIt.registerLazySingleton<CostCentersDataSource>(
//           () => CostCentersDataSourceImpl(
//         genericDataSource: getIt<GenericDataSource>(),
//       ),
//     );
//
//     getIt.registerLazySingleton<CurrenciesDataSource>(
//           () => CurrenciesDataSourceImpl(
//         genericDataSource: getIt<GenericDataSource>(),
//       ),
//     );
//
//     getIt.registerLazySingleton<UsersDataSource>(
//           () => UsersDataSourceImpl(
//         genericDataSource: getIt<GenericDataSource>(),
//       ),
//     );
//
//     getIt.registerLazySingleton<BranchesDataSource>(
//           () => BranchesDataSourceImpl(
//         genericDataSource: getIt<GenericDataSource>(),
//       ),
//     );
//
//     getIt.registerLazySingleton<PayWaysDataSource>(
//           () => PayWaysDataSourceImpl(
//         genericDataSource: getIt<GenericDataSource>(),
//       ),
//     );
//
//     getIt.registerLazySingleton<BillSourcesDataSource>(
//           () => BillSourcesDataSourceImpl(
//         genericDataSource: getIt<GenericDataSource>(),
//       ),
//     );
//
//     getIt.registerLazySingleton<InvoiceProfitDataSource>(
//           () => InvoiceProfitDataSourceImpl(
//         genericDataSource: getIt<GenericDataSource>(),
//       ),
//     );
//
//     // ============================================================
//     // BLOCS
//     // ============================================================
//     getIt.registerFactory<ParentAccountsBloc>(
//           () => ParentAccountsBloc(
//         dataSource: getIt<ParentAccountsDataSource>(),
//       ),
//     );
//
//     getIt.registerFactory<CustomersBloc>(
//           () => CustomersBloc(
//         dataSource: getIt<CustomersDataSource>(),
//       ),
//     );
//
//     getIt.registerFactory<EmployeesBloc>(
//           () => EmployeesBloc(
//         dataSource: getIt<EmployeesDataSource>(),
//       ),
//     );
//
//     getIt.registerFactory<CostCentersBloc>(
//           () => CostCentersBloc(
//         dataSource: getIt<CostCentersDataSource>(),
//       ),
//     );
//
//     getIt.registerFactory<CurrenciesBloc>(
//           () => CurrenciesBloc(
//         dataSource: getIt<CurrenciesDataSource>(),
//       ),
//     );
//
//     getIt.registerFactory<UsersBloc>(
//           () => UsersBloc(
//         dataSource: getIt<UsersDataSource>(),
//       ),
//     );
//
//     getIt.registerFactory<BranchesBloc>(
//           () => BranchesBloc(
//         dataSource: getIt<BranchesDataSource>(),
//       ),
//     );
//
//     getIt.registerFactory<PayWaysBloc>(
//           () => PayWaysBloc(
//         dataSource: getIt<PayWaysDataSource>(),
//       ),
//     );
//
//     getIt.registerFactory<BillSourcesBloc>(
//           () => BillSourcesBloc(
//         dataSource: getIt<BillSourcesDataSource>(),
//       ),
//     );
//
//
//   }
// }