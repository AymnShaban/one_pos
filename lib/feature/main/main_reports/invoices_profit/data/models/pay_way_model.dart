
import '../../invoice_profit_imports.dart';

class PayWayModel extends Equatable {
  final int pwid;
  final int code_PW;
  final String name_PW;
  final String eName_PW;
  final String notes_PW;
  final int? acID_ACI;
  final String acountCode;
  final String acountName;
  final String acountEnglishName;
  final bool showInSales_PW;
  final bool showInPurchase_PW;

  const PayWayModel({
    required this.pwid,
    required this.code_PW,
    required this.name_PW,
    required this.eName_PW,
    required this.notes_PW,
    this.acID_ACI,
    required this.acountCode,
    required this.acountName,
    required this.acountEnglishName,
    required this.showInSales_PW,
    required this.showInPurchase_PW,
  });

  factory PayWayModel.fromJson(Map<String, dynamic> json) {
    return PayWayModel(
      pwid: json['pwid'] ?? 0,
      code_PW: json['code_PW'] ?? 0,
      name_PW: json['name_PW'] ?? '',
      eName_PW: json['eName_PW'] ?? '',
      notes_PW: json['notes_PW'] ?? '',
      acID_ACI: json['acID_ACI'],
      acountCode: json['acountCode'] ?? '',
      acountName: json['acountName'] ?? '',
      acountEnglishName: json['acountEnglishName'] ?? '',
      showInSales_PW: json['showInSales_PW'] ?? false,
      showInPurchase_PW: json['showInPurchase_PW'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pwid': pwid,
      'code_PW': code_PW,
      'name_PW': name_PW,
      'eName_PW': eName_PW,
      'notes_PW': notes_PW,
      'acID_ACI': acID_ACI,
      'acountCode': acountCode,
      'acountName': acountName,
      'acountEnglishName': acountEnglishName,
      'showInSales_PW': showInSales_PW,
      'showInPurchase_PW': showInPurchase_PW,
    };
  }

  @override
  List<Object?> get props => [
    pwid,
    code_PW,
    name_PW,
    eName_PW,
    notes_PW,
    acID_ACI,
    acountCode,
    acountName,
    acountEnglishName,
    showInSales_PW,
    showInPurchase_PW,
  ];
}