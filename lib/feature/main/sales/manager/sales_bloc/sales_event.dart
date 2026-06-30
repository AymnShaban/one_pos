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

/// Re-fetch the first page for the currently selected category.
/// Used when the active branch changes in the sales tab.
class ReloadProducts extends SalesEvent {
  const ReloadProducts();
}

/// Set the active sales pattern id (from `InvoiceSetupBloc`). Triggers a
/// reload if a category is already selected — the new
/// `/api/Product/GetProductsByPatternIdAndGroupIdV1` endpoint needs both ids.
class SetActivePattern extends SalesEvent {
  final int? patternId;
  const SetActivePattern(this.patternId);

  @override
  List<Object?> get props => [patternId];
}
