
import '../../../shared_imports.dart';
abstract interface class StoresDataSource {
  Future<Either<Failure, List<StoreModel>>> getStores();
}

class StoresDataSourceImpl implements StoresDataSource {
  final GenericDataSource _generic;

  StoresDataSourceImpl(this._generic);

  @override
  Future<Either<Failure, List<StoreModel>>> getStores() {
    return _generic.fetchData<StoreModel>(
      endpoint: EndPoints.getStores,
      fromJson: StoreModel.fromJson,
    );
  }
}