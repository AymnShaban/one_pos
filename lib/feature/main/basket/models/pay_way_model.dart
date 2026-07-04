part of '../basket_imports.dart';

/// A payment way (gateway) returned by EndPoints.getPayWays.
class PayWayModel extends Equatable {
  final int pwId;
  final int code;
  final String arName;
  final String enName;
  final String? notes;
  final int? acId;
  final String acountCode;
  final String acountName;
  final String acountEnglishName;
  final bool showInSales;
  final bool showInPurchase;

  const PayWayModel({
    required this.pwId,
    required this.code,
    required this.arName,
    required this.enName,
    this.notes,
    this.acId,
    this.acountCode = '',
    this.acountName = '',
    this.acountEnglishName = '',
    this.showInSales = true,
    this.showInPurchase = true,
  });

  factory PayWayModel.fromJson(Map<String, dynamic> json) {
    bool asBool(dynamic v) => v == true || v == 1;
    return PayWayModel(
      pwId: json['pwid'] ?? 0,
      code: json['code_PW'] ?? 0,
      arName: json['name_PW'] ?? '',
      enName: json['eName_PW'] ?? '',
      notes: json['notes_PW'] as String?,
      acId: json['acID_ACI'] as int?,
      acountCode: json['acountCode'] ?? '',
      acountName: json['acountName'] ?? '',
      acountEnglishName: json['acountEnglishName'] ?? '',
      showInSales: asBool(json['showInSales_PW']),
      showInPurchase: asBool(json['showInPurchase_PW']),
    );
  }

  Map<String, dynamic> toJson() => {
        'pwid': pwId,
        'code_PW': code,
        'name_PW': arName,
        'eName_PW': enName,
        'notes_PW': notes,
        'acID_ACI': acId,
        'acountCode': acountCode,
        'acountName': acountName,
        'acountEnglishName': acountEnglishName,
        'showInSales_PW': showInSales,
        'showInPurchase_PW': showInPurchase,
      };

  /// Localized name with a fallback to the other language, then the code.
  String displayName(bool isAr) {
    final primary = isAr ? arName : enName;
    if (primary.trim().isNotEmpty) return primary;
    final fallback = isAr ? enName : arName;
    return fallback.trim().isNotEmpty ? fallback : '$code';
  }

  @override
  List<Object?> get props => [pwId, code];
}
