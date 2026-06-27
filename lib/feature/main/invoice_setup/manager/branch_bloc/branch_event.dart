part of '../../invoice_setup_imports.dart';

abstract class BranchEvent extends Equatable {
  const BranchEvent();

  @override
  List<Object?> get props => [];
}

/// Fire from a consuming screen's `initState`. Idempotent — the bloc
/// short-circuits if it's already mid-load or already has items.
class LoadBranches extends BranchEvent {
  const LoadBranches();
}

class SelectBranchById extends BranchEvent {
  final int branchId;
  const SelectBranchById(this.branchId);

  @override
  List<Object?> get props => [branchId];
}
