part of '../basket_imports.dart';

abstract interface class DeleteBasketDataSource {
  Future<Either<Failure, void>> deleteBasketItem(int productId,String barCode);
}

class DeleteBasketDataSourceImpl implements DeleteBasketDataSource {
  final IBasket _basketCache;

  DeleteBasketDataSourceImpl(this._basketCache);

  @override
  Future<Either<Failure, void>> deleteBasketItem(int productId, String barCode) async {
    try {
      await _basketCache.deleteBasketItem(productId, barCode);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to delete from local basket: ${e.toString()}'));
    }
  }
}