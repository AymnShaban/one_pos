part of '../services_imports.dart';

class SettingsServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerFactory<SettingsBloc>(
          () => SettingsBloc(hiveService: getIt<HiveServiceImpl>()),
    );
  }
}