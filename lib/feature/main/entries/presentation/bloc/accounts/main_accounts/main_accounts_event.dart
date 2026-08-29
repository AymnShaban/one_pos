import '../accounts_event.dart';

class LoadMainAccounts extends AccountsEvent {}

class LoadMainAccountBalance extends AccountsEvent {
  final int acId;

  const LoadMainAccountBalance({required this.acId});

  @override
  List<Object?> get props => [acId];
}

class ClearMainAccounts extends AccountsEvent {}