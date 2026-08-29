import '../../branch_profit_import.dart';

class BranchProfitResponseModel extends Equatable {
  final String? reportType;
  final List<RowModel> rows;
  final List<AnalysisRow> analysisRows;
  final List<dynamic> collectiveBranches;
  final double totalSales;
  final double totalCost;
  final double totalBenifit;
  final double totalExpended;
  final double totalOtherFunds;
  final double totalNetProfit;
  final double totalDebit;
  final double totalCredit;
  final String? fromDate;
  final String? toDate;

  const BranchProfitResponseModel({
    this.reportType,
    this.rows = const [],
    this.analysisRows = const [],
    this.collectiveBranches = const [],
    this.totalSales = 0,
    this.totalCost = 0,
    this.totalBenifit = 0,
    this.totalExpended = 0,
    this.totalOtherFunds = 0,
    this.totalNetProfit = 0,
    this.totalDebit = 0,
    this.totalCredit = 0,
    this.fromDate,
    this.toDate,
  });

  factory BranchProfitResponseModel.fromJson(Map<String, dynamic> json) {
    return BranchProfitResponseModel(
      reportType: json['reportType'] as String?,
      rows: (json['rows'] as List?)
          ?.map((e) => RowModel.fromJson(e))
          .toList() ??
          [],
      analysisRows: (json['analysisRows'] as List?)
          ?.map((e) => AnalysisRow.fromJson(e))
          .toList() ??
          [],
      collectiveBranches: json['collectiveBranches'] as List? ?? [],
      totalSales: (json['totalSales'] as num?)?.toDouble() ?? 0,
      totalCost: (json['totalCost'] as num?)?.toDouble() ?? 0,
      totalBenifit: (json['totalBenifit'] as num?)?.toDouble() ?? 0,
      totalExpended: (json['totalExpended'] as num?)?.toDouble() ?? 0,
      totalOtherFunds: (json['totalOtherFunds'] as num?)?.toDouble() ?? 0,
      totalNetProfit: (json['totalNetProfit'] as num?)?.toDouble() ?? 0,
      totalDebit: (json['totalDebit'] as num?)?.toDouble() ?? 0,
      totalCredit: (json['totalCredit'] as num?)?.toDouble() ?? 0,
      fromDate: json['fromDate'] as String?,
      toDate: json['toDate'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    reportType,
    rows,
    analysisRows,
    collectiveBranches,
    totalSales,
    totalCost,
    totalBenifit,
    totalExpended,
    totalOtherFunds,
    totalNetProfit,
    totalDebit,
    totalCredit,
    fromDate,
    toDate,
  ];
}

// ==================== ROW MODEL ====================

class RowModel extends Equatable {
  final int? gbr;
  final String? branchName;
  final String? branchEName;
  final String? branchCode;
  final int? monthYear;
  final String? periodLabel;
  final double totalSales;
  final double cost;
  final double costWithLastBuy;
  final double benifit;
  final double expended;
  final double otherFunds;
  final double netProfit;
  final List<dynamic>? expenseLines;
  final List<dynamic>? revenueLines;

  const RowModel({
    this.gbr,
    this.branchName,
    this.branchEName,
    this.branchCode,
    this.monthYear,
    this.periodLabel,
    this.totalSales = 0,
    this.cost = 0,
    this.costWithLastBuy = 0,
    this.benifit = 0,
    this.expended = 0,
    this.otherFunds = 0,
    this.netProfit = 0,
    this.expenseLines,
    this.revenueLines,
  });

  factory RowModel.fromJson(Map<String, dynamic> json) {
    return RowModel(
      gbr: json['gbr'] as int?,
      branchName: json['branchName'] as String?,
      branchEName: json['branchEName'] as String?,
      branchCode: json['branchCode'] as String?,
      monthYear: json['monthYear'] as int?,
      periodLabel: json['periodLabel'] as String?,
      totalSales: (json['totalSales'] as num?)?.toDouble() ?? 0,
      cost: (json['cost'] as num?)?.toDouble() ?? 0,
      costWithLastBuy: (json['costWithLastBuy'] as num?)?.toDouble() ?? 0,
      benifit: (json['benifit'] as num?)?.toDouble() ?? 0,
      expended: (json['expended'] as num?)?.toDouble() ?? 0,
      otherFunds: (json['otherFunds'] as num?)?.toDouble() ?? 0,
      netProfit: (json['netProfit'] as num?)?.toDouble() ?? 0,
      expenseLines: json['expenseLines'] as List?,
      revenueLines: json['revenueLines'] as List?,
    );
  }

  @override
  List<Object?> get props => [
    gbr,
    branchName,
    branchEName,
    branchCode,
    monthYear,
    periodLabel,
    totalSales,
    cost,
    costWithLastBuy,
    benifit,
    expended,
    otherFunds,
    netProfit,
    expenseLines,
    revenueLines,
  ];
}

// ==================== ANALYSIS ROW ====================

class AnalysisRow extends Equatable {
  final String? periodLabel;
  final String? label;
  final double debit;
  final double credit;
  final bool isHeader;
  final bool isNetProfit;

  const AnalysisRow({
    this.periodLabel,
    this.label,
    this.debit = 0,
    this.credit = 0,
    this.isHeader = false,
    this.isNetProfit = false,
  });

  factory AnalysisRow.fromJson(Map<String, dynamic> json) {
    return AnalysisRow(
      periodLabel: json['periodLabel'] as String?,
      label: json['label'] as String?,
      debit: (json['debit'] as num?)?.toDouble() ?? 0,
      credit: (json['credit'] as num?)?.toDouble() ?? 0,
      isHeader: json['isHeader'] as bool? ?? false,
      isNetProfit: json['isNetProfit'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
    periodLabel,
    label,
    debit,
    credit,
    isHeader,
    isNetProfit,
  ];
}