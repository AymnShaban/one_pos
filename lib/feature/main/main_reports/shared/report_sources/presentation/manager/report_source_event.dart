import '../../../shared_imports.dart';abstract class ReportSourceEvent extends Equatable {
  const ReportSourceEvent();

  @override
  List<Object?> get props => [];
}

class LoadReportSources extends ReportSourceEvent {}

class SelectReportSource extends ReportSourceEvent {
  final int frmNum;

  const SelectReportSource({required this.frmNum});

  @override
  List<Object?> get props => [frmNum];
}