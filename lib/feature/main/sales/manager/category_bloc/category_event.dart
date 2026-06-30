part of '../../sales_imports.dart';

abstract class SalesCategoryEvent extends Equatable {
  const SalesCategoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadSalesCategories extends SalesCategoryEvent {
  const LoadSalesCategories();
}

class SelectSalesParent extends SalesCategoryEvent {
  final int parentId;
  const SelectSalesParent(this.parentId);

  @override
  List<Object?> get props => [parentId];
}

class SelectSalesChild extends SalesCategoryEvent {
  final int categoryId;
  const SelectSalesChild(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}
