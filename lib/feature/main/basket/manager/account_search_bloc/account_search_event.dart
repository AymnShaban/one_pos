part of '../../basket_imports.dart';

abstract class AccountSearchEvent extends Equatable {
  const AccountSearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchAccounts extends AccountSearchEvent {
  final String query;

  const SearchAccounts(this.query);

  @override
  List<Object?> get props => [query];
}
