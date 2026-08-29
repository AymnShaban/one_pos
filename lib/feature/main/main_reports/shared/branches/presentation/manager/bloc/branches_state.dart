
import '../../../branches_import.dart';


class BranchesState extends Equatable {
  final Status status;
  final List<BranchModel> branches;
  final Set<int> selectedBranchIds;
  final String? errorMessage;

  const BranchesState({
    this.status = Status.initial,
    this.branches = const [],
    this.selectedBranchIds = const {},
    this.errorMessage,
  });


  List<int> get allBranchIds => branches.map((e) => e.id).toList();


  List<int> get branchIdsToSend => selectedBranchIds.toList();


  bool get isAllSelected {
    if (branches.isEmpty) return false;
    return selectedBranchIds.length == branches.length;
  }


  bool isBranchSelected(int branchId) => selectedBranchIds.contains(branchId);

  BranchModel? get selectedBranch {
    if (selectedBranchIds.length != 1) return null;
    try {
      return branches.firstWhere(
            (branch) => branch.id == selectedBranchIds.first,
      );
    } catch (_) {
      return null;
    }
  }

  BranchesState copyWith({
    Status? status,
    List<BranchModel>? branches,
    Set<int>? selectedBranchIds,
    String? errorMessage,
    bool clearError = false,
  }) {
    return BranchesState(
      status: status ?? this.status,
      branches: branches ?? this.branches,
      selectedBranchIds: selectedBranchIds ?? this.selectedBranchIds,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    branches,
    selectedBranchIds,
    errorMessage,
  ];
}