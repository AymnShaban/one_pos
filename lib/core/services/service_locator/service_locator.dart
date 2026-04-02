import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:one_pos/core/services/service_locator/sales_service_locator/sales_service_locator.dart';
import '../../constant/end_points.dart';
import '../../datasource/generic_data_source.dart';
import '../../helper/connectivity_service.dart';
import '../../helper/sync_manager.dart';
import '../../http/api_consumer.dart';
import '../../network/encrupt.dart';
import 'auth_service_locator/auth_service_locator.dart';
import 'basket_service_locator/basket_service_locator.dart';
import 'favorite_service_locator/favorite_service_locator.dart';
import 'hive_service_locator/hive_service_locator.dart';
import 'home_service_locator/home_service_locator.dart';
final getIt = GetIt.instance;

Future<void> setup() async {
  getIt.registerLazySingleton<Dio>(
    () =>
        Dio(
            BaseOptions(
              baseUrl: EndPoints.baseUrl,
              receiveDataWhenStatusError: true,
              connectTimeout: const Duration(seconds: 30),
              // Add this to avoid quick timeouts
              receiveTimeout: const Duration(seconds: 30),
              // Add this too
              sendTimeout: const Duration(seconds: 30),
              headers: {
                'Accept': 'application/json',
                'Accept-Language': 'ar',
                'Authorization': basicToken,
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
    () => BaseApiConsumer(
      dio: getIt<Dio>(),
      privateKey: privateKey,
      publicKey: publicKey,
    ),
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
  await FavoriteServiceLocator.init(getIt: getIt);
}
