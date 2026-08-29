import '../../../shared_imports.dart';
abstract interface class ProductsDataSource {
  Future<Either<Failure, List<ProductModel>>> getProducts({String? search});
}

class ProductsDataSourceImpl implements ProductsDataSource {
  final GenericDataSource _generic;

  ProductsDataSourceImpl(this._generic);

  @override
  Future<Either<Failure, List<ProductModel>>> getProducts({String? search}) {
    final queryParams = search != null && search.isNotEmpty
        ? {'search': search}
        : null;

    return _generic.fetchData<ProductModel>(
      endpoint: EndPoints.getAllItems,
      fromJson: ProductModel.fromJson,
      queryParameters: queryParams,

    );
  }
}