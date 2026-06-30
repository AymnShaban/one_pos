part of '../../sales_imports.dart';

/// One bloc, one fetch. Holds the flat row list from
/// `/api/Category/GetSubCategory` plus the currently selected parent and
/// child ids in `metadata`. The Sales tab listens for
/// `metadata['selectedCategoryId']` changes to drive product fetches.
class SalesCategoryBloc extends Bloc<SalesCategoryEvent, BaseState<SalesCategoryModel>> {
  final SalesCategoryDataSource _dataSource;

  SalesCategoryBloc({required SalesCategoryDataSource dataSource})
      : _dataSource = dataSource,
        super(const BaseState<SalesCategoryModel>()) {
    on<LoadSalesCategories>(_onLoad);
    on<SelectSalesParent>(_onSelectParent);
    on<SelectSalesChild>(_onSelectChild);
  }

  Future<void> _onLoad(
    LoadSalesCategories event,
    Emitter<BaseState<SalesCategoryModel>> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _dataSource.getCategories();
    result.fold(
      (failure) => emit(state.copyWith(
        status: Status.failure,
        failure: failure,
        errorMessage: failure.message,
      )),
      (rows) {
        final visible = rows
            .where((c) => !c.invisibleCategory && !c.stopedCategory)
            .toList();
        int? parentId;
        int? categoryId;
        if (visible.isNotEmpty) {
          parentId = visible.first.parentCategoryId;
          categoryId = visible
              .firstWhere((c) => c.parentCategoryId == parentId)
              .categoryId;
        }
        emit(state.copyWith(
          status: Status.success,
          items: visible,
          metadata: {
            'selectedParentId': parentId,
            'selectedCategoryId': categoryId,
          },
        ));
      },
    );
  }

  void _onSelectParent(
    SelectSalesParent event,
    Emitter<BaseState<SalesCategoryModel>> emit,
  ) {
    final firstChild = state.items
        .firstWhere(
          (c) => c.parentCategoryId == event.parentId,
          orElse: () => state.items.isNotEmpty
              ? state.items.first
              : const SalesCategoryModel(
                  parentCategoryId: 0,
                  categoryId: 0,
                  categoryCode: '',
                  categoryArName: '',
                  categoryEnName: '',
                  invisibleCategory: false,
                  stopedCategory: false,
                ),
        )
        .categoryId;
    emit(state.copyWith(metadata: {
      ...state.metadata,
      'selectedParentId': event.parentId,
      'selectedCategoryId': firstChild,
    }));
  }

  void _onSelectChild(
    SelectSalesChild event,
    Emitter<BaseState<SalesCategoryModel>> emit,
  ) {
    emit(state.copyWith(metadata: {
      ...state.metadata,
      'selectedCategoryId': event.categoryId,
    }));
  }

  /// Ordered distinct parent ids (first occurrence wins).
  List<int> get parentIds {
    final seen = <int>{};
    final out = <int>[];
    for (final c in state.items) {
      if (seen.add(c.parentCategoryId)) out.add(c.parentCategoryId);
    }
    return out;
  }

  /// Children of the currently selected parent.
  List<SalesCategoryModel> get currentChildren {
    final pid = state.metadata['selectedParentId'] as int?;
    if (pid == null) return const [];
    return state.items.where((c) => c.parentCategoryId == pid).toList();
  }

  /// First row matching the given parent id — used by the parent-strip
  /// widget to fetch the localized parent name once per chip.
  SalesCategoryModel? parentRow(int parentId) {
    for (final c in state.items) {
      if (c.parentCategoryId == parentId) return c;
    }
    return null;
  }
}
