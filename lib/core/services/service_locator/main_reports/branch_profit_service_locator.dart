


import '../../../../feature/main/main_reports/branch_profit_report/branch_profit_import.dart';

class BranchProfitServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerFactory<BranchProfitDataSource>(
          () => BranchProfitDataSourceImpl(genericDataSource: getIt()),
    );
    getIt.registerFactory<BranchProfitBloc>(
          () => BranchProfitBloc(dataSource: getIt()),
    );
  }
}