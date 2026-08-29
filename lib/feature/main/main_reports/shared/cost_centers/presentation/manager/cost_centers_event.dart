import '../../../shared_imports.dart';
abstract class CostCentersEvent extends Equatable {
  const CostCentersEvent();

  @override
  List<Object?> get props => [];
}

class LoadCostCenters extends CostCentersEvent {}

class SelectCostCenter extends CostCentersEvent {
  final int costCenterId;

  const SelectCostCenter({required this.costCenterId});

  @override
  List<Object?> get props => [costCenterId];
}