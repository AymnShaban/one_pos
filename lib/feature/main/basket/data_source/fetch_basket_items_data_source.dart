part of '../basket_imports.dart';

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
        'CustomerID': getIt<IUserCache>().getUserModel()?.id,
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