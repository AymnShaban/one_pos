part of '../../sales_imports.dart';

class MainCategoryBloc
    extends Bloc<MainCategoryEvent, BaseState<MainCategoryModel>> {
  final MainCategoryDataSource _mainCategoryDataSource;

  MainCategoryBloc({required MainCategoryDataSource mainCategoryDataSource})
      : _mainCategoryDataSource = mainCategoryDataSource,
        super(const BaseState<MainCategoryModel>()) {
    on<FetchMainCategories>(_onFetchMainCategories);
    on<SelectMainCategory>(_onSelectMainCategory);
  }

  Future<void> _onFetchMainCategories(
    FetchMainCategories event,
    Emitter<BaseState<MainCategoryModel>> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await _mainCategoryDataSource.getMainCategories();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          failure: failure,
          errorMessage: failure.message,
        ),
      ),
      (categories) => emit(
        state.copyWith(
          status: Status.success,
          items: categories,
          metadata: {
            'selectedMainCategoryId':
                categories.isNotEmpty ? categories.first.categoryId : null,
          },
        ),
      ),
    );
  }

  void _onSelectMainCategory(
    SelectMainCategory event,
    Emitter<BaseState<MainCategoryModel>> emit,
  ) {
    emit(state.copyWith(metadata: {
      ...state.metadata,
      'selectedMainCategoryId': event.categoryId,
    }));
  }
}
