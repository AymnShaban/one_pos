import '../../items_movement_import.dart';
class MTIReportSourceModel {
  final String name;
  final int supposeType;

  const MTIReportSourceModel({
    required this.name,
    required this.supposeType,
  });

  factory MTIReportSourceModel.fromJson(Map<String, dynamic> json) {
    return MTIReportSourceModel(
      name: json['name'] ?? '',
      supposeType: json['supposeType'] ?? 0,
    );
  }
}