part of '../home_imports.dart';

class LowStockItemModel extends Equatable {
  final int mtid;
  final String? mtName;
  final String? mteName;
  final double totalQty;

  const LowStockItemModel({
    required this.mtid,
    this.mtName,
    this.mteName,
    this.totalQty = 0,
  });

  factory LowStockItemModel.fromJson(Map<String, dynamic> json) {
    return LowStockItemModel(
      mtid: json['mtid'] as int? ?? 0,
      mtName: json['mtName'] as String?,
      mteName: json['mteName'] as String?,
      totalQty: (json['totalQty'] as num?)?.toDouble() ?? 0,
    );
  }



  @override
  List<Object?> get props => [mtid, mtName, mteName, totalQty];
}