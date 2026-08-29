import '../../../customer_account_imports.dart';

abstract class MainAccountEvent extends Equatable {
  const MainAccountEvent();

  @override
  List<Object?> get props => [];
}

class LoadMainAccounts extends MainAccountEvent {
  const LoadMainAccounts();
}