part of '../basket_imports.dart';

abstract interface class AddToBasketDataSource {
  Future<Either<Failure, void>> addToBasket(AddToBasketRequest request);
}
// feature/main/details/data_source/add_to_basket_data_source.dart
class AddToBasketDataSourceImpl implements AddToBasketDataSource {
  final IBasket _basketCache;

  AddToBasketDataSourceImpl(this._basketCache);

  @override
  Future<Either<Failure, void>> addToBasket(AddToBasketRequest request) async {
    try {
      if (request.item != null) {
        await _basketCache.saveBasketItem(request.item!);
        return const Right(null);
      } else {
        return Left(ParsingFailure(message: 'Product info missing for local storage'));
      }
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to save to local basket: ${e.toString()}'));
    }
  }
}