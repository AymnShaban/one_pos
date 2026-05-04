part of '../../new_invoice_imports.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadMainCategories extends CategoryEvent {
  final int branchId;

  const LoadMainCategories({required this.branchId});

  @override
  List<Object?> get props => [branchId];
}

class LoadSubCategories extends CategoryEvent {
  final int parentId;
  final int branchId;

  const LoadSubCategories(this.parentId, this.branchId);

  @override
  List<Object?> get props => [parentId, branchId];
}

class SelectMainCategory extends CategoryEvent {
  final int index;
  final int categoryId;
  final int branchId;

  const SelectMainCategory({
    required this.index,
    required this.categoryId,
    required this.branchId,
  });

  @override
  List<Object?> get props => [index, categoryId, branchId];
}

class SelectSubCategory extends CategoryEvent {
  final int index;
  final int categoryId;
  const SelectSubCategory({required this.index, required this.categoryId});

  @override
  List<Object?> get props => [index, categoryId];
}
