part of '../services_imports.dart';

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
