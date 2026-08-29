
import '../../../revenue_analysis_import.dart';

class RevenueReportState extends Equatable {
  final Status status;
  final RevenueReportResponseModel? reportData;
  final String? errorMessage;

  const RevenueReportState({
    this.status = Status.initial,
    this.reportData,
    this.errorMessage,
  });

  RevenueReportState copyWith({
    Status? status,
    RevenueReportResponseModel? reportData,
    String? errorMessage,
    bool clearReport = false,
    bool clearError = false,
  }) {
    return RevenueReportState(
      status: status ?? this.status,
      reportData: clearReport ? null : (reportData ?? this.reportData),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    reportData,
    errorMessage,
  ];
}