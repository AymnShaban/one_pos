part of '../reports_imports.dart';

enum ReportType { dailySales, itemsReport, trends }
enum ReportPeriod { today, week, month, custom }

extension ReportTypeExtension on ReportType {
  String get arLabel {
    switch (this) {
      case ReportType.dailySales:  return 'مبيعات اليومية';
      case ReportType.itemsReport: return 'تقرير الأصناف';
      case ReportType.trends:      return 'الاتجاهات';
    }
  }

  String get apiValue {
    switch (this) {
      case ReportType.dailySales:  return 'daily_sales';
      case ReportType.itemsReport: return 'items_report';
      case ReportType.trends:      return 'trends';
    }
  }
}

extension ReportPeriodExtension on ReportPeriod {
  String get arLabel {
    switch (this) {
      case ReportPeriod.today:  return 'اليوم';
      case ReportPeriod.week:   return 'الأسبوع';
      case ReportPeriod.month:  return 'الشهر';
      case ReportPeriod.custom: return 'مخصص';
    }
  }

  String get apiValue {
    switch (this) {
      case ReportPeriod.today:  return 'today';
      case ReportPeriod.week:   return 'week';
      case ReportPeriod.month:  return 'month';
      case ReportPeriod.custom: return 'custom';
    }
  }
}

class TopProductModel extends Equatable {
  final int rank;
  final String name;
  final int unitsSold;
  final double totalAmount;

  const TopProductModel({
    required this.rank,
    required this.name,
    required this.unitsSold,
    required this.totalAmount,
  });

  factory TopProductModel.fromJson(Map<String, dynamic> json) {
    return TopProductModel(
      rank:        json['Rank'] ?? 0,
      name:        json['ProductName'] ?? '',
      unitsSold:   json['UnitsSold'] ?? 0,
      totalAmount: (json['TotalAmount'] ?? 0).toDouble(),
    );
  }

  @override
  List<Object?> get props => [rank, name, unitsSold, totalAmount];
}

class ReportSummaryModel extends Equatable {
  final double totalSales;
  final int invoicesCount;
  final double averageInvoice;
  final double cashAmount;
  final double cardAmount;
  final List<TopProductModel> topProducts;

  const ReportSummaryModel({
    this.totalSales = 0,
    this.invoicesCount = 0,
    this.averageInvoice = 0,
    this.cashAmount = 0,
    this.cardAmount = 0,
    this.topProducts = const [],
  });

  factory ReportSummaryModel.fromJson(Map<String, dynamic> json) {
    return ReportSummaryModel(
      totalSales:     (json['TotalSales'] ?? 0).toDouble(),
      invoicesCount:  json['InvoicesCount'] ?? 0,
      averageInvoice: (json['AverageInvoice'] ?? 0).toDouble(),
      cashAmount:     (json['CashAmount'] ?? 0).toDouble(),
      cardAmount:     (json['CardAmount'] ?? 0).toDouble(),
      topProducts: (json['TopProducts'] as List? ?? [])
          .map((e) => TopProductModel.fromJson(e))
          .toList(),
    );
  }

  ReportSummaryModel copyWith({
    double? totalSales,
    int? invoicesCount,
    double? averageInvoice,
    double? cashAmount,
    double? cardAmount,
    List<TopProductModel>? topProducts,
  }) {
    return ReportSummaryModel(
      totalSales:     totalSales     ?? this.totalSales,
      invoicesCount:  invoicesCount  ?? this.invoicesCount,
      averageInvoice: averageInvoice ?? this.averageInvoice,
      cashAmount:     cashAmount     ?? this.cashAmount,
      cardAmount:     cardAmount     ?? this.cardAmount,
      topProducts:    topProducts    ?? this.topProducts,
    );
  }

  @override
  List<Object?> get props => [
    totalSales, invoicesCount, averageInvoice,
    cashAmount, cardAmount, topProducts,
  ];
}