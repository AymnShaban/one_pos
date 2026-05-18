part of '../invoice_setup_imports.dart';

class InvoicePatternModel extends Equatable {
  final int patternId;
  final String patternArName;
  final String patternEnName;
  final bool isPriceQuote;

  const InvoicePatternModel({
    required this.patternId,
    required this.patternArName,
    required this.patternEnName,
    this.isPriceQuote = false,
  });

  factory InvoicePatternModel.fromJson(Map<String, dynamic> json) {
    return InvoicePatternModel(
      patternId:     json['InvoicePatternID'] ?? json['PatternID'] ?? 0,
      patternArName: json['ArabicPatternName'] ?? json['PatternArName'] ?? json['PatternName'] ?? '',
      patternEnName: json['EnglishPatternName'] ?? json['PatternEnName'] ?? json['PatternName'] ?? '',
      isPriceQuote:  json['IsPriceQuote'] == true || json['IsPriceQuote'] == 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'InvoicePatternID':   patternId,
    'ArabicPatternName':  patternArName,
    'EnglishPatternName': patternEnName,
    'IsPriceQuote':       isPriceQuote,
  };

  @override
  List<Object?> get props => [patternId];
}