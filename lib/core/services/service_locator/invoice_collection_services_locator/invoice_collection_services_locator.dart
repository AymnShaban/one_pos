part of '../services_imports.dart';

class InvoiceCollectionServiceLocator {
  static Future<void> init({required GetIt getIt}) async{
    getIt.registerFactory<InvoiceCollectionDataSource>(
      () => InvoiceCollectionDataSourceImpl.fromHive(),
    );
    getIt.registerFactory<InvoiceCollectionBloc>(
      () => InvoiceCollectionBloc(
        dataSource: getIt<InvoiceCollectionDataSource>(),
      ),
    );
  }
}
