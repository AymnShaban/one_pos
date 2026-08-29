import '../../../branches_import.dart';

class BranchesBloc extends Bloc<BranchesEvent, BranchesState> {
  final BranchesDataSource dataSource;

  BranchesBloc({required this.dataSource})
      : super(const BranchesState()) {
    on<LoadBranches>(_onLoadBranches);
    on<UpdateBranchesSelection>(_onUpdateBranchesSelection);
  }

  Future<void> _onLoadBranches(
      LoadBranches event,
      Emitter<BranchesState> emit,
      ) async {
    emit(state.copyWith(status: Status.loading, clearError: true));

    final result = await dataSource.getBranches();

    result.fold(
          (failure) {
        emit(
          state.copyWith(
            status: Status.failure,
            errorMessage: failure.message,
          ),
        );
      },
          (branches) {
        final allIds = branches.map((e) => e.id).toSet();
        emit(
          state.copyWith(
            status: Status.success,
            branches: branches,
            selectedBranchIds: allIds,
            clearError: true,
          ),
        );
      },
    );
  }

  void _onUpdateBranchesSelection(
      UpdateBranchesSelection event,
      Emitter<BranchesState> emit,
      ) {
    final newSelection = event.branchIds;

    if (newSelection.isEmpty) {

      emit(
        state.copyWith(
          selectedBranchIds: state.allBranchIds.toSet(),
          clearError: true,
        ),
      );
      return;
    }

    final validIds = newSelection.where(
          (id) => state.branches.any((b) => b.id == id),
    ).toSet();

    if (validIds.isEmpty) {
      emit(
        state.copyWith(
          selectedBranchIds: state.allBranchIds.toSet(),
          clearError: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        selectedBranchIds: validIds,
        clearError: true,
      ),
    );
  }
}