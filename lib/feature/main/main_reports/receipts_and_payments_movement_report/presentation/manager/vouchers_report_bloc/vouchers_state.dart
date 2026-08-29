import '../../../receipts_and_payments_movement_report_import.dart';
class VouchersState extends Equatable {
  final Status status;
  final EtMovementReportResponseModel? data;
  final String? errorMessage;
  final Failure? failure;

  const VouchersState({
    this.status = Status.initial,
    this.data,
    this.errorMessage,
    this.failure,
  });

  VouchersState copyWith({
    Status? status,
    EtMovementReportResponseModel? data,
    String? errorMessage,
    Failure? failure,
    bool clearData = false,
  }) {
    return VouchersState(
      status: status ?? this.status,
      data: clearData ? null : (data ?? this.data),
      errorMessage: errorMessage ?? this.errorMessage,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, data, errorMessage, failure];
}