import '../../../../invoice_profit_imports.dart';


abstract class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object?> get props => [];
}

class LoadUsers extends UsersEvent {}

class SelectUser extends UsersEvent {
  final String userName;

  const SelectUser({required this.userName});

  @override
  List<Object?> get props => [userName];
}