import '../../../../feature/main/main_reports/receipts_and_payments_movement_report/receipts_and_payments_movement_report_import.dart';

class ReceiptsAndPaymentsMovementServiceLocator {
  static Future<void> init({required GetIt getIt}) async {


    getIt.registerLazySingleton<ReceivedFromDataSource>(
          () => ReceivedFromDataSourceImpl(
        genericDataSource: getIt<GenericDataSource>(),
      ),
    );

    // 2. Delivered To
    getIt.registerLazySingleton<DeliveredToDataSource>(
          () => DeliveredToDataSourceImpl(
        genericDataSource: getIt<GenericDataSource>(),
      ),
    );

    // 3. Report Sources
    getIt.registerLazySingleton<ReportSourceDataSource>(
          () => ReportSourceDataSourceImpl(
        genericDataSource: getIt<GenericDataSource>(),
      ),
    );
    getIt.registerLazySingleton<VouchersDataSource>(
          () => VouchersDataSourceImpl(
        genericDataSource: getIt<GenericDataSource>(),
      ),
    );

    getIt.registerFactory<VouchersBloc>(
          () => VouchersBloc(
        dataSource: getIt<VouchersDataSource>(),
      ),
    );

    // 1. Received From Bloc
    getIt.registerFactory<ReceivedFromBloc>(
          () => ReceivedFromBloc(
        dataSource: getIt<ReceivedFromDataSource>(),
      ),
    );

    // 2. Delivered To Bloc
    getIt.registerFactory<DeliveredToBloc>(
          () => DeliveredToBloc(
        dataSource: getIt<DeliveredToDataSource>(),
      ),
    );

    // 3. Report Sources Bloc
    getIt.registerFactory<ReportSourceBloc>(
          () => ReportSourceBloc(
        dataSource: getIt<ReportSourceDataSource>(),
      ),
    );


  }
}