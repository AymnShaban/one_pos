
import '../../../revenue_analysis_import.dart';

class RevenueAccountsState extends Equatable {
  final Status status;
  final List<RevenueAccountModel> accounts;
  final int? selectedAccountId;
  final String? errorMessage;

  const RevenueAccountsState({
    this.status = Status.initial,
    this.accounts = const [],
    this.selectedAccountId,
    this.errorMessage,
  });

  RevenueAccountModel? get selectedAccount {
    if (selectedAccountId == null) return null;
    try {
      return accounts.firstWhere(
            (account) => account.id == selectedAccountId,
      );
    } catch (e) {
      return null;
    }
  }

  RevenueAccountsState copyWith({
    Status? status,
    List<RevenueAccountModel>? accounts,
    int? selectedAccountId,
    String? errorMessage,
    bool clearSelected = false,
  }) {
    return RevenueAccountsState(
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