import '../../../customer_account_imports.dart';
class CustomerAccountReportSourceState extends Equatable {
  final Status status;
  final List<CustomerAccountReportSourceModel> items;
  final Set<int> selectedItems;
  final int? selectedItem;
  final String? errorMessage;

  const CustomerAccountReportSourceState({
    this.status = Status.initial,
    this.items = const [],
    this.selectedItems = const {},
    this.selectedItem,
    this.errorMessage,
  });

  bool get hasItems => items.isNotEmpty;

  CustomerAccountReportSourceModel? get selectedReportSource {
    if (selectedItem == null) return null;

    try {
      return items.firstWhere(
            (item) => item.value == selectedItem,
      );
    } catch (_) {
      return null;
    }
  }

  List<CustomerAccountReportSourceModel>
  get selectedReportSources {
    return items
        .where(
          (item) => selectedItems.contains(item.value),
    )
        .toList();
  }

  CustomerAccountReportSourceState copyWith({
    Status? status,
    List<CustomerAccountReportSourceModel>? items,
    Set<int>? selectedItems,
    int? selectedItem,
    String? errorMessage,
    bool clearSelected = false,
  }) {
    return CustomerAccountReportSourceState(
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