part of '../../new_invoice_imports.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadMainCategories extends CategoryEvent {
  const LoadMainCategories();
}

class LoadSubCategories extends CategoryEvent {
  final int parentId;
  const LoadSubCategories(this.parentId);

  @override
  List<Object?> get props => [parentId];
}

class SelectMainCategory extends CategoryEvent {
  final int index;
  final int categoryId;
  const SelectMainCategory({required this.index, required this.categoryId});

  @override
  List<Object?> get props => [index, categoryId];
}

class SelectSubCategory extends CategoryEvent {
  final int index;
  final int categoryId;
  const SelectSubCategory({required this.index, required this.categoryId});

  @override
  List<Object?> get props => [index, categoryId];
}