import '../../../../../core/constant/end_points.dart';
import '../../../../../core/datasource/generic_data_source.dart';
import '../../../../../core/http/either.dart';
import '../../../../../core/http/failure.dart';
import '../../../../../core/params/pagination_params.dart';
import '../models/invoice_model.dart';

abstract interface class InvoicesDataSource {
  Future<Either<Failure, List<InvoiceModel>>> getInvoices({
    required int page,
    required int limit,
    String? search,
    String? status,
  });

  Future<Either<Failure, void>> deleteInvoice(String invoiceId);
}

class InvoicesDataSourceImpl implements InvoicesDataSource {
  final GenericDataSource _genericDataSource;

  InvoicesDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<InvoiceModel>>> getInvoices({
    required int page,
    required int limit,
    String? search,
    String? status,
  }) {
    return _genericDataSource.fetchData<InvoiceModel>(
      endpoint: EndPoints.getInvoices,
      paginationParams: PaginationParams(page: page, limit: limit),
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null && status.isNotEmpty) 'status': status,
      },
      fromJson: InvoiceModel.fromJson,
    );
  }

  @override
  Future<Either<Failure, void>> deleteInvoice(String invoiceId) {
    return _genericDataSource.deleteData<void>(
      endpoint: '${EndPoints.deleteInvoice}/$invoiceId',
    );
  }
}