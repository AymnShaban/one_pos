import '../../../../../core/datasource/generic_data_source.dart';
import '../../../../../core/http/either.dart';
import '../../../../../core/http/failure.dart';
import '../../../../../core/models/item_model.dart';
import '../../../../../core/params/pagination_params.dart';
import '../../../../../core/constant/end_points.dart';

abstract interface class SalesDataSource {
  Future<Either<Failure, List<ItemModel>>> getProducts({
    required int page,
    required int limit,
    String? search,
    String? categoryId,
  });
}

class SalesDataSourceImpl implements SalesDataSource {
  final GenericDataSource _genericDataSource;

  SalesDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<ItemModel>>> getProducts({
    required int page,
    required int limit,
    String? search,
    String? categoryId,
  }) {
    return _genericDataSource.fetchData<ItemModel>(
      endpoint: EndPoints.subCategoryProducts,
      paginationParams: PaginationParams(page: page, limit: limit),
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (categoryId != null && categoryId.isNotEmpty) 'categoryId': categoryId,
      },
      fromJson: ItemModel.fromJson,
    );
  }
}