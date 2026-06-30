part of '../sales_imports.dart';

/// Flat row from `/api/Category/GetSubCategory` — carries both the parent
/// category's identity and one of its children. The Sales tab derives the
/// parent strip by deduping `parentCategoryId` and the child strip by
/// filtering on the currently selected parent.
class SalesCategoryModel extends Equatable {
  final int parentCategoryId;
  final String? parentCategoryCode;
  final String? parentCategoryArName;
  final String? parentCategoryEnName;
  final int categoryId;
  final String categoryCode;
  final String categoryArName;
  final String categoryEnName;
  final String? categoryImage;
  final bool invisibleCategory;
  final bool stopedCategory;

  const SalesCategoryModel({
    required this.parentCategoryId,
    this.parentCategoryCode,
    this.parentCategoryArName,
    this.parentCategoryEnName,
    required this.categoryId,
    required this.categoryCode,
    required this.categoryArName,
    required this.categoryEnName,
    this.categoryImage,
    required this.invisibleCategory,
    required this.stopedCategory,
  });

  factory SalesCategoryModel.fromJson(Map<String, dynamic> json) {
    return SalesCategoryModel(
      parentCategoryId: json['parentCategoryId'] as int? ?? 0,
      parentCategoryCode: json['parentCategoryCode'] as String?,
      parentCategoryArName: json['parentCategoryArName'] as String?,
      parentCategoryEnName: json['parentCategoryEnName'] as String?,
      categoryId: json['categoryId'] as int? ?? 0,
      categoryCode: json['categoryCode'] as String? ?? '',
      categoryArName: json['categoryArName'] as String? ?? '',
      categoryEnName: json['categoryEnName'] as String? ?? '',
      categoryImage: json['categoryImage'] as String?,
      invisibleCategory: json['invisibleCategory'] as bool? ?? false,
      stopedCategory: json['stopedCategory'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
        parentCategoryId,
        categoryId,
        categoryCode,
        categoryArName,
        categoryEnName,
      ];
}
