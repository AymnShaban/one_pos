import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import '../../main.dart';
import '../extension/context_extension.dart';
import '../network/encrupt.dart';
import 'either.dart';
import 'failure.dart';

abstract final class ApiConsumer {
  Future<Either<Failure, Map<String, dynamic>>> get(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    bool encrypt = true,
  });

  Future<Either<Failure, Map<String, dynamic>>> post(
    String url, {
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool encrypt = true,
  });

  Future<Either<Failure, Map<String, dynamic>>> patch(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool encrypt = true,
  });

  Future<Either<Failure, Map<String, dynamic>>> put(
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool formData = false,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool encrypt = true,
  });

  Future<Either<Failure, Map<String, dynamic>>> delete(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    bool encrypt = true,
  });

  Future<Either<Failure, String>> downloadFile({
    required String url,
    required String savePath,
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool encrypt = true,
  });

  Future<Either<Failure, Map<String, dynamic>>> head(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool encrypt = true,
  });

  Future<Either<Failure, Map<String, dynamic>>> uploadFile(
    String url, {
    required Map<String, dynamic> formData,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool encrypt = true,
  });

  void addInterceptor(Interceptor interceptor);

  void removeAllInterceptors();

  void updateHeader(Map<String, dynamic> headers);

  Future<Either<Failure, Map<String, dynamic>>> retryApiCall(
    Future<Either<Failure, Map<String, dynamic>>> Function() apiCall, {
    int retryCount = 0,
  });
}

final class BaseApiConsumer implements ApiConsumer {
  final Dio _dio;
  final int maxRetries;
  final Duration retryDelay;
  final String privateKey;
  final String publicKey;

  BaseApiConsumer({
    required Dio dio,
    required this.privateKey,
    required this.publicKey,
    int maxRetries = 5,
    Duration retryDelay = const Duration(seconds: 2),
  }) : _dio = dio,
       maxRetries = 2,
       retryDelay = const Duration(seconds: 5);

