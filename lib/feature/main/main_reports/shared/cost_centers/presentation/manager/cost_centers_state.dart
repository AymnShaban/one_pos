
import '../../../shared_imports.dart';
class CostCentersState extends Equatable {
  final Status status;
  final List<CostCenterModel> costCenters;
  final Set<int> selectedCostCenterIds;
  final int? selectedCostCenterId;
  final String? errorMessage;

  const CostCentersState({
    this.status = Status.initial,
    this.costCenters = const [],
    this.selectedCostCenterIds = const {},
    this.selectedCostCenterId,
    this.errorMessage,
  });

  bool get hasCostCenters => costCenters.isNotEmpty;

  CostCenterModel? get selectedCostCenter {
    if (selectedCostCenterId == null) return null;
    try {
      return costCenters.firstWhere(
            (center) => center.coID == selectedCostCenterId,
      );
    } catch (e) {
      return null;
    }
  }

  CostCentersState copyWith({
    Status? status,
    List<CostCenterModel>? costCenters,
    Set<int>? selectedCostCenterIds,
    int? selectedCostCenterId,
    String? errorMessage,
    bool clearSelected = false,
  }) {
    return CostCentersState(
      status: status ?? this.status,
      costCenters: costCenters ?? this.costCenters,
      selectedCostCenterIds: selectedCostCenterIds ?? this.selectedCostCenterIds,
      selectedCostCenterId: clearSelected
          ? null
          : (selectedCostCenterId ?? this.selectedCostCenterId),
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    costCenters,
    selectedCostCenterIds,
    selectedCostCenterId,
    errorMessage,
  ];
}