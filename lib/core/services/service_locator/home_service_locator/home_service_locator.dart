part of '../services_imports.dart';

class HomeServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerFactory<HomeBloc>(() => HomeBloc());
    getIt.registerFactory<NavBloc>(() => NavBloc());

 }
}