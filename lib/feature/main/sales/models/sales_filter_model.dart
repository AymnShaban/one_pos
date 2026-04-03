part of '../sales_imports.dart';

class CategoryFilterModel extends Equatable {
  final String id;
  final String arName;
  final String enName;

  const CategoryFilterModel({
    required this.id,
    required this.arName,
    required this.enName,
  });

  factory CategoryFilterModel.fromJson(Map<String, dynamic> json) {
    return CategoryFilterModel(
      id: json['CategoryId']?.toString() ?? '',
      arName: json['CategoryArName'] ?? '',
      enName: json['CategoryEnName'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, arName, enName];
}