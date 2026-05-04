part of '../../sales_imports.dart';

abstract class SubCategoryEvent extends Equatable {
  const SubCategoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchSubCategories extends SubCategoryEvent {
  final int parentCategoryId;
  final int branchId;

  const FetchSubCategories({
    required this.parentCategoryId,
    this.branchId = 1,
  });

  @override
  List<Object?> get props => [parentCategoryId, branchId];
}

class SelectSubCategory extends SubCategoryEvent {
  final int categoryId;

  const SelectSubCategory(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class ClearSubCategories extends SubCategoryEvent {
  const ClearSubCategories();
}
