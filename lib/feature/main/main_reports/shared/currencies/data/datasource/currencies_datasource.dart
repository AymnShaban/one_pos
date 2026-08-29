import '../../../shared_imports.dart';
abstract class CurrenciesDataSource {
  Future<Either<Failure, List<CurrencyModel>>> getCurrencies();
}

class CurrenciesDataSourceImpl implements CurrenciesDataSource {
  final GenericDataSource genericDataSource;

  CurrenciesDataSourceImpl({required this.genericDataSource});

  @override
  Future<Either<Failure, List<CurrencyModel>>> getCurrencies() async {
    return genericDataSource.fetchData<CurrencyModel>(
      endpoint: EndPoints.getCurrencies,

      fromJson:  CurrencyModel.fromJson,
    );
  }
}