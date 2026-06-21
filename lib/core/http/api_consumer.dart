import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import '../../main.dart';
import '../extension/context_extension.dart';
import 'either.dart';
import 'failure.dart';

abstract final class ApiConsumer {
  Future<Either<Failure, dynamic>> get(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  });

  Future<Either<Failure, dynamic>> post(
    String url, {
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  });

  Future<Either<Failure, dynamic>> patch(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  });

  Future<Either<Failure, dynamic>> put(
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool formData = false,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  });

  Future<Either<Failure, dynamic>> delete(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, String>> downloadFile({
    required String url,
    required String savePath,
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, dynamic>> head(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, dynamic>> uploadFile(
    String url, {
    required Map<String, dynamic> formData,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  });

  void addInterceptor(Interceptor interceptor);

  void removeAllInterceptors();

  void updateHeader(Map<String, dynamic> headers);

  Future<Either<Failure, dynamic>> retryApiCall(
    Future<Either<Failure, dynamic>> Function() apiCall, {
    int retryCount = 0,
  });
}

/// Plain JSON over Bearer JWT. The token itself is injected by the Dio
/// interceptor registered in the service locator — this consumer no longer
/// knows about Basic auth, encryption keys, or per-request encrypt flags.
final class BaseApiConsumer implements ApiConsumer {
  final Dio _dio;
  final int maxRetries;
  final Duration retryDelay;

  BaseApiConsumer({
    required Dio dio,
    this.maxRetries = 2,
    this.retryDelay = const Duration(seconds: 5),
  }) : _dio = dio;

  @override
  Future<Either<Failure, dynamic>> retryApiCall(
    Future<Either<Failure, dynamic>> Function() apiCall, {
    int retryCount = 0,
  }) async {
    final result = await apiCall();
    return result.fold((failure) async {
      if (retryCount < maxRetries) {
        log("API failed, retrying attempt #${retryCount + 1}");
        await Future.delayed(retryDelay);
        return retryApiCall(apiCall, retryCount: retryCount + 1);
      } else {
        log("Max retries reached, API failed: ${failure.message}");
        return Left(failure);
      }
    }, (success) => Right(success));
  }

  @override
  Future<Either<Failure, dynamic>> get(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    Future<Either<Failure, dynamic>> apiCall() async {
      try {
        final response = await _dio.get(
          url,
          queryParameters: queryParameters,
          options: Options(headers: headers),
          cancelToken: cancelToken,
          data: data,
          onReceiveProgress: onReceiveProgress,
        );
        return Right(_wrapBody(response.data));
      } on DioException catch (e) {
        log(e.toString());
        return Left(_handleDioError(e));
      } catch (e) {
        return Left(
          UnknownFailure(message: 'An unexpected error occurred: $e'),
        );
      }
    }

    return await retryApiCall(apiCall);
  }

  @override
  Future<Either<Failure, dynamic>> head(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.head(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
      );
      return Right(_wrapBody(response.data));
    } on DioException catch (e) {
      log(e.toString());
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: 'An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> patch(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.patch(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
        data: data,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return Right(_wrapBody(response.data));
    } on DioException catch (e) {
      log(e.toString());
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: 'An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> post(
    String url, {
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        data: formData ?? data,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return Right(_wrapBody(response.data));
    } on DioException catch (e) {
      log('left $e');
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: 'An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> put(
    String url, {
    Object? data,
    bool formData = false,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      dynamic requestData = data;
      if (formData && data is Map<String, dynamic>) {
        requestData = FormData.fromMap(data);
      }
      final response = await _dio.put(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
        data: requestData,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return Right(_wrapBody(response.data));
    } on DioException catch (e) {
      log(e.toString());
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: 'An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> delete(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        url,
        queryParameters: queryParameters,
        data: data,
        options: Options(headers: headers),
        cancelToken: cancelToken,
      );
      return Right(_wrapBody(response.data));
    } on DioException catch (e) {
      log(e.toString());
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: 'An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> downloadFile({
    required String url,
    required String savePath,
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      await _dio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return Right(savePath);
    } on DioException catch (e) {
      log(e.toString());
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: 'An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> uploadFile(
    String url, {
    required Map<String, dynamic> formData,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post(
        url,
        data: FormData.fromMap(formData),
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return Right(_wrapBody(response.data));
    } on DioException catch (e) {
      log(e.toString());
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: 'An unexpected error occurred: $e'));
    }
  }

  @override
  void removeAllInterceptors() {
    _dio.options.headers.clear();
  }

  @override
  void updateHeader(Map<String, dynamic> headers) {
    _dio.options.headers.addAll(headers);
  }

  @override
  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  /// Server may return the body as a JSON string (Dio already JSON-decoded)
  /// or as a raw String we need to decode. Either way we hand callers back
  /// the parsed value — Map, List, primitive, whatever the endpoint returns.
  dynamic _wrapBody(dynamic raw) {
    if (raw is String) {
      try {
        return jsonDecode(raw);
      } catch (_) {
        return raw;
      }
    }
    return raw;
  }

  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        scaffoldMessengerKey.currentContext?.showErrorMessage(
          'تم الغاء الطلب ',
        );
        return ServerFailure(message: 'تم إلغاء الطلب ');
      case DioExceptionType.connectionTimeout:
        scaffoldMessengerKey.currentContext?.showErrorMessage(
          'انتهت مهلة الاتصال ',
        );
        return ServerFailure(message: 'انتهت مهلة الاتصال ');
      case DioExceptionType.receiveTimeout:
        scaffoldMessengerKey.currentContext?.showErrorMessage(
          'انتهت مهلة الاتصال ',
        );
        return ServerFailure(message: 'انتهت مهلة الاستقبال في الاتصال ');
      case DioExceptionType.sendTimeout:
        scaffoldMessengerKey.currentContext?.showErrorMessage(
          'انتهت مهلة الاتصال ',
        );
        return ServerFailure(message: 'انتهت مهلة الإرسال في الاتصال ');
      case DioExceptionType.badResponse:
        if (error.response?.data != null) {
          try {
            final data = error.response!.data;
            final Map<String, dynamic> decoded = data is String
                ? jsonDecode(data)
                : data;
            if (error.response?.statusCode == 503) {
              return ServerFailure(message: 'network failure ${error.message}');
            }
            if (error.response?.statusCode == 401) {
              scaffoldMessengerKey.currentContext?.showErrorMessage(
                'عاود التسجيل من فضلك',
              );
              return UnauthorizedFailure(
                message: error.message ?? 'غير مصرح لك',
              );
            }
            if (error.response?.statusCode == 413) {
              scaffoldMessengerKey.currentContext?.showErrorMessage(
                'File size is too large',
              );
              return ServerFailure(message: 'File size is too large');
            }
            if (error.response?.statusCode == 404) {
              scaffoldMessengerKey.currentContext?.showErrorMessage('404');
              return ServerFailure(message: '404');
            }
            if (error.response?.statusCode == 407) {
              log('APP IS OPENED IN ANOTHER DEVICE');
              return SyncAppFailure(message: 'تم فتح التطبيق في جهاز آخر');
            }
            if (error.response?.statusCode == 402) {
              return PaymentFailure(message: error.message ?? "");
            }
            if (error.response?.statusCode == 409) {
              log('VERIFYERROR');
              return VerifyOTPFailure(message: 'خطأ في التحقق من الكود');
            }
            if (decoded.containsKey('message')) {
              String message = decoded['message'];
              if (decoded.containsKey('result') && decoded['result'] is Map) {
                final errors = decoded['result'] as Map<String, dynamic>;
                List<String> messages = [];
                errors.forEach((key, value) {
                  if (value is List) {
                    messages.addAll(value.map((e) => '$key: $e'));
                  } else if (value is String) {
                    messages.add('$key: $value');
                  }
                });
                if (messages.isNotEmpty) {
                  scaffoldMessengerKey.currentContext?.showErrorMessage(
                    messages.first,
                  );
                }
                return ValidationFailure(
                  message: messages.first,
                  errors: messages,
                );
              }
              return ServerFailure(message: message);
            }
          } catch (e) {
            return ServerFailure(
              message:
                  'Received invalid status code: ${error.response?.statusCode}',
            );
          }
        }
        return ServerFailure(
          message:
              'Received invalid status code: ${error.response?.statusCode}',
        );
      case DioExceptionType.badCertificate:
        return ServerFailure(message: 'تعذر الاتصال ');
      case DioExceptionType.connectionError:
        scaffoldMessengerKey.currentContext?.showErrorMessage('تعذر الاتصال ');
        return NetworkFailure(message: 'تعذر الاتصال ');
      case DioExceptionType.unknown:
        return UnknownFailure(message: 'Unexpected error: ${error.message}');
    }
  }
}
