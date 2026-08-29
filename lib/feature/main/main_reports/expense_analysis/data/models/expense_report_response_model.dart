import '../../expense_analysis_imports.dart';
class ExpenseReportResponseModel extends Equatable {
  final List<ExpenseAccountReportModel> accounts;
  final Map<String, double> monthlyTotals;
  final double grandTotal;

  const ExpenseReportResponseModel({
    required this.accounts,
    required this.monthlyTotals,
    required this.grandTotal,
  });

  factory ExpenseReportResponseModel.fromJson(Map<String, dynamic> json) {
    final accountsList = json['accounts'] as List? ?? [];
    final monthlyTotalsMap = json['monthlyTotals'] as Map<String, dynamic>? ?? {};

    return ExpenseReportResponseModel(
      accounts: accountsList
          .map((item) => ExpenseAccountReportModel.fromJson(item))
          .toList(),
      monthlyTotals: monthlyTotalsMap.map(
            (key, value) => MapEntry(key, (value ?? 0).toDouble()),
      ),
      grandTotal: (json['grandTotal'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accounts': accounts.map((e) => e.toJson()).toList(),
      'monthlyTotals': monthlyTotals,
      'grandTotal': grandTotal,
    };
  }

  @override
  List<Object?> get props => [
    accounts,
    monthlyTotals,
    grandTotal,
  ];
}

class ExpenseAccountReportModel extends Equatable {
  final String accountName;
  final Map<String, double> periodValues;
  final double total;

  const ExpenseAccountReportModel({
    required this.accountName,
    required this.periodValues,
    required this.total,
  });

  factory ExpenseAccountReportModel.fromJson(Map<String, dynamic> json) {
    final periodValuesMap = json['periodValues'] as Map<String, dynamic>? ?? {};

    return ExpenseAccountReportModel(
      accountName: json['accountName'] ?? '',
      periodValues: periodValuesMap.map(
            (key, value) => MapEntry(key, (value ?? 0).toDouble()),
      ),
      total: (json['total'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountName': accountName,
      'periodValues': periodValues,
      'total': total,
    };
  }

  @override
  List<Object?> get props => [
    accountName,
    periodValues,
    total,
  ];
}