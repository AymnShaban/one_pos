
import '../../../shared_imports.dart';
class CurrencyModel extends Equatable {
  final int currencyID;
  final String currencyName;
  final String currencyEName;
  final String partName;
  final String partEName;
  final int partPrecition;
  final double rate;
  final String currencySymbol;
  final String totCurrencyName;
  final String totCurrencyEName;
  final String totPartName;
  final String totPartEName;
  final String pricesDigits;

  const CurrencyModel({
    required this.currencyID,
    required this.currencyName,
    required this.currencyEName,
    required this.partName,
    required this.partEName,
    required this.partPrecition,
    required this.rate,
    required this.currencySymbol,
    required this.totCurrencyName,
    required this.totCurrencyEName,
    required this.totPartName,
    required this.totPartEName,
    required this.pricesDigits,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      currencyID: json['currencyID'] ?? 0,
      currencyName: json['currencyName'] ?? '',
      currencyEName: json['currencyEName'] ?? '',
      partName: json['partName'] ?? '',
      partEName: json['partEName'] ?? '',
      partPrecition: json['partPrecition'] ?? 0,
      rate: (json['rate'] ?? 0).toDouble(),
      currencySymbol: json['currencySymbol'] ?? '',
      totCurrencyName: json['totCurrencyName'] ?? '',
      totCurrencyEName: json['totCurrencyEName'] ?? '',
      totPartName: json['totPartName'] ?? '',
      totPartEName: json['totPartEName'] ?? '',
      pricesDigits: json['pricesDigits'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currencyID': currencyID,
      'currencyName': currencyName,
      'currencyEName': currencyEName,
      'partName': partName,
      'partEName': partEName,
      'partPrecition': partPrecition,
      'rate': rate,
      'currencySymbol': currencySymbol,
      'totCurrencyName': totCurrencyName,
      'totCurrencyEName': totCurrencyEName,
      'totPartName': totPartName,
      'totPartEName': totPartEName,
      'pricesDigits': pricesDigits,
    };
  }

  // Helper getter to check if this is the default currency
  // Note: Based on the API response, there's no explicit isDefault field
  // You may need to determine this based on rate == 1 or other logic
  bool get isDefault => rate == 1.0;

  @override
  List<Object?> get props => [
    currencyID,
    currencyName,
    currencyEName,
    partName,
    partEName,
    partPrecition,
    rate,
    currencySymbol,
    totCurrencyName,
    totCurrencyEName,
    totPartName,
    totPartEName,
    pricesDigits,
  ];
}