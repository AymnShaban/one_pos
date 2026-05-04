import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/http/either.dart';
import '../../../../core/http/failure.dart';
import '../../../core/network/cryptography.dart';
import '../../../core/network/encrupt.dart';
import '../models/activation_model.dart';
import '../models/user_model.dart';

const String _activationBaseUrl  = 'http://54.39.132.162/CustomerActivationAPI/';
const String _activationEndpoint = 'Device/GetDeviceConfig';

// ── Dummy credentials ─────────────────────────────────────────────────────────
const String _dummyUser     = 'posaymn';
const String _dummyPassword = 'Aa@12345';
const String _dummyCode     = 'DUMM-Y000-TEST-0001';
// ─────────────────────────────────────────────────────────────────────────────

abstract interface class AuthDataSource {
  Future<Either<Failure, ActivationModel>> checkActivationCode({
    required String key1,
    required String key2,
    required String key3,
    required String key4,
    required String deviceCode,
    required String deviceWifiMAC,
    required String deviceModel,
    required String deviceName,
  });

  Future<Either<Failure, void>> checkDeviceActivation({
    required String activationCode,
    required String deviceCode,
    required String deviceWifiMAC,
    required String deviceModel,
    required String deviceName,
  });

  Future<Either<Failure, void>> deactivateDevice({
    required String activationCode,
  });

  Future<Either<Failure, UserModel>> login({
    required String userName,
    required String password,
    required ActivationModel config,
  });
}

class AuthDataSourceImpl implements AuthDataSource {
  final Dio _activationDio = Dio(BaseOptions(baseUrl: _activationBaseUrl));

  @override
  Future<Either<Failure, ActivationModel>> checkActivationCode({
    required String key1,
    required String key2,
    required String key3,
    required String key4,
    required String deviceCode,
    required String deviceWifiMAC,
    required String deviceModel,
    required String deviceName,
  }) async {
    try {
      final bodyMap = {
        'activationCode': '$key1-$key2-$key3-$key4',
        'deviceCode':     deviceCode,
        'deviceTypeID':   1,
        'deviceWifiMAC':  deviceWifiMAC,
        'deviceModel':    deviceModel,
        'deviceName':     deviceName,
        'deviceIMEI':     deviceName,
        'deviceToken':    'DeviceToken',
      };
      final body = json.encode(bodyMap);
      debugPrint('[Activation] >>> request body (plain): $body');
      final signed = signRequest(body);
      debugPrint('[Activation] >>> signed headers: ${signed.toMap()}');

      final response = await _activationDio.post(
        _activationEndpoint,
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept':       '*/*',
            ...signed.toMap(),
          },
          responseType: ResponseType.plain,
          validateStatus: (_) => true,
        ),
      );

      debugPrint('[Activation] <<< status: ${response.statusCode}');
      debugPrint('[Activation] <<< response headers: ${response.headers.map}');
      debugPrint('[Activation] <<< response body: ${response.data}');
      if (response.statusCode != 200) {
        return Left(ServerFailure(
          message: 'server_error_${response.statusCode}: ${response.data}',
        ));
      }

      if (response.statusCode == 200) {
        final raw = response.data?.toString().trim() ?? '';
        log('[Activation] raw encrypted response: $raw');
        if (raw.isEmpty ||
            raw.contains('No Configuration was found for this Serial.')) {
          return Left(ServerFailure(message: 'no_configuration_found'));
        }

        // Backend returns the encrypted payload either as a bare base64 string
        // or wrapped in quotes. Strip surrounding quotes if present.
        final cipher = raw.startsWith('"') && raw.endsWith('"')
            ? raw.substring(1, raw.length - 1)
            : raw;

        final decrypted = await decryptAesGcm(cipher);
        log('[Activation] decrypted response: $decrypted');
        final dynamic parsed = json.decode(decrypted);

        Map<String, dynamic>? configJson;
        if (parsed is List && parsed.isNotEmpty) {
          configJson = Map<String, dynamic>.from(parsed.first);
        } else if (parsed is Map) {
          configJson = Map<String, dynamic>.from(parsed);
        }

        if (configJson == null) {
          return Left(ServerFailure(message: 'no_configuration_found'));
        }
        return Right(ActivationModel.fromJson(configJson));
      }
      return Left(ServerFailure(message: 'server_error'));
    } on DioException catch (e, st) {
      debugPrint('[Activation] !!! DioException type: ${e.type}');
      debugPrint('[Activation] !!! DioException message: ${e.message}');
      debugPrint('[Activation] !!! DioException status: ${e.response?.statusCode}');
      debugPrint('[Activation] !!! DioException response headers: ${e.response?.headers.map}');
      debugPrint('[Activation] !!! DioException response body: ${e.response?.data}');
      debugPrint('[Activation] !!! DioException request data: ${e.requestOptions.data}');
      debugPrint('[Activation] !!! DioException request headers: ${e.requestOptions.headers}');
      debugPrint('[Activation] !!! DioException stacktrace: $st');
      return Left(ServerFailure(
        message: 'server_error_${e.response?.statusCode}: ${e.response?.data}',
      ));
    } catch (e, st) {
      debugPrint('[Activation] !!! unexpected error: $e');
      debugPrint('[Activation] !!! stacktrace: $st');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> checkDeviceActivation({
    required String activationCode,
    required String deviceCode,
    required String deviceWifiMAC,
    required String deviceModel,
    required String deviceName,
  }) async {
    // ── DUMMY BYPASS ─────────────────────────────────────────────────────────
    if (activationCode == _dummyCode) return const Right(null);
    // ─────────────────────────────────────────────────────────────────────────

    try {
      final bodyMap = {
        'activationCode': activationCode,
        'deviceCode':     deviceCode,
        'deviceTypeID':   1,
        'deviceWifiMAC':  deviceWifiMAC,
        'deviceModel':    deviceModel,
        'deviceName':     deviceName,
        'deviceIMEI':     deviceName,
        'deviceToken':    'DeviceToken',
      };
      final body = json.encode(bodyMap);
      final signed = signRequest(body);

      final response = await _activationDio.post(
        _activationEndpoint,
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept':       '*/*',
            ...signed.toMap(),
          },
        ),
      );

