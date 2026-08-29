part of 'services_imports.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  getIt.registerLazySingleton<Dio>(
        () => Dio(
      BaseOptions(
        baseUrl: EndPoints.baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Accept-Language': 'ar',
          'Content-Type': 'application/json',
        },
      ),
    )
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            final hive = getIt<HiveServiceImpl>();

            // BaseUrl الخاص بالعميل بعد Activation
            final activatedBaseUrl = hive.getBaseUrl();

            if (activatedBaseUrl != null &&
                activatedBaseUrl.trim().isNotEmpty) {
              options.baseUrl = activatedBaseUrl;
            } else {
              options.baseUrl = EndPoints.baseUrl;
            }

            // JWT فقط لو المستخدم عامل Login
            final token = hive.getJwtToken();

            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }

            handler.next(options);
          },
        ),
      )
      ..interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
        ),
      ),
  );
  getIt.registerLazySingleton<ApiConsumer>(
    () => BaseApiConsumer(dio: getIt<Dio>()),
  );
  getIt.registerLazySingleton<GenericDataSource>(
    () => GenericDataSource(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<ConnectivityService>(
    () => ConnectivityService.instance,
  );

  getIt.registerSingleton<SyncManager>(SyncManager());
  await AuthServiceLocator.execute(getIt: getIt);
  await HomeServiceLocator.init(getIt: getIt);
  await HiveServiceLocator.init(getIt: getIt);
  await SalesServiceLocator.init(getIt: getIt);
  await BasketServiceLocator.init(getIt: getIt);
  await InvoicesServiceLocator.init(getIt: getIt);
  await ReportsServiceLocator.init(getIt: getIt);
  await SettingsServiceLocator.init(getIt: getIt);
  await NewInvoiceServiceLocator.init(getIt: getIt);
  await InvoiceSetupServiceLocator.init(getIt: getIt);
  await InvoiceCollectionServiceLocator.init(getIt: getIt);
  await LiveSalesReportServiceLocator.init(getIt: getIt);
  await EntriesServiceLocator.init(getIt: getIt);
  await BarrenServiceLocator.init(getIt: getIt);
  await InvoiceProfitServiceLocator.init(getIt: getIt);
  await ExpenseAnalysisServiceLocator.init(getIt: getIt);
  await RevenueAnalysisServiceLocator.init(getIt: getIt);
  await ItemProfitServiceLocator.init(getIt: getIt);
  await ReceiptsAndPaymentsMovementServiceLocator.init(getIt: getIt);
  await CustomerAccountStatementServiceLocator.init(getIt: getIt);
  await BranchProfitServiceLocator.init(getIt: getIt);
  await ItemMovementServiceLocator.init(getIt: getIt);
  await ItemMovementBalanceServiceLocator.init(getIt: getIt);


}
