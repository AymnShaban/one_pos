import 'package:get_it/get_it.dart';

import '../../../../feature/main/invoices/data_source/invoices_data_source.dart';
import '../../../../feature/main/invoices/manager/invoices_bloc/invoices_bloc.dart';
import '../../../datasource/generic_data_source.dart';

class InvoicesServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerLazySingleton<InvoicesDataSource>(
          () => InvoicesDataSourceImpl(getIt<GenericDataSource>()),
    );
    getIt.registerFactory<InvoicesBloc>(
          () => InvoicesBloc(dataSource: getIt<InvoicesDataSource>()),
    );
  }
}