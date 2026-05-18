part of '../basket_imports.dart';

abstract interface class BasketDataSource {
  Future<Either<Failure, List<ItemModel>>> getBasketItems();
}


class BasketDataSourceImpl implements BasketDataSource {
  final IBasket _basketCache;

  BasketDataSourceImpl(this._basketCache);

  @override
  Future<Either<Failure, List<ItemModel>>> getBasketItems() async {
    try {
      final items = await _basketCache.getBasketItems();
      if (items.isEmpty) {
        return Left(ParsingFailure(message: 'Basket is empty'));
      }
      return Right(items);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to fetch local basket items: ${e.toString()}'));
    }
  }
}