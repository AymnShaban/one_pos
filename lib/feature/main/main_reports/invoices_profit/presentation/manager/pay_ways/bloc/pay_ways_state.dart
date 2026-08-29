
import '../../../../invoice_profit_imports.dart';

class PayWaysState extends Equatable {
  final Status status;
  final List<PayWayModel> payWays;
  final Set<int> selectedPayWayIds;
  final int? selectedPayWayId;
  final String? errorMessage;

  const PayWaysState({
    this.status = Status.initial,
    this.payWays = const [],
    this.selectedPayWayIds = const {},
    this.selectedPayWayId,
    this.errorMessage,
  });

  bool get hasPayWays => payWays.isNotEmpty;

  PayWayModel? get selectedPayWay {
    if (selectedPayWayId == null) return null;
    try {
      return payWays.firstWhere(
            (payWay) => payWay.pwid == selectedPayWayId,
      );
    } catch (e) {
      return null;
    }
  }

  PayWaysState copyWith({
    Status? status,
    List<PayWayModel>? payWays,
    Set<int>? selectedPayWayIds,
    int? selectedPayWayId,
    String? errorMessage,
    bool clearSelected = false,
  }) {
    return PayWaysState(
      status: status ?? this.status,
      payWays: payWays ?? this.payWays,
      selectedPayWayIds: selectedPayWayIds ?? this.selectedPayWayIds,
      selectedPayWayId: clearSelected
          ? null
          : (selectedPayWayId ?? this.selectedPayWayId),
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    payWays,
    selectedPayWayIds,
    selectedPayWayId,
    errorMessage,
  ];
}