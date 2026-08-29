part of '../services_imports.dart';

class SettingsServiceLocator {
  static Future<void> init({required GetIt getIt}) async {



// Register SettingsBloc مع AuthDataSource
    getIt.registerFactory<SettingsBloc>(
          () => SettingsBloc(
        hiveService: getIt<HiveServiceImpl>(),
        authDataSource: getIt<AuthDataSource>(), // ✅ أضف هذا
      ),
    );
  }
}