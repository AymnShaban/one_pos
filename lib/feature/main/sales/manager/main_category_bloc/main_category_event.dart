part of '../../sales_imports.dart';

abstract class MainCategoryEvent extends Equatable {
  const MainCategoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchMainCategories extends MainCategoryEvent {
  const FetchMainCategories();
}

class SelectMainCategory extends MainCategoryEvent {
  final int categoryId;

  const SelectMainCategory(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}
