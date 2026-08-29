import '../../../../invoice_profit_imports.dart';
abstract class ParentAccountsEvent extends Equatable {
  const ParentAccountsEvent();

  @override
  List<Object?> get props => [];
}

class LoadParentAccounts extends ParentAccountsEvent {}

class SelectParentAccount extends ParentAccountsEvent {
  final int parentAccountId;

  const SelectParentAccount({required this.parentAccountId});

  @override
  List<Object?> get props => [parentAccountId];
}