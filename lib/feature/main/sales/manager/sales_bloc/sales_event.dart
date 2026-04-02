import 'package:equatable/equatable.dart';

abstract class SalesEvent extends Equatable {
  const SalesEvent();

  @override
  List<Object?> get props => [];
}

class FetchProducts extends SalesEvent {
  const FetchProducts();
}

class SearchProducts extends SalesEvent {
  final String query;
  const SearchProducts(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterByCategory extends SalesEvent {
  final String? categoryId;
  const FilterByCategory(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class LoadMoreProducts extends SalesEvent {
  const LoadMoreProducts();
}