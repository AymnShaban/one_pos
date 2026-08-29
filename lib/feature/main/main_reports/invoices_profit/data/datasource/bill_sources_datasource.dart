import '../../invoice_profit_imports.dart';


abstract class BillSourcesDataSource {
  Future<Either<Failure, List<BillSourceModel>>> getBillSources();
}

class BillSourcesDataSourceImpl implements BillSourcesDataSource {
  final GenericDataSource genericDataSource;

  BillSourcesDataSourceImpl({required this.genericDataSource});

  @override
  Future<Either<Failure, List<BillSourceModel>>> getBillSources() async {
    return genericDataSource.fetchData<BillSourceModel>(
      endpoint: EndPoints.getInvoiceProfitSources,

      fromJson:BillSourceModel.fromJson
    );
  }
}