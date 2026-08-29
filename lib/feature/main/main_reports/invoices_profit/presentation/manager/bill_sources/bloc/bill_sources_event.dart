import '../../../../invoice_profit_imports.dart';
abstract class BillSourcesEvent extends Equatable {
  const BillSourcesEvent();

  @override
  List<Object?> get props => [];
}

class LoadBillSources extends BillSourcesEvent {}

class SelectBillSource extends BillSourcesEvent {
  final int billSourceId;

  const SelectBillSource({required this.billSourceId});

  @override
  List<Object?> get props => [billSourceId];
}