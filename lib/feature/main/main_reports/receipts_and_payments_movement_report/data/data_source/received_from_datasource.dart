import '../../receipts_and_payments_movement_report_import.dart';
abstract class ReceivedFromDataSource {
  Future<Either<Failure, List<ReceivedFromModel>>> getReceivedFrom({
    String? search,
  });
}

class ReceivedFromDataSourceImpl implements ReceivedFromDataSource {
  final GenericDataSource genericDataSource;

  ReceivedFromDataSourceImpl({
    required this.genericDataSource,
  });

  @override
  Future<Either<Failure, List<ReceivedFromModel>>> getReceivedFrom({
    String? search,
  }) async {
    final queryParams = <String, dynamic>{};

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    return genericDataSource.fetchData<ReceivedFromModel>(
      endpoint: EndPoints.getReceivedFrom,
      fromJson: ReceivedFromModel.fromJson,
      queryParameters: queryParams,
    );
  }
}