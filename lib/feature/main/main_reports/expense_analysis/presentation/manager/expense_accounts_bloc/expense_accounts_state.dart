
import '../../../expense_analysis_imports.dart';

class ExpenseAccountsState extends Equatable {
  final Status status;
  final List<ExpenseAccountModel> accounts;
  final int? selectedAccountId;
  final String? errorMessage;

  const ExpenseAccountsState({
    this.status = Status.initial,
    this.accounts = const [],
    this.selectedAccountId,
    this.errorMessage,
  });

  ExpenseAccountModel? get selectedAccount {
    if (selectedAccountId == null) return null;
    try {
      return accounts.firstWhere(
            (account) => account.id == selectedAccountId,
      );
    } catch (e) {
      return null;
    }
  }

  ExpenseAccountsState copyWith({
    Status? status,
    List<ExpenseAccountModel>? accounts,
    int? selectedAccountId,
    String? errorMessage,
    bool clearSelected = false,
  }) {
    return ExpenseAccountsState(
      status: status ?? this.status,
      accounts: accounts ?? this.accounts,
      selectedAccountId: clearSelected
          ? null
          : (selectedAccountId ?? this.selectedAccountId),
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    accounts,
    selectedAccountId,
    errorMessage,
  ];
}