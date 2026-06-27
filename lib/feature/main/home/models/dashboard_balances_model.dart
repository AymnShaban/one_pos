part of '../home_imports.dart';

/// Mirrors `GET /api/Dashboard/balances`. The two arrays (`dailySales`,
/// `monthlySales`) are kept verbatim so the trend charts on home can drive
/// off real data once they're wired — the StatCards only need the scalar
/// totals + the current-day entry.
class DashboardBalancesModel extends Equatable {
  final double cashOnHandParentBalance;
  final double cashBanksParentBalance;
  final double sumCashBanks;
  final double customersBalance;
  final double suppliersBalance;
  final double salesTotal;
  final double salesReturnTotal;
  final List<DailySaleEntry> dailySales;
  final List<MonthlySaleEntry> monthlySales;

  const DashboardBalancesModel({
    this.cashOnHandParentBalance = 0,
    this.cashBanksParentBalance = 0,
    this.sumCashBanks = 0,
    this.customersBalance = 0,
    this.suppliersBalance = 0,
    this.salesTotal = 0,
    this.salesReturnTotal = 0,
    this.dailySales = const [],
    this.monthlySales = const [],
  });

  factory DashboardBalancesModel.fromJson(Map<String, dynamic> json) {
    double n(dynamic v) => (v as num?)?.toDouble() ?? 0;
    return DashboardBalancesModel(
      cashOnHandParentBalance: n(json['cashOnHandParentBalance']),
      cashBanksParentBalance: n(json['cashBanksParentBalance']),
      sumCashBanks: n(json['sumCashBanks']),
      customersBalance: n(json['customersBalance']),
      suppliersBalance: n(json['suppliersBalance']),
      salesTotal: n(json['salesTotal']),
      salesReturnTotal: n(json['salesReturnTotal']),
      dailySales: (json['dailySales'] as List?)
              ?.whereType<Map>()
              .map((e) =>
                  DailySaleEntry.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          const [],
      monthlySales: (json['monthlySales'] as List?)
              ?.whereType<Map>()
              .map((e) =>
                  MonthlySaleEntry.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          const [],
    );
  }

  /// Today's slice of the running month, used for the "Daily Sales" card.
  /// Server returns the full month so we pluck by `day == now.day`.
  double get todayTotal {
    final today = DateTime.now().day;
    return dailySales
        .firstWhere(
          (e) => e.day == today,
          orElse: () => const DailySaleEntry(day: 0, total: 0),
        )
        .total;
  }

  @override
  List<Object?> get props => [
        cashOnHandParentBalance,
        cashBanksParentBalance,
        sumCashBanks,
        customersBalance,
        suppliersBalance,
        salesTotal,
        salesReturnTotal,
        dailySales,
        monthlySales,
      ];
}

class DailySaleEntry extends Equatable {
  final int day;
  final double total;

  const DailySaleEntry({required this.day, required this.total});

  factory DailySaleEntry.fromJson(Map<String, dynamic> json) => DailySaleEntry(
        day: (json['day'] as num?)?.toInt() ?? 0,
        total: (json['total'] as num?)?.toDouble() ?? 0,
      );

  @override
  List<Object?> get props => [day, total];
}

class MonthlySaleEntry extends Equatable {
  final int month;
  final double total;

  const MonthlySaleEntry({required this.month, required this.total});

  factory MonthlySaleEntry.fromJson(Map<String, dynamic> json) =>
      MonthlySaleEntry(
        month: (json['month'] as num?)?.toInt() ?? 0,
        total: (json['total'] as num?)?.toDouble() ?? 0,
      );

  @override
  List<Object?> get props => [month, total];
}