  @override
  Future<Either<Failure, Map<String, dynamic>>> retryApiCall(
    Future<Either<Failure, Map<String, dynamic>>> Function() apiCall, {
    int retryCount = 2,
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
  Future<Either<Failure, Map<String, dynamic>>> get(
      String url, {
        Map<String, dynamic>? headers,
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? data,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
        bool encrypt = false,
      }) async {
    Future<Either<Failure, Map<String, dynamic>>> apiCall() async {
      try {
        dynamic requestData = data;
        if (encrypt && data != null) {
          String encryptedData = encryptData(data, privateKey, publicKey);
          requestData = jsonEncode(encryptedData);
        }

        final response = await _dio.get(
          url,
          queryParameters: queryParameters,
          options: Options(headers: headers),
          cancelToken: cancelToken,
          data: requestData,
          onReceiveProgress: onReceiveProgress,
        );

        dynamic responseData = response.data;
        if (encrypt) {
          final decryptedText = decrypt(response.data, privateKey, publicKey);
          if (decryptedText == 'This customer exists.') {
            return Left(ServerFailure(message: decryptedText));
          }
          try {
            responseData = jsonDecode(decryptedText);
          } catch (e) {
            responseData = {'message': decryptedText};
          }
        }

        return Right(
          responseData is Map<String, dynamic>
              ? responseData
              : {'data': responseData},
        );
      } on DioException catch (e) {
        log(e.toString());
        final failure = _handleDioError(e);
        return Left(failure);
      } catch (e) {
        return Left(
          UnknownFailure(message: 'An unexpected error occurred: $e'),
        );
      }
    }

    return await retryApiCall(apiCall);
  }
  @override
  Future<Either<Failure, Map<String, dynamic>>> head(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool encrypt = false,
  }) async {
    try {
      final response = await _dio.head(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
      );

      dynamic responseData = response.data;
      if (encrypt) {
        final decryptedText = decrypt(response.data, privateKey, publicKey);
        if (decryptedText == 'This customer exists.') {
          return Left(ServerFailure(message: decryptedText));
        }
        try {
          responseData = jsonDecode(decryptedText);
        } catch (e) {
          responseData = {'message': decryptedText};
        }
      }

      return Right(
        responseData is Map<String, dynamic>
            ? responseData
            : {'data': responseData},
      );
    } on DioException catch (e) {
      log(e.toString());
      final failure = _handleDioError(e);
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure(message: 'An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> patch(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool encrypt = false,
  }) async {
    try {
      dynamic requestData = data;
      if (encrypt && data != null) {
        String encryptedData = encryptData(data, privateKey, publicKey);
        requestData = jsonEncode(encryptedData);
      }

      Response response = await _dio.patch(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
        data: requestData,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      dynamic responseData = response.data;
      if (encrypt) {
        final decryptedText = decrypt(response.data, privateKey, publicKey);
        if (decryptedText == 'This customer exists.') {
          return Left(ServerFailure(message: decryptedText));
        }
        try {
          responseData = jsonDecode(decryptedText);
        } catch (e) {
          responseData = {'message': decryptedText};
        }
      }

      return Right(
        responseData is Map<String, dynamic>
            ? responseData
            : {'data': responseData},
      );
    } on DioException catch (e) {
      log(e.toString());
      final failure = _handleDioError(e);
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure(message: 'An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> post(
    String url, {
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool encrypt = true,
  }) async {
    try {
      dynamic requestData = data;
      if (encrypt && data != null) {
        String encryptedData = encryptData(data, privateKey, publicKey);
        requestData = jsonEncode(encryptedData);
      } else if (formData != null) {
        requestData = formData;
      }

      Response response = await _dio.post(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        data: requestData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      dynamic responseData = response.data;
      if (encrypt) {
        final decryptedText = decrypt(response.data, privateKey, publicKey);
        if (decryptedText == 'This customer exists.') {
          return Left(ServerFailure(message: decryptedText));
        }
        try {
          responseData = jsonDecode(decryptedText);
        } catch (e) {
          responseData = {'message': decryptedText};
        }
      }

      return Right(
        responseData is Map<String, dynamic>
            ? responseData
            : {'data': responseData},
      );
    } on DioException catch (e) {
      log('left $e');
      log(e.toString());
      final failure = _handleDioError(e);
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure(message: 'An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> put(
    String url, {
    Object? data,
    bool formData = false,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool encrypt = false,
  }) async {
    try {
      dynamic requestData = data;
      if (encrypt && data is Map<String, dynamic>) {
        String encryptedData = encryptData(data, privateKey, publicKey);
        requestData = jsonEncode(encryptedData);
      } else if (formData && data is Map<String, dynamic>) {
        requestData = FormData.fromMap(data);
      }

      Response response = await _dio.put(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
        data: requestData,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      dynamic responseData = response.data;
      if (encrypt) {
        final decryptedText = decrypt(response.data, privateKey, publicKey);
        if (decryptedText == 'This customer exists.') {
          return Left(ServerFailure(message: decryptedText));
        }
        try {
          responseData = jsonDecode(decryptedText);
        } catch (e) {
          responseData = {'message': decryptedText};
        }
      }

      return Right(
        responseData is Map<String, dynamic>
            ? responseData
            : {'data': responseData},
      );
    } on DioException catch (e) {
      log(e.toString());
      final failure = _handleDioError(e);
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure(message: 'An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> delete(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    bool encrypt = false,
  }) async {
    try {
      dynamic requestData = data;
      if (encrypt && data != null) {
        String encryptedData = encryptData(data, privateKey, publicKey);
        requestData = jsonEncode(encryptedData);
      }

      Response response = await _dio.delete(
        url,
        queryParameters: queryParameters,
        data: requestData,
        options: Options(headers: headers),
        cancelToken: cancelToken,
      );

      dynamic responseData = response.data;
      if (encrypt) {
        final decryptedText = decrypt(response.data, privateKey, publicKey);
        if (decryptedText == 'This customer exists.') {
          return Left(ServerFailure(message: decryptedText));
        }
        try {
          responseData = jsonDecode(decryptedText);
        } catch (e) {
          responseData = {'message': decryptedText};
        }
      }

      return Right(
        responseData is Map<String, dynamic>
            ? responseData
            : {'data': responseData},
      );
    } on DioException catch (e) {
      log(e.toString());
      final failure = _handleDioError(e);
      return Left(failure);
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
    bool encrypt = false,
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

      // Note: downloadFile doesn't typically expect a JSON response to decrypt
      // If your API returns encrypted metadata, you might need to handle it separately
      return Right(savePath);
    } on DioException catch (e) {
      log(e.toString());
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: 'An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> uploadFile(
    String url, {
    required Map<String, dynamic> formData,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool encrypt = false,
  }) async {
    try {
      dynamic requestData = FormData.fromMap(formData);
      if (encrypt) {
        // Encrypt formData map before converting to FormData, if needed
        String encryptedData = encryptData(formData, privateKey, publicKey);
        requestData = jsonEncode(encryptedData);
      }

      Response response = await _dio.post(
        url,
        data: requestData,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      dynamic responseData = response.data;
      if (encrypt) {
        final decryptedText = decrypt(response.data, privateKey, publicKey);
        if (decryptedText == 'This customer exists.') {
          return Left(ServerFailure(message: decryptedText));
        }
        try {
          responseData = jsonDecode(decryptedText);
        } catch (e) {
          responseData = {'message': decryptedText};
        }
      }

      return Right(
        responseData is Map<String, dynamic>
            ? responseData
            : {'data': responseData},
      );
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
