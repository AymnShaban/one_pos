import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/http/either.dart';
import '../../../../core/http/failure.dart';
import '../../../core/network/encrupt.dart';
import '../models/activation_model.dart';
import '../models/user_model.dart';

const String _mainBackendUrl = 'http://15.235.51.177/TheOneAPI/api/';

const Map<String, String> _mainHeaders = {
  'Accept': 'application/json',
  'Accept-Language': 'ar',
  'Authorization':
  'Basic ZTBjOWRlMWIyZGUyNmZlMjpnOEV0eXg4VFU1Nzl2RHhKemFOMWxvM3I0NitXSkx2cWIvSU1ZZElVUkhNPQ==',
};

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

  Future<Either<Failure, bool>> checkDeviceActivation({
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
  final Dio _dio = Dio(BaseOptions(baseUrl: _mainBackendUrl));

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
      final response = await _dio.get(
        'GetDeviceConfigV2',
        queryParameters: {
          'ActivationCode': '$key1-$key2-$key3-$key4',
          'DeviceCode':     deviceCode,
          'DeviceTypeID':   1,
          'DeviceWifiMAC':  deviceWifiMAC,
          'DeviceModel':    deviceModel,
          'DeviceName':     deviceName,
          'DeviceIMEI':     deviceName,
          'DeviceToken':    'DeviceToken',
        },
        options: Options(headers: _mainHeaders),
      );

      if (response.statusCode == 200) {
        final raw = response.data;
        if (raw.toString().contains(
            'No Configuration was found for this Serial.')) {
          return Left(ServerFailure(message: 'no_configuration_found'));
        }
        final List<dynamic> list = json.decode(raw.toString());
        if (list.isEmpty) {
          return Left(ServerFailure(message: 'no_configuration_found'));
        }
        return Right(ActivationModel.fromJson(list.first));
      }
      return Left(ServerFailure(message: 'server_error'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkDeviceActivation({
    required String activationCode,
    required String deviceCode,
    required String deviceWifiMAC,
    required String deviceModel,
    required String deviceName,
  }) async {
    // ── DUMMY BYPASS ─────────────────────────────────────────────────────────
    if (activationCode == _dummyCode) return const Right(true);
    // ─────────────────────────────────────────────────────────────────────────

    try {
      final response = await _dio.get(
        'CheckDeviceActivate',
        queryParameters: {
          'ActivationCode': activationCode,
          'DeviceCode':     deviceCode,
          'DeviceTypeID':   1,
          'DeviceWifiMAC':  deviceWifiMAC,
          'DeviceModel':    deviceModel,
          'DeviceName':     deviceName,
          'DeviceIMEI':     deviceName,
          'DeviceToken':    '',
        },
        options: Options(headers: _mainHeaders),
      );
      if (response.statusCode == 200) {
        return Right(response.data.toString() == 'True');
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
      final response = await _dio.get(
        'DeviceDeactivate',
        queryParameters: {'ActivationCode': activationCode},
        options: Options(headers: _mainHeaders),
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

      final encryptedData = _encryptLoginData(
        userName:       userName,
        password:       password,
        serverName:     config.server,
        dbName:         config.dbName,
        serverUserName: config.userName,
        serverPassword: config.password,
        privateKey:     config.privateKey,
        publicKey:      config.publicKey,
      );

      final response = await companyDio.post(
        'Users/Login',
        data: json.encode(encryptedData),
      );

      if (response.statusCode == 200) {
        final decrypted = _decrypt(
          response.data,
          config.privateKey,
          config.publicKey,
        );
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

  String _encryptLoginData({
    required String userName,
    required String password,
    required String serverName,
    required String dbName,
    required String serverUserName,
    required String serverPassword,
    required String privateKey,
    required String publicKey,
  }) {
    return encryptData(
      {
        'UserName':       userName,
        'PassWord':       password,
        'serverName':     serverName,
        'DBName':         dbName,
        'serverUserName': serverUserName,
        'serverPassword': serverPassword,
      },
      privateKey,
      publicKey,
    );
  }

  String _decrypt(dynamic data, String privateKey, String publicKey) {
    return decrypt(data, privateKey, publicKey);
  }
}