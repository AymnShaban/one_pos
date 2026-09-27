import '../../../item_movement_balance_import.dart';
class MaterialGroupMotionReportSourceState extends Equatable {
  final Status status;
  final List<MaterialGroupMotionReportSourceModel> items;
  final Set<int> selectedItems;
  final int? selectedItem;
  final String? errorMessage;

  const MaterialGroupMotionReportSourceState({
    this.status = Status.initial,
    this.items = const [],
    this.selectedItems = const {},
    this.selectedItem,
    this.errorMessage,
  });

  bool get hasItems => items.isNotEmpty;

  MaterialGroupMotionReportSourceModel?
  get selectedReportSource {
    if (selectedItem == null) return null;

    try {
      return items.firstWhere(
            (item) => item.frmNum == selectedItem,
      );
    } catch (e) {
      return null;
    }
  }

  MaterialGroupMotionReportSourceState copyWith({
    Status? status,
    List<MaterialGroupMotionReportSourceModel>? items,
    Set<int>? selectedItems,
    int? selectedItem,
    String? errorMessage,
    bool clearSelected = false,
  }) {
    return MaterialGroupMotionReportSourceState(
      status: status ?? this.status,
      items: items ?? this.items,
      selectedItems: selectedItems ?? this.selectedItems,
      selectedItem: clearSelected
          ? null
          : (selectedItem ?? this.selectedItem),
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    selectedItems,
    selectedItem,
    errorMessage,
  ];
}