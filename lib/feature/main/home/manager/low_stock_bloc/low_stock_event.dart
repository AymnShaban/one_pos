part of '../../home_imports.dart';

abstract class LowStockEvent extends Equatable {
  const LowStockEvent();

  @override
  List<Object?> get props => [];
}

class LoadLowStockItems extends LowStockEvent {
  final int top;

  const LoadLowStockItems({this.top = 5});

  @override
  List<Object?> get props => [top];
}

class RefreshLowStockItems extends LowStockEvent {
  final int top;

  const RefreshLowStockItems({this.top =5});

  @override
  List<Object?> get props => [top];
}