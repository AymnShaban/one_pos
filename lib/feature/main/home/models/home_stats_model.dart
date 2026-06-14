part of '../home_imports.dart';

class HomeStatsModel extends Equatable {
  // ── Legacy stats (still used by other places) ──────────────────────
  final double todaySales;
  final int invoicesCount;
  final int productsCount;
  final int invoicesNewCount;
  final int salesPercentage;

  // ── New stats for the redesigned home dashboard ────────────────────
  final double totalRevenue;
  final double totalExpenses;
  final double netProfit;
  final int revenuePercentage;
  final int expensesPercentage;
  final int profitPercentage;
  final int todayInvoicesCount;

  const HomeStatsModel({
    this.todaySales = 0,
    this.invoicesCount = 0,
    this.productsCount = 0,
    this.invoicesNewCount = 0,
    this.salesPercentage = 0,
    this.totalRevenue = 0,
    this.totalExpenses = 0,
    this.netProfit = 0,
    this.revenuePercentage = 0,
    this.expensesPercentage = 0,
    this.profitPercentage = 0,
    this.todayInvoicesCount = 0,
  });

  HomeStatsModel copyWith({
    double? todaySales,
    int? invoicesCount,
    int? productsCount,
    int? invoicesNewCount,
    int? salesPercentage,
    double? totalRevenue,
    double? totalExpenses,
    double? netProfit,
    int? revenuePercentage,
    int? expensesPercentage,
    int? profitPercentage,
    int? todayInvoicesCount,
  }) {
    return HomeStatsModel(
      todaySales: todaySales ?? this.todaySales,
      invoicesCount: invoicesCount ?? this.invoicesCount,
      productsCount: productsCount ?? this.productsCount,
      invoicesNewCount: invoicesNewCount ?? this.invoicesNewCount,
      salesPercentage: salesPercentage ?? this.salesPercentage,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      netProfit: netProfit ?? this.netProfit,
      revenuePercentage: revenuePercentage ?? this.revenuePercentage,
      expensesPercentage: expensesPercentage ?? this.expensesPercentage,
      profitPercentage: profitPercentage ?? this.profitPercentage,
      todayInvoicesCount: todayInvoicesCount ?? this.todayInvoicesCount,
    );
  }

  factory HomeStatsModel.fromJson(Map<String, dynamic> json) {
    final invoicesCount = json['InvoicesCount'] ?? 0;
    return HomeStatsModel(
      todaySales: (json['TodaySales'] ?? 0).toDouble(),
      invoicesCount: invoicesCount,
      productsCount: json['ProductsCount'] ?? 0,
      invoicesNewCount: json['InvoicesNewCount'] ?? 0,
      salesPercentage: json['SalesPercentage'] ?? 0,
      // New fields — gracefully fall back to legacy values when the server
      // doesn't yet send them, so the new dashboard cards show something
      // sensible instead of all zeros.
      totalRevenue: (json['TotalRevenue'] ?? json['TodaySales'] ?? 0).toDouble(),
      totalExpenses: (json['TotalExpenses'] ?? 0).toDouble(),
      netProfit: (json['NetProfit'] ?? 0).toDouble(),
      revenuePercentage:
          json['RevenuePercentage'] ?? json['SalesPercentage'] ?? 0,
      expensesPercentage: json['ExpensesPercentage'] ?? 0,
      profitPercentage: json['ProfitPercentage'] ?? 0,
      todayInvoicesCount: json['TodayInvoicesCount'] ?? invoicesCount,
    );
  }

  Map<String, dynamic> toJson() => {
        'TodaySales': todaySales,
        'InvoicesCount': invoicesCount,
        'ProductsCount': productsCount,
        'InvoicesNewCount': invoicesNewCount,
        'SalesPercentage': salesPercentage,
        'TotalRevenue': totalRevenue,
        'TotalExpenses': totalExpenses,
        'NetProfit': netProfit,
        'RevenuePercentage': revenuePercentage,
        'ExpensesPercentage': expensesPercentage,
        'ProfitPercentage': profitPercentage,
        'TodayInvoicesCount': todayInvoicesCount,
      };

  @override
  List<Object?> get props => [
        todaySales,
        invoicesCount,
        productsCount,
        invoicesNewCount,
        salesPercentage,
        totalRevenue,
        totalExpenses,
        netProfit,
        revenuePercentage,
        expensesPercentage,
        profitPercentage,
        todayInvoicesCount,
      ];
}
