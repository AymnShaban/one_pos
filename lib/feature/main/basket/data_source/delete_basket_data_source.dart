import '../../../../../core/constant/end_points.dart';
import '../../../../../core/datasource/generic_data_source.dart';
import '../../../../../core/http/either.dart';
import '../../../../../core/http/failure.dart';
import '../../../../../core/services/service_locator/service_locator.dart';

import '../../../../core/local/hive_service_impl.dart';

abstract interface class DeleteBasketDataSource {
  Future<Either<Failure, void>> deleteBasketItem(int productId,String barCode);
}

class DeleteBasketDataSourceImpl implements DeleteBasketDataSource {

  final GenericDataSource _genericDataSource;

  DeleteBasketDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, void>> deleteBasketItem(int productId,String barCode) async {
    final customerId = getIt<IUserCache>().getUserModel()!.customerId;
    final queryParameters = {
      'CustomerID': customerId.toString(),
      'ProductID': productId.toString(),
      "BarCode":  barCode.toString()
    };

    final result = await _genericDataSource.postData<void>(
      endpoint: EndPoints.deleteOneItemFromBasket,
      queryParameters: queryParameters,
    );
    return result.fold(
          (failure) => Left(failure),
          (response) {
        try {
          return const Right(null); // Success, return void
        } catch (e) {
          return Left(ParsingFailure(message: 'Failed to delete basket item: ${e.toString()}'));
        }
      },
    );
  }
}