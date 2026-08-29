import '../../../receipts_and_payments_movement_report_import.dart';
class ReceivedFromState extends Equatable {
  final Status status;
  final List<ReceivedFromModel> items;
  final Set<String> selectedItems;
  final String? selectedItem;
  final String? errorMessage;

  const ReceivedFromState({
    this.status = Status.initial,
    this.items = const [],
    this.selectedItems = const {},
    this.selectedItem,
    this.errorMessage,
  });

  bool get hasItems => items.isNotEmpty;

  ReceivedFromModel? get selectedReceivedFrom {
    if (selectedItem == null) return null;

    try {
      return items.firstWhere(
            (item) => item.name == selectedItem,
      );
    } catch (_) {
      return null;
    }
  }

  ReceivedFromState copyWith({
    Status? status,
    List<ReceivedFromModel>? items,
    Set<String>? selectedItems,
    String? selectedItem,
    String? errorMessage,
    bool clearSelected = false,
  }) {
    return ReceivedFromState(
      status: status ?? this.status,
      items: items ?? this.items,
      selectedItems: selectedItems ?? this.selectedItems,
      selectedItem: clearSelected ? null : (selectedItem ?? this.selectedItem),
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