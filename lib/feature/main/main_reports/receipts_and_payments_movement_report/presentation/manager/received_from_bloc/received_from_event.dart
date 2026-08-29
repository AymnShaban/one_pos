import '../../../receipts_and_payments_movement_report_import.dart';
abstract class ReceivedFromEvent extends Equatable {
  const ReceivedFromEvent();

  @override
  List<Object?> get props => [];
}

class LoadReceivedFrom extends ReceivedFromEvent {
  final String? search;

  const LoadReceivedFrom({this.search});

  @override
  List<Object?> get props => [search];
}

class SelectReceivedFrom extends ReceivedFromEvent {
  final String name;

  const SelectReceivedFrom({
    required this.name,
  });

  @override
  List<Object?> get props => [name];
}