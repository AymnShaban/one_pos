import '../../item_profit_import.dart';
abstract class ItemProfitEvent extends Equatable {
  const ItemProfitEvent();

  @override
  List<Object?> get props => [];
}

class LoadItemProfitReport extends ItemProfitEvent {
  final ItemProfitRequestModel request;

  const LoadItemProfitReport({required this.request});

  @override
  List<Object?> get props => [request];
}

class ClearItemProfitReport extends ItemProfitEvent {}