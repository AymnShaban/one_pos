import '../../../../../../core/constant/end_points.dart';
import '../../../../../../core/datasource/generic_data_source.dart';
import '../../../../../../core/http/either.dart';
import '../../../../../../core/http/failure.dart';
import '../models/add_to_favorite_request.dart';
import '../models/favorite_model.dart';

abstract interface class FavoriteDataSource {
  Future<Either<Failure, void>> addFavorite(AddAndDeleteFavoriteRequest request);
  Future<Either<Failure, void>> deleteFavorite(AddAndDeleteFavoriteRequest request);
  Future<Either<Failure, List<FavoriteModel>>> getFavorite({required String customerPhone});
}

class FavoriteDataSourceImpl implements FavoriteDataSource {
  final GenericDataSource _genericDataSource;

  FavoriteDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, void>> addFavorite(AddAndDeleteFavoriteRequest request) async {
    final result = await _genericDataSource.postData<void>(
      endpoint: EndPoints.addFavorite,
      data: request.toJson(),
    );
    return result.fold(
          (failure) => Left(failure),
          (response) {
        try {
          return const Right(null);
        } catch (e) {
          return Left(ParsingFailure(message: 'Failed to process favorite response: ${e.toString()}'));
        }
      },
    );
  }

  @override
  Future<Either<Failure, void>> deleteFavorite(AddAndDeleteFavoriteRequest request) async {
    final result = await _genericDataSource.deleteData<void>(
      endpoint: EndPoints.deleteFavorite,
      queryParameters: request.toJson(),
    );
    return result.fold(
          (failure) => Left(failure),
          (response) {
        try {
          return const Right(null); // Success, return void
        } catch (e) {
          return Left(ParsingFailure(message: 'Failed to process delete favorite response: ${e.toString()}'));
        }
      },
    );
  }


  @override
  Future<Either<Failure, List<FavoriteModel>>> getFavorite({required String customerPhone}) async {
    final result = await _genericDataSource.fetchData<FavoriteModel>(
      endpoint: EndPoints.getFavorite,
      fromJson: FavoriteModel.fromJson,
      queryParameters: {'CustomerPhone': customerPhone},
    );
    return result.fold(
          (failure) => Left(failure),
          (items) {
        try {
          return Right(items);
        } catch (e) {
          return Left(ParsingFailure(message: 'Failed to process favorite items: ${e.toString()}'));
        }
      },
    );
  }
}