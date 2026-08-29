import '../../../items_movement_import.dart';
abstract class MTIReportSourceEvent extends Equatable {
  const MTIReportSourceEvent();

  @override
  List<Object?> get props => [];
}

class LoadMTIReportSources extends MTIReportSourceEvent {}

class SelectMTIReportSource extends MTIReportSourceEvent {
  final String name;

  const SelectMTIReportSource({
    required this.name,
  });

  @override
  List<Object?> get props => [name];
}