import '../../../../data/models/bill_source_model.dart';
import '../../../../invoice_profit_imports.dart';

class BillSourcesState extends Equatable {
  final Status status;
  final List<BillSourceModel> billSources;
  final int? selectedBillSourceId;
  final String? errorMessage;
  final bool isAllSelected; // <--- جديد

  const BillSourcesState({
    this.status = Status.initial,
    this.billSources = const [],
    this.selectedBillSourceId,
    this.errorMessage,
    this.isAllSelected = true, // افتراضيًا الكل مختار
  });

  BillSourceModel? get selectedBillSource {
    if (selectedBillSourceId == null) return null;
    try {
      return billSources.firstWhere(
            (source) => source.code == selectedBillSourceId,
      );
    } catch (e) {
      return null;
    }
  }

  BillSourcesState copyWith({
    Status? status,
    List<BillSourceModel>? billSources,
    int? selectedBillSourceId,
    String? errorMessage,
    bool? isAllSelected,
    bool clearSelected = false,
  }) {
    return BillSourcesState(
      status: status ?? this.status,
      billSources: billSources ?? this.billSources,
      selectedBillSourceId: clearSelected
          ? null
          : (selectedBillSourceId ?? this.selectedBillSourceId),
      errorMessage: errorMessage ?? this.errorMessage,
      isAllSelected: isAllSelected ?? this.isAllSelected,
    );
  }

  @override
  List<Object?> get props => [
    status,
    billSources,
    selectedBillSourceId,
    errorMessage,
    isAllSelected,
  ];
}