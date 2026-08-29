import '../../../items_movement_import.dart';
class MTIReportSourceState extends Equatable {
  final Status status;
  final List<MTIReportSourceModel> items;
  final Set<String> selectedItems;
  final String? selectedItem;
  final String? errorMessage;

  const MTIReportSourceState({
    this.status = Status.initial,
    this.items = const [],
    this.selectedItems = const {},
    this.selectedItem,
    this.errorMessage,
  });

  bool get hasItems => items.isNotEmpty;

  MTIReportSourceModel? get selectedReportSource {
    if (selectedItem == null) return null;

    try {
      return items.firstWhere(
            (item) => item.name == selectedItem,
      );
    } catch (_) {
      return null;
    }
  }

  MTIReportSourceState copyWith({
    Status? status,
    List<MTIReportSourceModel>? items,
    Set<String>? selectedItems,
    String? selectedItem,
    String? errorMessage,
    bool clearSelected = false,
  }) {
    return MTIReportSourceState(
      status: status ?? this.status,
      items: items ?? this.items,
      selectedItems: selectedItems ?? this.selectedItems,
      selectedItem: clearSelected
          ? null
          : (selectedItem ?? this.selectedItem),
      errorMessage: errorMessage,
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