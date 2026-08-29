


import '../../revenue_analysis_import.dart';

class RevenueReportResponseModel extends Equatable {
  final List<RevenueAccountReportModel> accounts;
  final Map<String, double> monthlyTotals;
  final double grandTotal;

  const RevenueReportResponseModel({
    required this.accounts,
    required this.monthlyTotals,
    required this.grandTotal,
  });

  factory RevenueReportResponseModel.fromJson(Map<String, dynamic> json) {
    final accountsList = json['accounts'] as List? ?? [];
    final monthlyTotalsMap = json['monthlyTotals'] as Map<String, dynamic>? ?? {};

    return RevenueReportResponseModel(
      accounts: accountsList
          .map((item) => RevenueAccountReportModel.fromJson(item))
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

class RevenueAccountReportModel extends Equatable {
  final String accountName;
  final Map<String, double> periodValues;
  final double total;

  const RevenueAccountReportModel({
    required this.accountName,
    required this.periodValues,
    required this.total,
  });

  factory RevenueAccountReportModel.fromJson(Map<String, dynamic> json) {
    final periodValuesMap = json['periodValues'] as Map<String, dynamic>? ?? {};

    return RevenueAccountReportModel(
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