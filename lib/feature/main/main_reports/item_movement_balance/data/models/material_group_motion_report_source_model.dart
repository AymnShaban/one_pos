import '../../item_movement_balance_import.dart';
class MaterialGroupMotionReportSourceModel extends Equatable {
  final int frmNum;
  final int type;
  final String eName;
  final String name;

  const MaterialGroupMotionReportSourceModel({
    required this.frmNum,
    required this.type,
    required this.eName,
    required this.name,
  });

  factory MaterialGroupMotionReportSourceModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return MaterialGroupMotionReportSourceModel(
      frmNum: json['frmNum'] ?? 0,
      type: json['type'] ?? 0,
      eName: json['eName'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'frmNum': frmNum,
      'type': type,
      'eName': eName,
      'name': name,
    };
  }

  @override
  List<Object?> get props => [
    frmNum,
    type,
    eName,
    name,
  ];
}