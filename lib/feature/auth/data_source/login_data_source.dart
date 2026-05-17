import 'dart:convert';

import '../../../../../core/helper/helper.dart';
import '../../../../../core/constant/end_points.dart';
import '../../../core/http/api_consumer.dart';
import '../../../core/services/service_locator/services_imports.dart';
import '../models/user_model.dart';

abstract interface class LoginDataSource {
  Future<Either<Failure, UserModel>> login({
    required String userName,
    required String password,
  });
}

class LoginDataSourceImpl implements LoginDataSource {
  final ApiConsumer _apiConsumer;

  LoginDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, UserModel>> login({
    required String userName,
    required String password,
  }) async {
    final config = getIt<HiveServiceImpl>().getAppConfig();
    if (config == null) {
      return Left(ServerFailure(message: 'no_configuration_found'));
    }

    final result = await _apiConsumer.post(
      EndPoints.logIn,
      data: {
        "UserName": userName,
        "PassWord": password,
        "serverName": config['Server'],
        "DBName": config['DBDescription'],
        "serverUserName": config['UserName'],
        "serverPassword": config['PassWord'],
      },
    );

    return result.fold((failure) => Left(failure), (response) async {
      try {
        final users = _parseUsers(response['data']);
        if (users.isEmpty) {
          return Left(ServerFailure(message: 'invalid_credentials'));
        }

        final user = users.first;
        await _persistUser(user);
        loggerInfo('Login success: ${user.toJson()}');
        return Right(user);
      } catch (e) {
        return Left(
          ParsingFailure(message: 'Failed to parse login response: $e'),
        );
      }
    });
  }

  List<UserModel> _parseUsers(dynamic data) {
    final decoded = data is String ? jsonDecode(data) : data;
    if (decoded is! List) return const [];
    return decoded
        .whereType<Map>()
        .map((e) => UserModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> _persistUser(UserModel user) async {
    final hive = getIt<HiveServiceImpl>();
    // Persist the typed model — this is what getUserModel() reads and what
    // the splash gate / basket / details rely on to know a user is logged in.
    await hive.cacheUserModel(user);
    await hive.saveLoggedInUser(user.toJson());
    await hive.saveUserId(user.userId);
    await hive.saveSellerName(user.userName);
    await hive.saveHaveDiscount(user.haveDiscount);
  }
}
