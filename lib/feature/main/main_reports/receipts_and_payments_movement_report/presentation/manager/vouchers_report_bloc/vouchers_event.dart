import '../../../receipts_and_payments_movement_report_import.dart';
abstract class VouchersEvent extends Equatable {
  const VouchersEvent();

  @override
  List<Object?> get props => [];
}

class LoadVouchersReport extends VouchersEvent {
  final EtMovementReportRequestModel request;

  const LoadVouchersReport({required this.request});

  @override
  List<Object?> get props => [request];
}

class ClearVouchersReport extends VouchersEvent {}