part of '../../sales_imports.dart';

class SubCategoryBloc
    extends Bloc<SubCategoryEvent, BaseState<SubCategoryModel>> {
  final SubCategoryDataSource _subCategoryDataSource;

  SubCategoryBloc({required SubCategoryDataSource subCategoryDataSource})
      : _subCategoryDataSource = subCategoryDataSource,
        super(const BaseState<SubCategoryModel>()) {
    on<FetchSubCategories>(_onFetchSubCategories);
    on<SelectSubCategory>(_onSelectSubCategory);
    on<ClearSubCategories>(_onClearSubCategories);
  }

  Future<void> _onFetchSubCategories(
    FetchSubCategories event,
    Emitter<BaseState<SubCategoryModel>> emit,
  ) async {
    emit(state.copyWith(status: Status.loading, items: []));

    final result = await _subCategoryDataSource.getSubCategories(
      parentCategoryId: event.parentCategoryId,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          failure: failure,
          errorMessage: failure.message,
        ),
      ),
      (subs) => emit(
        state.copyWith(
          status: Status.success,
          items: subs,
          metadata: {
            'selectedSubCategoryId': subs.isNotEmpty ? subs.first.categoryId : null,
          },
        ),
      ),
    );
  }

  void _onSelectSubCategory(
    SelectSubCategory event,
    Emitter<BaseState<SubCategoryModel>> emit,
  ) {
    emit(state.copyWith(metadata: {
      ...state.metadata,
      'selectedSubCategoryId': event.categoryId,
    }));
  }

  void _onClearSubCategories(
    ClearSubCategories event,
    Emitter<BaseState<SubCategoryModel>> emit,
  ) {
    emit(const BaseState<SubCategoryModel>());
  }
}
