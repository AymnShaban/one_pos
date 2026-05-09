import '../../../../../core/constant/end_points.dart';
import '../../../../../core/datasource/generic_data_source.dart';
import '../../../../../core/http/either.dart';
import '../../../../../core/http/failure.dart';

import '../models/products_details_model.dart';


abstract interface class ProductDetailsDataSource {
  Future<Either<Failure, ProductDetailsModel>> getProductDetails({
    required int productId,
    required String customerPhone,
    required int customerId,
  });
}

class ProductDetailsDataSourceImpl implements ProductDetailsDataSource {
  final GenericDataSource _genericDataSource;

  ProductDetailsDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, ProductDetailsModel>> getProductDetails({
    required int productId,
    required String customerPhone,
    required int customerId,
  }) async {
    final result = await _genericDataSource.fetchData<ProductDetailsModel>(
      endpoint: EndPoints.productDetails,
      queryParameters: {
        'ProductId': productId.toString(),
        'CustomerPhone': customerPhone,
        'CustomerID': customerId.toString(),
      },
      fromJson: ProductDetailsModel.fromJson,
    );
    return result.fold(
          (failure) => Left(failure),
          (products) => Right(products.isNotEmpty ? products.first : ProductDetailsModel.empty()),
    );
  }
}