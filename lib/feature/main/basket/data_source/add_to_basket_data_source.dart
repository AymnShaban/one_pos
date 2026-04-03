part of '../basket_imports.dart';

abstract interface class AddToBasketDataSource {
  Future<Either<Failure, void>> addToBasket(AddToBasketRequest request);
}
// feature/main/details/data_source/add_to_basket_data_source.dart
class AddToBasketDataSourceImpl implements AddToBasketDataSource {
  final GenericDataSource _genericDataSource;

  AddToBasketDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, void>> addToBasket(AddToBasketRequest request) async {
    final result = await _genericDataSource.postData<void>(
      endpoint: EndPoints.addToBasket,
      data: request.toJson(),

    );
    return result.fold(
          (failure) => Left(failure),
          (response) {
        try {
          return const Right(null); // Success, return void
        } catch (e) {
          return Left(ParsingFailure(message: 'Failed to process add to basket response: ${e.toString()}'));
        }
      },
    );
  }
}