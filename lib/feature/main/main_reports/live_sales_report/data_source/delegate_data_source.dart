part of '../live_sales_report_imports.dart';

abstract interface class DelegateDataSource {
  /// `search: ''` returns every delegate.
  Future<Either<Failure, List<DelegateModel>>> getDelegates({
    String search = '',
  });
}

class DelegateDataSourceImpl implements DelegateDataSource {
  final GenericDataSource _generic;

  DelegateDataSourceImpl(this._generic);

  @override
  Future<Either<Failure, List<DelegateModel>>> getDelegates({
    String search = '',
  }) {
    return _generic.fetchData<DelegateModel>(
      endpoint: EndPoints.getDelegates,
      queryParameters: {'search': search},
      fromJson: DelegateModel.fromJson,
    );
  }
}
