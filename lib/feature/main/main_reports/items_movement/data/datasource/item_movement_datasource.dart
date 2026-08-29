import '../../items_movement_import.dart';

abstract class ItemMovementDataSource {
  Future<Either<Failure, ItemMovementResponseModel>> getReport(
      ItemMovementRequestModel request,
      );
}

class ItemMovementDataSourceImpl implements ItemMovementDataSource {
  final GenericDataSource genericDataSource;

  ItemMovementDataSourceImpl({
    required this.genericDataSource,
  });

  @override
  Future<Either<Failure, ItemMovementResponseModel>> getReport(
      ItemMovementRequestModel request,
      ) async {
    return genericDataSource.postData<ItemMovementResponseModel>(
      endpoint: EndPoints.itemMovementReport,
      data: request.toJson(),
      fromJsonListOrMap: (
          List<dynamic>? list,
          Map<String, dynamic>? map,
          ) {
        if (map != null) {
          return ItemMovementResponseModel.fromJson(map);
        }

        return const ItemMovementResponseModel(
          success: false,
          items: [],
        );
      },
    );
  }
}