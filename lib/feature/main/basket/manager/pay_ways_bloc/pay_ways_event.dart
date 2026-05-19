part of '../../basket_imports.dart';

abstract class PayWaysEvent extends Equatable {
  const PayWaysEvent();

  @override
  List<Object?> get props => [];
}

class FetchPayWays extends PayWaysEvent {
  const FetchPayWays();
}
