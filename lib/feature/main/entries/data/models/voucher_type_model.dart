import  '../../entries_imports.dart';
class VoucherTypeModel {
  final int? frmNum;
  final String? arName;
  final String? enName;
  final String? arAbrev;
  final String? enAberv;
  final int? type;
  final int? gbr;
  final int? acId;
  final double? rate;
  final bool? autoPosting;

  VoucherTypeModel({
    this.frmNum,
    this.arName,
    this.enName,
    this.arAbrev,
    this.enAberv,
    this.type,
    this.gbr,
    this.acId,
    this.rate,
    this.autoPosting,
  });

  factory VoucherTypeModel.fromJson(Map<String, dynamic> json) {
    return VoucherTypeModel(
      frmNum: json['frmNum'] as int?,
      arName: json['arName'] as String?,
      enName: json['enName'] as String?,
      arAbrev: json['arAbrev'] as String?,
      enAberv: json['enAberv'] as String?,
      type: json['type'] as int?,
      gbr: json['gbr'] as int?,
      acId: json['acId'] as int?,
      rate: (json['rate'] as num?)?.toDouble(),
      autoPosting: json['autoPosting'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'frmNum': frmNum,
      'arName': arName,
      'enName': enName,
      'arAbrev': arAbrev,
      'enAberv': enAberv,
      'type': type,
      'gbr': gbr,
      'acId': acId,
      'rate': rate,
      'autoPosting': autoPosting,
    };
  }



  VoucherType get voucherType {
    switch (frmNum) {
      case 1:
        return VoucherType.cashReceipt;
      case 2:
        return VoucherType.checkReceipt;
      case 3:
        return VoucherType.cashPayment;
      case 4:
        return VoucherType.checkPayment;
      case 5:
        return VoucherType.generalJournal;
      default:
        return VoucherType.unknown;
    }
  }
}

enum VoucherType {
  cashReceipt,
  checkReceipt,
  cashPayment,
  checkPayment,
  generalJournal,
  unknown,
}