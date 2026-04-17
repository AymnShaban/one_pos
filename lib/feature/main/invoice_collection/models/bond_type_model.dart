part of '../invoice_collection_imports.dart';

class BondTypeModel extends Equatable {
  final int voucherType;
  final String arabicName;
  final String englishName;
  final String? customerName;

  const BondTypeModel({
    required this.voucherType,
    required this.arabicName,
    required this.englishName,
    this.customerName,
  });

  factory BondTypeModel.fromJson(Map<String, dynamic> json) {
    return BondTypeModel(
      voucherType:  json['VoucherType']  ?? 0,
      arabicName:   json['ArabicName']   ?? '',
      englishName:  json['EnglishName']  ?? '',
      customerName: json['CustomerName'],
    );
  }

  Map<String, dynamic> toJson() => {
    'VoucherType':  voucherType,
    'ArabicName':   arabicName,
    'EnglishName':  englishName,
    'CustomerName': customerName,
  };

  @override
  List<Object?> get props => [voucherType, arabicName];
}