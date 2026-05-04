part of '../../sales_imports.dart';

abstract class SalesEvent extends Equatable {
  const SalesEvent();

  @override
  List<Object?> get props => [];
}

class FilterByCategory extends SalesEvent {
  final int? categoryId;
  const FilterByCategory(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class LoadMoreProducts extends SalesEvent {
  const LoadMoreProducts();
}
