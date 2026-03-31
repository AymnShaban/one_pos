import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../constant/end_points.dart';
import '../../datasource/generic_data_source.dart';
import '../../helper/connectivity_service.dart';
import '../../helper/sync_manager.dart';
import '../../http/api_consumer.dart';
import '../../network/encrupt.dart';
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
}
