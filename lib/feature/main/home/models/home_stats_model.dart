import 'package:equatable/equatable.dart';

class HomeStatsModel extends Equatable {
  final double todaySales;
  final int invoicesCount;
  final int productsCount;
  final int invoicesNewCount;
  final int salesPercentage;

  const HomeStatsModel({
    this.todaySales = 0,
    this.invoicesCount = 0,
    this.productsCount = 0,
    this.invoicesNewCount = 0,
    this.salesPercentage = 0,
  });

  HomeStatsModel copyWith({
    double? todaySales,
    int? invoicesCount,
    int? productsCount,
    int? invoicesNewCount,
    int? salesPercentage,
  }) {
    return HomeStatsModel(
      todaySales: todaySales ?? this.todaySales,
      invoicesCount: invoicesCount ?? this.invoicesCount,
      productsCount: productsCount ?? this.productsCount,
      invoicesNewCount: invoicesNewCount ?? this.invoicesNewCount,
      salesPercentage: salesPercentage ?? this.salesPercentage,
    );
  }

  factory HomeStatsModel.fromJson(Map<String, dynamic> json) {
    return HomeStatsModel(
      todaySales: (json['TodaySales'] ?? 0).toDouble(),
      invoicesCount: json['InvoicesCount'] ?? 0,
      productsCount: json['ProductsCount'] ?? 0,
      invoicesNewCount: json['InvoicesNewCount'] ?? 0,
      salesPercentage: json['SalesPercentage'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TodaySales': todaySales,
      'InvoicesCount': invoicesCount,
      'ProductsCount': productsCount,
      'InvoicesNewCount': invoicesNewCount,
      'SalesPercentage': salesPercentage,
    };
  }

  @override
  List<Object?> get props => [
    todaySales,
    invoicesCount,
    productsCount,
    invoicesNewCount,
    salesPercentage,
  ];
}