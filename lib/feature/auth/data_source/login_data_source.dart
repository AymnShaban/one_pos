import '../../../../../core/helper/helper.dart';
import '../../../../../core/constant/end_points.dart';
import '../../../core/http/api_consumer.dart';
import '../../../core/services/service_locator/services_imports.dart';
import '../models/user_model.dart';

abstract interface class LoginDataSource {
  Future<Either<Failure, UserModel>> login({
    required String userName,
    required String password,
    bool rememberMe = true,
  });
}

class LoginDataSourceImpl implements LoginDataSource {
  final ApiConsumer _apiConsumer;

  LoginDataSourceImpl(this._apiConsumer);

  /// `POST /api/Auth/login`
  ///
  ///     { "userName": "...", "password": "...", "rememberMe": true }
  ///
  /// returns a single user object (no list wrapping) carrying the JWT in
  /// `token`. We persist both the typed [UserModel] (for splash gating /
  /// name display) and the raw token (for the Dio interceptor).
  @override
  Future<Either<Failure, UserModel>> login({
    required String userName,
    required String password,
    bool rememberMe = true,
  }) async {
    final result = await _apiConsumer.post(
      EndPoints.logIn,
      data: {
        'userName': userName,
        'password': password,
        'rememberMe': rememberMe,
      },
    );

    return result.fold((failure) => Left(failure), (response) async {
      try {
        if (response is! Map) {
          return Left(ServerFailure(
              message: 'Unexpected login response shape: $response'));
        }
        final map = Map<String, dynamic>.from(response);
        final token = map['token'] as String?;
        if (token == null || token.isEmpty) {
          return Left(ServerFailure(message: 'invalid_credentials'));
        }
        final user = UserModel.fromJson(map);
        await _persist(user);
        loggerInfo('Login success for ${user.userName} (uid=${user.userId})');
        return Right(user);
      } catch (e) {
        return Left(
          ParsingFailure(message: 'Failed to parse login response: $e'),
        );
      }
    });
  }

  Future<void> _persist(UserModel user) async {
    final hive = getIt<HiveServiceImpl>();
    await hive.saveJwtToken(user.token);
    await hive.cacheUserModel(user);
    await hive.saveLoggedInUser(user.toJson());
    await hive.saveUserId(user.userId);
    await hive.saveSellerName(user.userName);
    await hive.saveHaveDiscount(user.haveDiscount);
  }
}
