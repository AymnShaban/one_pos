import '../../../branches_import.dart';

abstract class BranchesEvent extends Equatable {
  const BranchesEvent();

  @override
  List<Object?> get props => [];
}

class LoadBranches extends BranchesEvent {}

class UpdateBranchesSelection extends BranchesEvent {
  final Set<int> branchIds;

  const UpdateBranchesSelection({required this.branchIds});


  factory UpdateBranchesSelection.fromList(List<int> ids) {
    return UpdateBranchesSelection(branchIds: ids.toSet());
  }

  factory UpdateBranchesSelection.toggle({
    required int branchId,
    required bool isSelected,
    required Set<int> currentSelection,
  }) {
    final newSelection = Set<int>.from(currentSelection);
    if (isSelected) {
      newSelection.remove(branchId);
    } else {
      newSelection.add(branchId);
    }
    return UpdateBranchesSelection(branchIds: newSelection);
  }

  factory UpdateBranchesSelection.all(List<BranchModel> branches) {
    return UpdateBranchesSelection(
      branchIds: branches.map((e) => e.id).toSet(),
    );
  }

  factory UpdateBranchesSelection.single(int branchId) {
    return UpdateBranchesSelection(branchIds: {branchId});
  }

  factory UpdateBranchesSelection.clear() {
    return const UpdateBranchesSelection(branchIds: {});
  }

  @override
  List<Object?> get props => [branchIds];
}