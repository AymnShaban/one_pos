import 'package:equatable/equatable.dart';

import '../../../data/models/report_source_request_model.dart';

abstract class CustomerStatementReportEvent extends Equatable {
  const CustomerStatementReportEvent();

  @override
  List<Object?> get props => [];
}

class LoadCustomerStatementReport extends CustomerStatementReportEvent {
  final CustomerStatementRequestModel request;

  const LoadCustomerStatementReport({
    required this.request,
  });

  @override
  List<Object?> get props => [request];
}

class ClearCustomerStatementReport extends CustomerStatementReportEvent {
  const ClearCustomerStatementReport();
}