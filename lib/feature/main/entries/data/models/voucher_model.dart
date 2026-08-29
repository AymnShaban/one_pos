import '../../entries_imports.dart';

class VoucherTypeModel {
  final int? frmNum;
  final String? arAbrev;
  final String? arName;
  final String? enAberv;
  final String? enName;
  final int? type;
  final int? gbr;
  final int? acID;
  final double? rate;
  final bool? autoPosting;

  const VoucherTypeModel({
    this.frmNum,
    this.arAbrev,
    this.arName,
    this.enAberv,
    this.enName,
    this.type,
    this.gbr,
    this.acID,
    this.rate,
    this.autoPosting,
  });

  factory VoucherTypeModel.fromJson(Map<String, dynamic> json) {
    return VoucherTypeModel(
      frmNum: json['frmNum'] as int?,
      arAbrev: json['arAbrev'] as String?,
      arName: json['arName'] as String?,
      enAberv: json['enAberv'] as String?,
      enName: json['enName'] as String?,
      type: json['type'] as int?,
      gbr: json['gbr'] as int?,
      acID: json['acID'] as int?,
      rate: (json['rate'] as num?)?.toDouble(),
      autoPosting: json['autoPosting'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'frmNum': frmNum,
      'arAbrev': arAbrev,
      'arName': arName,
      'enAberv': enAberv,
      'enName': enName,
      'type': type,
      'gbr': gbr,
      'acID': acID,
      'rate': rate,
      'autoPosting': autoPosting,
    };
  }
}