import '../../../branch_profit_import.dart';

abstract class BranchProfitEvent extends Equatable {
  const BranchProfitEvent();

  @override
  List<Object?> get props => [];
}

class LoadBranchProfitReport extends BranchProfitEvent {
  final BranchProfitRequestModel request;

  const LoadBranchProfitReport({required this.request});

  @override
  List<Object?> get props => [request];
}

class ClearBranchProfitReport extends BranchProfitEvent {}