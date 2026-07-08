import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import '../http/api_consumer.dart';
import '../http/either.dart';
import '../http/failure.dart';
import '../params/pagination_params.dart';

/// Plain-JSON façade over [ApiConsumer]. The Bearer token is injected by the
/// Dio interceptor in the service locator — this layer only deals in maps
/// and lists. Server responses are expected to be either a list (for
/// collection endpoints) or an object (for single-result endpoints). When
/// the consumer wraps a primitive it lands as `{'data': value}` — both
/// shapes are handled below.
class GenericDataSource {
  final ApiConsumer _apiConsumer;

  GenericDataSource(this._apiConsumer);

  Future<Either<Failure, List<T>>> fetchData<T>({
    required String endpoint,
    PaginationParams? paginationParams,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final result = await _apiConsumer.get(
      endpoint,
      queryParameters: {
        if (paginationParams != null) ...paginationParams.toJson(),
        if (queryParameters != null) ...queryParameters,
      }..removeWhere((key, value) => value == null || value == ''),
      headers: headers,
      data: data,
    );
    return result.fold((left) => Left(left), (right) {
      try {
        final list = _asList(right);
        final items = list
            .whereType<Map>()
            .map((e) => fromJson(Map<String, dynamic>.from(e)))
            .toList();
        return Right(items);
      } catch (e, stackTrace) {
        log(stackTrace.toString());
        log(e.toString());
        return const Right([]);
      }
    });
  }

  Future<Either<Failure, T>> fetchResult<T>({
    required String endpoint,
    PaginationParams? params,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    final result = await _apiConsumer.get(
      endpoint,
      data: data,
      queryParameters: {
        if (params != null) ...params.toJson(),
        if (queryParameters != null) ...queryParameters,
      },
      headers: headers,
    );
    return result.fold((left) => Left(left), (right) {
      try {
        if (T == String) {
          return Right(right is String ? right as T : jsonEncode(right) as T);
        }
        final map = _asMap(right);
        return Right(fromJson!(map));
      } catch (e, stackTrace) {
        log(stackTrace.toString(), name: "stacktrace");
        log(e.toString(), name: "error");
        return Left(ParsingFailure(message: e.toString()));
      }
    });
  }

  Future<Either<Failure, T>> postData<T>({
    required String endpoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    final result = await _apiConsumer.post(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
    );
    return result.fold((left) => Left(left), (right) {
      try {
        if (T == Null) {
          return Right(null as T);
        } else if (T == String) {
          log('right: $right');
          // Business-rule rejections that come back as a non-JSON string get
          // wrapped by the consumer as {'data': '<msg>'} or {'message': ...}
          // — surface those as a failure instead of a fake-success.
          if (right is Map) {
            // A saved invoice comes back as {message, invoiceID, invoiceNo}.
            // Only treat a message-bearing body as a rejection when there's
            // no invoice id (either casing) — otherwise it's a real success.
            final hasInvoiceId =
                right['invoiceID'] != null || right['InvoiceID'] != null;
            if (!hasInvoiceId && right['message'] is String) {
              return Left(ServerFailure(message: right['message'] as String));
            }
          }
          return Right(jsonEncode(right) as T);
        } else if (T == int) {
          if (right is Map) {
            return Right((right['result'] ?? 0) as T);
          }
          return Right((right is int ? right : 0) as T);
        } else {
          return Right(null as T);
        }
      } catch (e, stackTrace) {
        log(stackTrace.toString());
        log(e.toString());
        return Left(ParsingFailure(message: e.toString()));
      }
    });
  }

  Future<Either<Failure, T>> postFormData<T>({
    required String endpoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    final processedData = _processFormData(data ?? {});

    final result = await _apiConsumer.uploadFile(
      endpoint,
      formData: await processedData,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );

    return result.fold((left) => Left(left), (right) {
      try {
        if (T == Null) {
          return Right(null as T);
        } else if (T == int) {
          return Right(((right is Map ? right['result'] : null) ?? 0) as T);
        } else if (T == String) {
          log('right: $right');
          return Right(
              ((right is Map ? right['redirect_url'] : null) ?? "") as T);
        } else {
          return Right(null as T);
        }
      } catch (e, stackTrace) {
        log(stackTrace.toString());
        log(e.toString());
        return Left(ParsingFailure(message: e.toString()));
      }
    });
  }

  Future<Map<String, dynamic>> _processFormData(
    Map<String, dynamic> data,
  ) async {
    final processed = <String, dynamic>{};

    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value is File) {
        final file = value;
        final fileName = file.path.split('/').last;
        processed[key] = await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        );
      } else if (value is List) {
        processed.remove(key);
        for (int i = 0; i < value.length; i++) {
          if (value[i] is File) {
            final file = value[i] as File;
            final fileName = file.path.split('/').last;
            processed['$key[$i]'] = await MultipartFile.fromFile(
              file.path,
              filename: fileName,
            );
          } else {
            processed['$key[$i]'] = value[i];
          }
        }
      } else if (value is Map) {
        try {
          final stringMap = Map<String, dynamic>.from(value);
          processed[key] = await _processFormData(stringMap);
        } catch (e) {
          final convertedMap = <String, dynamic>{};
          value.forEach((k, v) => convertedMap[k.toString()] = v);
          processed[key] = await _processFormData(convertedMap);
        }
      } else {
        processed[key] = value;
      }
    }

    return processed;
  }

  Future<Either<Failure, T>> deleteData<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    final result = await _apiConsumer.delete(
      endpoint,
      queryParameters: queryParameters,
      headers: headers,
    );
    return result.fold((left) => Left(left), (right) {
      try {
        if (T == Null) {
          return Right(null as T);
        } else if (T == int) {
          return Right(((right is Map ? right['id'] : null) ?? 0) as T);
        } else if (T == String) {
          log('right: $right');
          return Right(
              ((right is Map ? right['redirect_url'] : null) ?? "") as T);
        } else {
          return Right(null as T);
        }
      } catch (e, stackTrace) {
        log(stackTrace.toString());
        log(e.toString());
        return Left(ParsingFailure(message: e.toString()));
      }
    });
  }

