import '../../../receipts_and_payments_movement_report_import.dart';
class DeliveredToState extends Equatable {
  final Status status;
  final List<DeliveredToModel> items;
  final Set<String> selectedItems;
  final String? selectedItem;
  final String? errorMessage;

  const DeliveredToState({
    this.status = Status.initial,
    this.items = const [],
    this.selectedItems = const {},
    this.selectedItem,
    this.errorMessage,
  });

  bool get hasItems => items.isNotEmpty;

  DeliveredToModel? get selectedDeliveredTo {
    if (selectedItem == null) return null;
    try {
      return items.firstWhere(
            (item) => item.name == selectedItem,
      );
    } catch (e) {
      return null;
    }
  }

  DeliveredToState copyWith({
    Status? status,
    List<DeliveredToModel>? items,
    Set<String>? selectedItems,
    String? selectedItem,
    String? errorMessage,
    bool clearSelected = false,
  }) {
    return DeliveredToState(
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