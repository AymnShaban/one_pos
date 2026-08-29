import '../../item_movement_balance_import.dart';
abstract class ItemMovementBalanceEvent extends Equatable {
  const ItemMovementBalanceEvent();

  @override
  List<Object?> get props => [];
}

class LoadItemMovementBalanceReport extends ItemMovementBalanceEvent {
  final ItemMovementBalanceRequestModel request;

  const LoadItemMovementBalanceReport({required this.request});

  @override
  List<Object?> get props => [request];
}

class ClearItemMovementBalanceReport extends ItemMovementBalanceEvent {
  const ClearItemMovementBalanceReport();
}