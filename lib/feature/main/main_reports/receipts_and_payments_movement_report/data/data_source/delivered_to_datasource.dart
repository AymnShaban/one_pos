import '../../receipts_and_payments_movement_report_import.dart';
abstract class DeliveredToDataSource {
  Future<Either<Failure, List<DeliveredToModel>>> getDeliveredTo({
    String? search,
  });
}

class DeliveredToDataSourceImpl implements DeliveredToDataSource {
  final GenericDataSource genericDataSource;

  DeliveredToDataSourceImpl({required this.genericDataSource});

  @override
  Future<Either<Failure, List<DeliveredToModel>>> getDeliveredTo({
    String? search,
  }) async {
    final queryParams = <String, dynamic>{};
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    return genericDataSource.fetchData<DeliveredToModel>(
      endpoint: EndPoints.getDeliveredTo,
      fromJson: DeliveredToModel.fromJson,
      queryParameters: queryParams,

    );
  }
}
