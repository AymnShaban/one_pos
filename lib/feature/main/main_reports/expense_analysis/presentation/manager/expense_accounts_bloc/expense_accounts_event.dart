import '../../../expense_analysis_imports.dart';

abstract class ExpenseAccountsEvent extends Equatable {
  const ExpenseAccountsEvent();

  @override
  List<Object?> get props => [];
}

class LoadExpenseAccounts extends ExpenseAccountsEvent {
  final String? search;

  const LoadExpenseAccounts({this.search});

  @override
  List<Object?> get props => [search];
}

class SelectExpenseAccount extends ExpenseAccountsEvent {
  final int accountId;

  const SelectExpenseAccount({required this.accountId});

  @override
  List<Object?> get props => [accountId];
}

class ClearExpenseAccounts extends ExpenseAccountsEvent {}