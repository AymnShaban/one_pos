
import '../../invoice_profit_imports.dart';
import '../models/pay_way_model.dart';

abstract class PayWaysDataSource {
  Future<Either<Failure, List<PayWayModel>>> getPayWays();
}

class PayWaysDataSourceImpl implements PayWaysDataSource {
  final GenericDataSource genericDataSource;

  PayWaysDataSourceImpl({required this.genericDataSource});

  @override
  Future<Either<Failure, List<PayWayModel>>> getPayWays() async {
    return genericDataSource.fetchData<PayWayModel>(
      endpoint: EndPoints.getPayWays,
      fromJson: PayWayModel.fromJson,
    );
  }
}