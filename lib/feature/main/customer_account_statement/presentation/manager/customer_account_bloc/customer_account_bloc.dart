import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helper/helper.dart';
import '../../../data/datasource/customer_statement_report_datasource.dart';
import '../../../data/models/customer_account_response_model.dart';
import 'customer_account_event.dart';

class CustomerStatementReportBloc extends Bloc<
    CustomerStatementReportEvent,
    BaseState<List<CustomerAccountStatementResponseModel>>
> {
  final CustomerStatementDataSource dataSource;

  CustomerStatementReportBloc({
    required this.dataSource,
  }) : super(
    const BaseState<List<CustomerAccountStatementResponseModel>>(),
  ) {
    on<LoadCustomerStatementReport>(
      _onLoadCustomerStatementReport,
    );

    on<ClearCustomerStatementReport>(
      _onClearCustomerStatementReport,
    );
  }

  Future<void> _onLoadCustomerStatementReport(
      LoadCustomerStatementReport event,
      Emitter<BaseState<List<CustomerAccountStatementResponseModel>>> emit,
      ) async {
    emit(
      state.copyWith(
        status: Status.loading,
        errorMessage: null,
        failure: null,
      ),
    );

    final result = await dataSource.getReport(event.request);

    result.fold(
          (failure) {
        emit(
          state.copyWith(
            status: Status.failure,
            errorMessage: failure.message,
            failure: failure,
          ),
        );
      },
          (report) {
        emit(
          state.copyWith(
            status: Status.success,
            data: report,
            errorMessage: null,
            failure: null,
          ),
        );
      },
    );
  }

  void _onClearCustomerStatementReport(
      ClearCustomerStatementReport event,
      Emitter<BaseState<List<CustomerAccountStatementResponseModel>>> emit,
      ) {
    emit(
      const BaseState<List<CustomerAccountStatementResponseModel>>(
        status: Status.initial,
      ),
    );
  }
}