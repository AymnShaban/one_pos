import  '../../entries_imports.dart';
class EtsPatternModel {
  final int? frmNum;
  final String? arName;
  final String? enName;
  final String? arAbrev;
  final String? enAberv;

  EtsPatternModel({
    this.frmNum,
    this.arName,
    this.enName,
    this.arAbrev,
    this.enAberv,
  });

  factory EtsPatternModel.fromJson(Map<String, dynamic> json) {
    return EtsPatternModel(
      frmNum: json['frmNum'] as int?,
      arName: json['arName'] as String?,
      enName: json['enName'] as String?,
      arAbrev: json['arAbrev'] as String?,
      enAberv: json['enAberv'] as String?,
    );
  }


}