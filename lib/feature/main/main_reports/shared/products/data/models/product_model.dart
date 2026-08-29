
import '../../../shared_imports.dart';
class ProductModel extends Equatable {
  final int id;
  final String mtid;
  final String mtName;
  final String mteName;
  final String groupName;
  final String groupEName;

  const ProductModel({
    required this.id,
    required this.mtid,
    required this.mtName,
    required this.mteName,
    required this.groupName,
    required this.groupEName,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      mtid: json['mtid']?.toString() ?? '',
      mtName: json['mtName'] ?? '',
      mteName: json['mteName'] ?? '',
      groupName: json['groupName'] ?? '',
      groupEName: json['groupEName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mtid': mtid,
      'mtName': mtName,
      'mteName': mteName,
      'groupName': groupName,
      'groupEName': groupEName,
    };
  }

  @override
  List<Object?> get props => [id, mtid, mtName, mteName, groupName, groupEName];
}