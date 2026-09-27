import '../../../../core/constant/end_points.dart';
import '../../../../core/datasource/generic_data_source.dart';
import '../../../../core/http/either.dart';
import '../../../../core/http/failure.dart';
import '../../../main/main_reports/shared/store/data/models/store_model.dart';
import '../models/add_stock_items_request.dart';
import '../models/add_stock_items_response.dart';

abstract class StockDataSource {
  Future<Either<Failure, List<StoreModel>>> getStores();

  Future<Either<Failure, AddStockItemsResponse>> addStockItems(
    AddStockItemsRequest request,
  );
}

class StockDataSourceImpl implements StockDataSource {
  final GenericDataSource dataSource;

  StockDataSourceImpl(this.dataSource);

  @override
  Future<Either<Failure, List<StoreModel>>> getStores() {
    return dataSource.fetchData<StoreModel>(
      endpoint: EndPoints.getStores,
      fromJson: StoreModel.fromJson,
    );
  }

  @override
  Future<Either<Failure, AddStockItemsResponse>> addStockItems(
    AddStockItemsRequest request,
  ) {
    return dataSource.postData<AddStockItemsResponse>(
      endpoint: EndPoints.addStockItems,
      data: request.toJson(),
      fromJson: AddStockItemsResponse.fromJson,
    );
  }
}
