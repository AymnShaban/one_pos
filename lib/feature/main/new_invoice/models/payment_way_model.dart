part of '../new_invoice_imports.dart';

class PaymentWayModel extends Equatable {
  final int code;
  final String nameAr;
  final String nameEn;

  const PaymentWayModel({
    required this.code,
    required this.nameAr,
    required this.nameEn,
  });

  factory PaymentWayModel.fromJson(Map<String, dynamic> json) {
    return PaymentWayModel(
      code:   json['Code_PW']  ?? 0,
      nameAr: json['Name_PW']  ?? '',
      nameEn: json['EName_PW'] ?? '',
    );
  }

  bool get isCash => code == 0 || nameAr == 'نقدا' || nameEn == 'Cash';

  @override
  List<Object?> get props => [code, nameAr, nameEn];
}