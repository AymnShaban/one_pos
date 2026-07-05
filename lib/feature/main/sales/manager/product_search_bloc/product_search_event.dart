part of '../../sales_imports.dart';

abstract class ProductSearchEvent extends Equatable {
  const ProductSearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchProducts extends ProductSearchEvent {
  final String query;

  const SearchProducts(this.query);

  @override
  List<Object?> get props => [query];
}

class LoadMoreSearchResults extends ProductSearchEvent {
  const LoadMoreSearchResults();
}
