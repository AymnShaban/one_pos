part of '../../invoice_setup_imports.dart';

/// One bloc per endpoint. Owns the branch list + the user's current
/// selection. Consumers (Sales tab, Invoice Collection screen) drive
/// `LoadBranches` from their own `initState`.
class BranchBloc extends Bloc<BranchEvent, BaseState<BranchModel>> {
  final BranchDataSource _dataSource;

  BranchBloc({required BranchDataSource dataSource})
      : _dataSource = dataSource,
        super(const BaseState<BranchModel>()) {
    on<LoadBranches>(_onLoad);
    on<SelectBranchById>(_onSelect);
  }

  /// Auto-selected branch id once the list lands, surfaced via state.metadata
  /// so consumers can read it without a separate field on the state class.
  int get selectedId => (state.metadata['selectedId'] as int?) ?? 0;

  BranchModel? get selectedBranch {
    final id = selectedId;
    return state.items.where((b) => b.branchId == id).isNotEmpty
        ? state.items.firstWhere((b) => b.branchId == id)
        : null;
  }

  Future<void> _onLoad(
    LoadBranches event,
    Emitter<BaseState<BranchModel>> emit,
  ) async {
    // Idempotent: don't refetch while loading or already populated.
    if (state.status == Status.loading) return;
    if (state.status == Status.success && state.items.isNotEmpty) return;

    emit(state.copyWith(status: Status.loading));

    final result = await _dataSource.getBranches();
    result.fold(
      (failure) => emit(state.copyWith(
        status: Status.failure,
        errorMessage: failure.message,
      )),
      (all) {
        // Filter out deactivated rows — they shouldn't appear in dropdowns.
        final active = all.where((b) => !b.deactivated).toList();
        final autoSelectedId =
            active.isNotEmpty ? active.first.branchId : 0;
        emit(state.copyWith(
          status: Status.success,
          items: active,
          metadata: {'selectedId': autoSelectedId},
        ));
      },
    );
  }

  void _onSelect(
    SelectBranchById event,
    Emitter<BaseState<BranchModel>> emit,
  ) {
    emit(state.copyWith(metadata: {'selectedId': event.branchId}));
  }
}
