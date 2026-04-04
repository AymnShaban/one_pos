part of '../new_invoice_imports.dart';

class CategoryModel extends Equatable {
  final int categoryId;
  final String categoryArName;
  final String categoryEnName;

  const CategoryModel({
    required this.categoryId,
    required this.categoryArName,
    required this.categoryEnName,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId:     json['CategoryId'] ?? 0,
      categoryArName: json['CategoryArName'] ?? '',
      categoryEnName: json['CategoryEnName'] ?? '',
    );
  }

  @override
  List<Object?> get props => [categoryId, categoryArName, categoryEnName];
}