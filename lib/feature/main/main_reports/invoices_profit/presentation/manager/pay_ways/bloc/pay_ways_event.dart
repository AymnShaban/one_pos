import '../../../../invoice_profit_imports.dart';

abstract class PayWaysEvent extends Equatable {
  const PayWaysEvent();

  @override
  List<Object?> get props => [];
}

class LoadPayWays extends PayWaysEvent {}

class SelectPayWay extends PayWaysEvent {
  final int payWayId;

  const SelectPayWay({required this.payWayId});

  @override
  List<Object?> get props => [payWayId];
}