import '../../item_profit_import.dart';
abstract class ItemProfitDataSource {
  Future<Either<Failure, ItemProfitResponseModel>> getReport(
      ItemProfitRequestModel request,
      );
}

class ItemProfitDataSourceImpl implements ItemProfitDataSource {
  final GenericDataSource genericDataSource;

  ItemProfitDataSourceImpl({
    required this.genericDataSource,
  });

  @override
  Future<Either<Failure, ItemProfitResponseModel>> getReport(
      ItemProfitRequestModel request,
      ) async {
    return await genericDataSource.postData(
      endpoint: EndPoints.materialProfitReport,
      data: request.toJson(),
      fromJson: ItemProfitResponseModel.fromJson,
    );
  }
}