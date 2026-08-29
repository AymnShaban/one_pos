part of '../home_imports.dart';

class TopSellingItemModel extends Equatable {
  final int itemCode;
  final String? arName;
  final String? enName;
  final double totalQty;
  final double totalRevenue;

  const TopSellingItemModel({
    required this.itemCode,
    this.arName,
    this.enName,
    this.totalQty = 0,
    this.totalRevenue = 0,
  });

  factory TopSellingItemModel.fromJson(Map<String, dynamic> json) {
    return TopSellingItemModel(
      itemCode: json['itemCode'] as int? ?? 0,
      arName: json['arName'] as String?,
      enName: json['enName'] as String?,
      totalQty: (json['totalQty'] as num?)?.toDouble() ?? 0,
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0,
    );
  }



  String getFormattedRevenue() {
    return NumberFormat('#,##0.000', 'en_US').format(totalRevenue);
  }

  @override
  List<Object?> get props => [itemCode, arName, enName, totalQty, totalRevenue];
}