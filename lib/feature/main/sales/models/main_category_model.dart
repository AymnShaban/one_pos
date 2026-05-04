part of '../sales_imports.dart';

class MainCategoryModel extends Equatable {
  final int parentCategoryId;
  final String? parentCategoryCode;
  final String? parentCategoryArName;
  final String? parentCategoryEnName;
  final int categoryId;
  final String categoryCode;
  final String categoryArName;
  final String categoryEnName;
  final String? notes;
  final bool addCategoryToClinics;
  final bool addCategoryToRest;
  final bool addCategoryToSalon;
  final bool invisibleCategory;
  final bool stopedCategory;
  final bool clinicCategory;
  final String categoryImage;

  const MainCategoryModel({
    required this.parentCategoryId,
    this.parentCategoryCode,
    this.parentCategoryArName,
    this.parentCategoryEnName,
    required this.categoryId,
    required this.categoryCode,
    required this.categoryArName,
    required this.categoryEnName,
    this.notes,
    required this.addCategoryToClinics,
    required this.addCategoryToRest,
    required this.addCategoryToSalon,
    required this.invisibleCategory,
    required this.stopedCategory,
    required this.clinicCategory,
    required this.categoryImage,
  });

  factory MainCategoryModel.fromJson(Map<String, dynamic> json) {
    return MainCategoryModel(
      parentCategoryId: json['ParentCategoryId'] as int? ?? 0,
      parentCategoryCode: json['ParentCategoryCode'] as String?,
      parentCategoryArName: json['ParentCategoryArName'] as String?,
      parentCategoryEnName: json['ParentCategoryEnName'] as String?,
      categoryId: json['CategoryId'] as int? ?? 0,
      categoryCode: json['CategoryCode'] as String? ?? '',
      categoryArName: json['CategoryArName'] as String? ?? '',
      categoryEnName: json['CategoryEnName'] as String? ?? '',
      notes: json['Notes'] as String?,
      addCategoryToClinics: json['AddCategoryToClinics'] as bool? ?? false,
      addCategoryToRest: json['AddCategoryToRest'] as bool? ?? false,
      addCategoryToSalon: json['AddCategoryToSalon'] as bool? ?? false,
      invisibleCategory: json['InvisibleCategory'] as bool? ?? false,
      stopedCategory: json['StopedCategory'] as bool? ?? false,
      clinicCategory: json['ClinicCategory'] as bool? ?? false,
      categoryImage: json['CategoryImage'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [
    parentCategoryId,
    parentCategoryCode,
    parentCategoryArName,
    parentCategoryEnName,
    categoryId,
    categoryCode,
    categoryArName,
    categoryEnName,
    notes,
    addCategoryToClinics,
    addCategoryToRest,
    addCategoryToSalon,
    invisibleCategory,
    stopedCategory,
    clinicCategory,
    categoryImage,
  ];
}