  Future<Either<Failure, T>> patchData<T>({
    required String endpoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    final result = await _apiConsumer.patch(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
    );
    return result.fold((left) => Left(left), (right) {
      try {
        if (T == Null) {
          return Right(null as T);
        } else if (T == int) {
          return Right(((right is Map ? right['id'] : null) ?? 0) as T);
        } else if (T == String) {
          log('right: $right');
          return Right(
              ((right is Map ? right['redirect_url'] : null) ?? "") as T);
        } else {
          return Right(null as T);
        }
      } catch (e, stackTrace) {
        log(stackTrace.toString());
        log(e.toString());
        return Left(ParsingFailure(message: e.toString()));
      }
    });
  }

  Future<Either<Failure, T>> updateData<T>({
    required String endpoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    final result = await _apiConsumer.put(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
    );
    return result.fold((left) => Left(left), (right) {
      try {
        if (T == Null) {
          return Right(null as T);
        } else if (T == int) {
          return Right(((right is Map ? right['id'] : null) ?? 0) as T);
        } else if (T == String) {
          log('right: $right');
          return Right(
              ((right is Map ? right['redirect_url'] : null) ?? "") as T);
        } else {
          return Right(null as T);
        }
      } catch (e, stackTrace) {
        log(stackTrace.toString());
        log(e.toString());
        return Left(ParsingFailure(message: e.toString()));
      }
    });
  }

  Future<Either<Failure, T>> head<T>({
    required String endpoint,
    required int id,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    final result = await _apiConsumer.head(
      endpoint,
      queryParameters: queryParameters,
      headers: headers,
    );
    return result.fold((left) => Left(left), (right) {
      try {
        if (T == Null) {
          return Right(null as T);
        } else if (T == String) {
          log('right: $right');
          return Right(
              ((right is Map ? right['redirect_url'] : null) ?? "") as T);
        } else {
          return Right(null as T);
        }
      } catch (e, stackTrace) {
        log(stackTrace.toString());
        log(e.toString());
        return Left(ParsingFailure(message: e.toString()));
      }
    });
  }

  // ── helpers ─────────────────────────────────────────────────────────────

  /// The consumer hands back whatever JSON the server returned, with a tiny
  /// fallback that wraps primitives as `{'data': value}`. Endpoints that
  /// return a list end up here as a real `List` (top-level array) or as
  /// `{'data': [...]}` — handle both shapes.
  List<dynamic> _asList(dynamic raw) {
    if (raw is List) return raw;
    if (raw is Map && raw['data'] is List) return raw['data'] as List;
    if (raw is Map && raw['result'] is List) return raw['result'] as List;
    return const [];
  }

  Map<String, dynamic> _asMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return {'data': raw};
  }
}
