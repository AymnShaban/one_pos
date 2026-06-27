part of '../invoice_setup_imports.dart';

/// Maps `GET /api/Currency/GetCurrencies`. Server now uses lowercase-first
/// keys (`currencyID`, `currencyName`, `currencyEName`, …) — the old
/// PascalCase fallbacks are kept so older mocked payloads still parse.
///
/// Beyond the four fields the existing UI already shows (id / Ar+En name /
/// symbol / rate) the response carries the part-currency descriptors
/// (`partName` = فلس, `pricesDigits` = "0.000" formatting hint, etc.) — they
/// land on the model so price formatters can pick them up later without a
/// second refactor.
class CurrencyModel extends Equatable {
  final int currencyId;
  final String currencyArName;
  final String currencyEnName;
  final String currencySymbol;
  final double rate;
  final bool isDefault;

  // ── Part-currency descriptors (فلس / Fils etc.) ──────────────────────
  final String partArName;
  final String partEnName;
  final int partPrecision;

  // ── Plural / "tot" forms used by amount-in-words renderers ──────────
  final String totCurrencyArName;
  final String totCurrencyEnName;
  final String totPartArName;
  final String totPartEnName;

  /// Server-supplied formatting hint, e.g. `"0.000"`. Use this to drive
  /// the decimal precision of any price/total renderer.
  final String pricesDigits;

  const CurrencyModel({
    required this.currencyId,
    required this.currencyArName,
    required this.currencyEnName,
    this.currencySymbol = '',
    this.rate = 1.0,
    this.isDefault = false,
    this.partArName = '',
    this.partEnName = '',
    this.partPrecision = 0,
    this.totCurrencyArName = '',
    this.totCurrencyEnName = '',
    this.totPartArName = '',
    this.totPartEnName = '',
    this.pricesDigits = '0.00',
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    // The endpoint switched from PascalCase to camelCase — accept both so
    // any older cached / mocked payloads still parse cleanly.
    int? i(dynamic v) => (v as num?)?.toInt();
    double? d(dynamic v) => (v as num?)?.toDouble();
    String? s(dynamic v) => v as String?;

    return CurrencyModel(
      currencyId: i(json['currencyID']) ?? i(json['CurrencyID']) ?? 0,
      currencyArName: s(json['currencyName']) ??
          s(json['CurrencyName']) ??
          s(json['ArabicName']) ??
          s(json['CurrencyArName']) ??
          '',
      currencyEnName: s(json['currencyEName']) ??
          s(json['CurrencyEName']) ??
          s(json['EnglishName']) ??
          s(json['CurrencyEnName']) ??
          '',
      currencySymbol:
          s(json['currencySymbol']) ?? s(json['CurrencySymbol']) ?? '',
      rate: d(json['rate']) ?? d(json['Rate']) ?? 1.0,
      isDefault: json['isDefault'] == true ||
          json['IsDefault'] == true ||
          json['isDefault'] == 1 ||
          json['IsDefault'] == 1,
      partArName: s(json['partName']) ?? s(json['PartName']) ?? '',
      partEnName: s(json['partEName']) ?? s(json['PartEName']) ?? '',
      // Server typo: `partPrecition` (sic). Accept both spellings.
      partPrecision: i(json['partPrecition']) ??
          i(json['partPrecision']) ??
          i(json['PartPrecition']) ??
          0,
      totCurrencyArName:
          s(json['totCurrencyName']) ?? s(json['TotCurrencyName']) ?? '',
      totCurrencyEnName:
          s(json['totCurrencyEName']) ?? s(json['TotCurrencyEName']) ?? '',
      totPartArName: s(json['totPartName']) ?? s(json['TotPartName']) ?? '',
      totPartEnName: s(json['totPartEName']) ?? s(json['TotPartEName']) ?? '',
      pricesDigits:
          s(json['pricesDigits']) ?? s(json['PricesDigits']) ?? '0.00',
    );
  }

  Map<String, dynamic> toJson() => {
        'currencyID': currencyId,
        'currencyName': currencyArName,
        'currencyEName': currencyEnName,
        'currencySymbol': currencySymbol,
        'rate': rate,
        'isDefault': isDefault,
        'partName': partArName,
        'partEName': partEnName,
        'partPrecition': partPrecision,
        'totCurrencyName': totCurrencyArName,
        'totCurrencyEName': totCurrencyEnName,
        'totPartName': totPartArName,
        'totPartEName': totPartEnName,
        'pricesDigits': pricesDigits,
      };

  @override
  List<Object?> get props => [currencyId];
}
