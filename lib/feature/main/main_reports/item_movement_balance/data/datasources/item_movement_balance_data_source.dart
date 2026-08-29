import '../../item_movement_balance_import.dart';
abstract class ItemMovementBalanceDataSource {
  Future<Either<Failure, ItemMovementBalanceResponseModel>> getReport(
      ItemMovementBalanceRequestModel request,
      );
}

class ItemMovementBalanceDataSourceImpl implements ItemMovementBalanceDataSource {
  final GenericDataSource genericDataSource;

  ItemMovementBalanceDataSourceImpl({
    required this.genericDataSource,
  });

  @override
  Future<Either<Failure, ItemMovementBalanceResponseModel>> getReport(
      ItemMovementBalanceRequestModel request,
      ) async {
    return await genericDataSource.postData(
      endpoint: EndPoints.itemMovementBalanceReport,
      data: request.toJson(),
      fromJson: ItemMovementBalanceResponseModel.fromJson,
    );
  }
}