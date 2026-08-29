import '../../../shared_imports.dart';
abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductsEvent {
  final String? search;

  const LoadProducts({this.search});

  @override
  List<Object?> get props => [search];
}

class ClearProducts extends ProductsEvent {
  const ClearProducts();
}