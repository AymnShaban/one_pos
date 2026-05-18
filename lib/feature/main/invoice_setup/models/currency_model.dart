part of '../invoice_setup_imports.dart';

class CurrencyModel extends Equatable {
  final int currencyId;
  final String currencyArName;
  final String currencyEnName;
  final String currencySymbol;
  final double rate;
  final bool isDefault;

  const CurrencyModel({
    required this.currencyId,
    required this.currencyArName,
    required this.currencyEnName,
    this.currencySymbol = '',
    this.rate           = 1.0,
    this.isDefault      = false,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      currencyId:     json['CurrencyID']      ?? 0,
      currencyArName: json['ArabicName']       ?? json['CurrencyArName'] ?? json['CurrencyName']  ?? '',
      currencyEnName: json['EnglishName']      ?? json['CurrencyEnName'] ?? json['CurrencyEName'] ?? '',
      currencySymbol: json['CurrencySymbol']   ?? '',
      rate:           (json['Rate'] as num?)?.toDouble() ?? 1.0,
      isDefault:      json['IsDefault'] == true || json['IsDefault'] == 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'CurrencyID':     currencyId,
    'ArabicName':     currencyArName,
    'EnglishName':    currencyEnName,
    'CurrencySymbol': currencySymbol,
    'Rate':           rate,
    'IsDefault':      isDefault,
  };

  @override
  List<Object?> get props => [currencyId];
}