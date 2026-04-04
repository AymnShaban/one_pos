part of '../../new_invoice_imports.dart';


class CategoryState {
  final BaseState<CategoryModel> mainCategories;
  final BaseState<CategoryModel> subCategories;
  final int selectedMainIndex;
  final int selectedSubIndex;

  const CategoryState({
    this.mainCategories = const BaseState(),
    this.subCategories  = const BaseState(),
    this.selectedMainIndex = 0,
    this.selectedSubIndex  = 0,
  });

  CategoryState copyWith({
    BaseState<CategoryModel>? mainCategories,
    BaseState<CategoryModel>? subCategories,
    int? selectedMainIndex,
    int? selectedSubIndex,
  }) {
    return CategoryState(
      mainCategories:     mainCategories     ?? this.mainCategories,
      subCategories:      subCategories      ?? this.subCategories,
      selectedMainIndex:  selectedMainIndex  ?? this.selectedMainIndex,
      selectedSubIndex:   selectedSubIndex   ?? this.selectedSubIndex,
    );
  }
}

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryDataSource _dataSource;

  CategoryBloc({required CategoryDataSource dataSource})
      : _dataSource = dataSource,
        super(const CategoryState()) {
    on<LoadMainCategories>(_onLoadMain);
    on<LoadSubCategories>(_onLoadSub);
    on<SelectMainCategory>(_onSelectMain);
    on<SelectSubCategory>(_onSelectSub);
  }

  Future<void> _onLoadMain(
      LoadMainCategories event,
      Emitter<CategoryState> emit,
      ) async {
    emit(state.copyWith(
      mainCategories: state.mainCategories.copyWith(status: Status.loading),
    ));

    final result = await _dataSource.getMainCategories();
    result.fold(
          (failure) => emit(state.copyWith(
        mainCategories: state.mainCategories.copyWith(
          status: Status.failure,
          errorMessage: failure.message,
        ),
      )),
          (data) {
        emit(state.copyWith(
          mainCategories: state.mainCategories.copyWith(
            status: Status.success,
            items: data,
          ),
        ));
        // Auto-load first category's sub-categories
        if (data.isNotEmpty) {
          add(LoadSubCategories(data.first.categoryId));
        }
      },
    );
  }

  Future<void> _onLoadSub(
      LoadSubCategories event,
      Emitter<CategoryState> emit,
      ) async {
    emit(state.copyWith(
      subCategories: state.subCategories.copyWith(status: Status.loading),
    ));

    final result = await _dataSource.getSubCategories(event.parentId);
    result.fold(
          (failure) => emit(state.copyWith(
        subCategories: state.subCategories.copyWith(
          status: Status.failure,
          errorMessage: failure.message,
        ),
      )),
          (data) => emit(state.copyWith(
        subCategories: state.subCategories.copyWith(
          status: Status.success,
          items: data,
        ),
      )),
    );
  }

  void _onSelectMain(SelectMainCategory event, Emitter<CategoryState> emit) {
    emit(state.copyWith(
      selectedMainIndex: event.index,
      selectedSubIndex:  0,
    ));
    add(LoadSubCategories(event.categoryId));
  }

  void _onSelectSub(SelectSubCategory event, Emitter<CategoryState> emit) {
    emit(state.copyWith(selectedSubIndex: event.index));
  }
}