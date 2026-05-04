import '../../../../../core/helper/helper.dart';

import '../../../../../core/constant/end_points.dart';
import '../../../core/services/service_locator/services_imports.dart';
import '../models/customer_model.dart';

abstract interface class LoginDataSource {
  Future<Either<Failure, CustomerModel>> login({
    required String phone,
    required String password,
  });
}

class LoginDataSourceImpl implements LoginDataSource {
  final GenericDataSource _genericDataSource;

  LoginDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, CustomerModel>> login({
    required String phone,
    required String password,
  }) async {
    final result = await _genericDataSource.fetchResult<CustomerModel>(
      endpoint: EndPoints.logIn,
      fromJson: CustomerModel.fromJson,
      queryParameters: {
        'CustomerPhone': phone,
        'passWord': password,
        'Token': '1111',
      },
    );
    return result.fold((failure) => Left(failure), (right) async {
      try {
        loggerFatal(right.toString());

        getIt<IUserCache>().cacheUserModel(right);
        return Right(right);
      } catch (e) {
        return Left(
          ParsingFailure(message: 'Failed to process token: ${e.toString()}'),
        );
      }
    });
  }
}
