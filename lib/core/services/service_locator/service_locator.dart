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
      // Inject the Bearer token freshly from Hive on every request — so
      // requests fired before login (e.g. activation) skip the header, and
      // requests after login pick up the new JWT without recreating Dio.
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            final token = getIt<HiveServiceImpl>().getJwtToken();
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
  await BarrenServiceLocator.init(getIt: getIt);
}
