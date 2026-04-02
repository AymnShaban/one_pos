import 'package:get_it/get_it.dart';

import '../../../../feature/main/sales/data_source/sales_data_source.dart';
import '../../../../feature/main/sales/manager/sales_bloc/sales_bloc.dart';
import '../../../datasource/generic_data_source.dart';

class SalesServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerLazySingleton<SalesDataSource>(
          () => SalesDataSourceImpl(getIt<GenericDataSource>()),
    );
    getIt.registerFactory<SalesBloc>(
          () => SalesBloc(dataSource: getIt<SalesDataSource>()),
    );
  }
}