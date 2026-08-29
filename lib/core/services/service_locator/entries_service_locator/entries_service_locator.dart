
import '../../../../feature/main/entries/entries_imports.dart';

class EntriesServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerLazySingleton<EntriesDataSource>(
          () => EntriesDataSourceImpl(getIt<GenericDataSource>()),
    );
    getIt.registerFactory<EntriesBloc>(
          () => EntriesBloc(dataSource: getIt<EntriesDataSource>()),
    );
    getIt.registerFactory<FillAccountsBloc>(
          () => FillAccountsBloc(dataSource: getIt<EntriesDataSource>()),
    );getIt.registerFactory<MainAccountsBloc>(
          () => MainAccountsBloc(dataSource: getIt<EntriesDataSource>()),
    );
    getIt.registerFactory<VoucherCreationBloc>(
          () => VoucherCreationBloc(dataSource: getIt<EntriesDataSource>()),
    );
    getIt.registerFactory<JournalEntryBloc>(
          () => JournalEntryBloc(dataSource: getIt<EntriesDataSource>()),
    );
  }
}