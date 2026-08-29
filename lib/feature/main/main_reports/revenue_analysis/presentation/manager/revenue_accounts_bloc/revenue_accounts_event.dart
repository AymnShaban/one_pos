import '../../../revenue_analysis_import.dart';

abstract class RevenueAccountsEvent extends Equatable {
  const RevenueAccountsEvent();

  @override
  List<Object?> get props => [];
}

class LoadRevenueAccounts extends RevenueAccountsEvent {
  final String? search;

  const LoadRevenueAccounts({this.search});

  @override
  List<Object?> get props => [search];
}

class SelectRevenueAccount extends RevenueAccountsEvent {
  final int accountId;

  const SelectRevenueAccount({required this.accountId});

  @override
  List<Object?> get props => [accountId];
}

class ClearRevenueAccounts extends RevenueAccountsEvent {}