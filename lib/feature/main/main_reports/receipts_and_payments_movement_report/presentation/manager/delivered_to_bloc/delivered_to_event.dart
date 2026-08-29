import '../../../receipts_and_payments_movement_report_import.dart';
abstract class DeliveredToEvent extends Equatable {
  const DeliveredToEvent();

  @override
  List<Object?> get props => [];
}

class LoadDeliveredTo extends DeliveredToEvent {
  final String? search;

  const LoadDeliveredTo({this.search});

  @override
  List<Object?> get props => [search];
}

class SelectDeliveredTo extends DeliveredToEvent {
  final String name;

  const SelectDeliveredTo({required this.name});

  @override
  List<Object?> get props => [name];
}