      if (response.statusCode == 200) {
        final raw = response.data;
        final Map<String, dynamic> data = raw is Map
            ? Map<String, dynamic>.from(raw)
            : Map<String, dynamic>.from(json.decode(raw.toString()));

        final isSuccess = data['isSuccess'] == true;
        final value     = data['value'] == true;

        if (isSuccess && value) return const Right(null);
        return Left(ServerFailure(message: 'device_deactivated'));
      }
      return Left(ServerFailure(message: 'server_error'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deactivateDevice({
    required String activationCode,
  }) async {
    try {
      final signed = signRequest('');

      final response = await _activationDio.get(
        'Device/DeviceDeactivate',
        queryParameters: {'activationCode': activationCode},
        options: Options(
          headers: {
            'Accept': '*/*',
            ...signed.toMap(),
          },
        ),
      );
      if (response.statusCode == 200) return const Right(null);
      return Left(ServerFailure(message: 'deactivation_error'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> login({
    required String userName,
    required String password,
    required ActivationModel config,
  }) async {
    // ── DUMMY BYPASS ─────────────────────────────────────────────────────────
    if (userName.trim() == _dummyUser &&
        password.trim() == _dummyPassword) {
      const user = UserModel(
        userId:          1,
        userName:        _dummyUser,
        fullUserName:    'أيمن شعبان',
        haveDiscount:    1,
        userPermissions: [],
      );
      return const Right(user);
    }
    // ─────────────────────────────────────────────────────────────────────────

    try {
      final companyDio = Dio(
        BaseOptions(
          baseUrl:
          'http://${config.server}/${config.baseUrl.isNotEmpty ? config.baseUrl : 'TheOneAPI/api/'}',
          headers: {'Authorization': 'Basic ${config.authorization}'},
        ),
      );

      final loginPayload = {
        'UserName':       userName,
        'PassWord':       password,
        'serverName':     config.server,
        'DBName':         config.dbName,
        'serverUserName': config.userName,
        'serverPassword': config.password,
      };
      log('[Login] request body (plain): ${json.encode(loginPayload)}');
      final encryptedData = encryptData(
        loginPayload,
        config.privateKey,
        config.publicKey,
      );
      log('[Login] request body (encrypted): $encryptedData');

      final response = await companyDio.post(
        'Users/Login',
        data: json.encode(encryptedData),
      );

      if (response.statusCode == 200) {
        log('[Login] raw encrypted response: ${response.data}');
        final decrypted = _decrypt(
          response.data,
          config.privateKey,
          config.publicKey,
        );
        log('[Login] decrypted response: $decrypted');
        final List<dynamic> list = json.decode(decrypted);
        if (list.isEmpty) {
          return Left(ServerFailure(message: 'invalid_credentials'));
        }
        return Right(UserModel.fromJson(list.first));
      }
      return Left(ServerFailure(message: 'login_failed'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  String _decrypt(dynamic data, String privateKey, String publicKey) {
    return decrypt(data, privateKey, publicKey);
  }
}