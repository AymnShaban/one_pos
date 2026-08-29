import '../../../../data/models/parent_account_model.dart';
import '../../../../invoice_profit_imports.dart';
class ParentAccountsState extends Equatable {
  final Status status;
  final List<ParentAccountModel> parentAccounts;
  final int? selectedParentAccountId;
  final String? errorMessage;

  const ParentAccountsState({
    this.status = Status.initial,
    this.parentAccounts = const [],
    this.selectedParentAccountId,
    this.errorMessage,
  });

  ParentAccountModel? get selectedParentAccount {
    if (selectedParentAccountId == null) return null;
    try {
      return parentAccounts.firstWhere(
            (account) => account.acID == selectedParentAccountId,
      );
    } catch (e) {
      return null;
    }
  }

  ParentAccountsState copyWith({
    Status? status,
    List<ParentAccountModel>? parentAccounts,
    int? selectedParentAccountId,
    String? errorMessage,
    bool clearSelected = false,
  }) {
    return ParentAccountsState(
      status: status ?? this.status,
      parentAccounts: parentAccounts ?? this.parentAccounts,
      selectedParentAccountId: clearSelected
          ? null
          : (selectedParentAccountId ?? this.selectedParentAccountId),
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    parentAccounts,
    selectedParentAccountId,
    errorMessage,
  ];
}