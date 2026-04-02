// feature/basket/data_source/basket_data_source.dart (unchanged)

import '../../../../../core/local/hive_service_impl.dart';
import '../../../../../core/services/service_locator/service_locator.dart';

import '../../../../core/constant/end_points.dart';
import '../../../../core/datasource/generic_data_source.dart';
import '../../../../core/http/either.dart';
import '../../../../core/http/failure.dart';
import '../models/basket_model.dart';

abstract interface class BasketDataSource {
  Future<Either<Failure, List<BasketItemModel>>> getBasketItems();
}


class BasketDataSourceImpl implements BasketDataSource {
  final GenericDataSource _genericDataSource;

  BasketDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<BasketItemModel>>> getBasketItems() async {
    final result = await _genericDataSource.fetchData<BasketItemModel>(
      endpoint: EndPoints.getCustomerBasket,
      fromJson: BasketItemModel.fromJson,
      queryParameters: {
        'CustomerID': getIt<IUserCache>().getUserModel()!.customerId.toString()
      }
    );
    return result.fold(
          (failure) => Left(failure),
          (items) {
        try {
          if (items.isEmpty) {
            return Left(ParsingFailure(message: 'Basket is empty'));
          }
          return Right(items);
        } catch (e) {
          return Left(ParsingFailure(message: 'Failed to process basket items: ${e.toString()}'));
        }
      },
    );
  }
}