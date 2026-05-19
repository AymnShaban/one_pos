part of '../basket_imports.dart';

/// A payment way (gateway) returned by EndPoints.getPayWays.
class PayWayModel extends Equatable {
  final int pwId;
  final int code;
  final String arName;
  final String enName;
  final String? notes;
  final bool showInSales;
  final bool showInPurchase;

  const PayWayModel({
    required this.pwId,
    required this.code,
    required this.arName,
    required this.enName,
    this.notes,
    this.showInSales = true,
    this.showInPurchase = true,
  });

  factory PayWayModel.fromJson(Map<String, dynamic> json) {
    bool asBool(dynamic v) => v == true || v == 1;
    return PayWayModel(
      pwId: json['PWID'] ?? 0,
      code: json['Code_PW'] ?? 0,
      arName: json['Name_PW'] ?? '',
      enName: json['EName_PW'] ?? '',
      notes: json['Notes_PW'] as String?,
      showInSales: asBool(json['ShowInSales_PW']),
      showInPurchase: asBool(json['ShowInPurchase_PW']),
    );
  }

  Map<String, dynamic> toJson() => {
        'PWID': pwId,
        'Code_PW': code,
        'Name_PW': arName,
        'EName_PW': enName,
        'Notes_PW': notes,
        'ShowInSales_PW': showInSales,
        'ShowInPurchase_PW': showInPurchase,
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
