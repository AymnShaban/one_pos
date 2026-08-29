import '../../expense_analysis_imports.dart';
class ExpenseReportRequestModel extends Equatable {
  final int accountId;
  final DateTime startDate;
  final DateTime endDate;

  const ExpenseReportRequestModel({
    required this.accountId,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [accountId, startDate, endDate];
}