import '../../../expense_analysis_imports.dart';

class ExpenseReportState extends Equatable {
  final Status status;
  final ExpenseReportResponseModel? reportData;
  final String? errorMessage;

  const ExpenseReportState({
    this.status = Status.initial,
    this.reportData,
    this.errorMessage,
  });

  ExpenseReportState copyWith({
    Status? status,
    ExpenseReportResponseModel? reportData,
    String? errorMessage,
    bool clearReport = false,
    bool clearError = false,
  }) {
    return ExpenseReportState(
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