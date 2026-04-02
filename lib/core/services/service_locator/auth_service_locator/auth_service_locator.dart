import 'package:get_it/get_it.dart';

import '../../../../feature/auth/bloc/areas_bloc/areas_bloc.dart';
import '../../../../feature/auth/bloc/governorates_bloc/governorates_bloc.dart';
import '../../../../feature/auth/bloc/log_in_bloc/log_in_bloc.dart';
import '../../../../feature/auth/data_source/login_data_source.dart';
import '../../../datasource/generic_data_source.dart';

class AuthServiceLocator {
  static Future<void> execute({required GetIt getIt}) async {


    getIt.registerLazySingleton<LoginDataSource>(
      () => LoginDataSourceImpl(getIt<GenericDataSource>()),
    );

    getIt.registerFactory<LoginBloc>(() => LoginBloc(loginDataSource: getIt()));
    getIt.registerFactory<AreasBloc>(
          () => AreasBloc(getIt()),
    );
    // GovernoratesBloc Bloc
    getIt.registerFactory<GovernoratesBloc>(
          () => GovernoratesBloc(getIt()),
    );
  }
}
