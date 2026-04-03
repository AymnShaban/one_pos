part of '../../reports_imports.dart';

abstract class ReportsEvent extends Equatable {
  const ReportsEvent();

  @override
  List<Object?> get props => [];
}

class FetchReport extends ReportsEvent {
  const FetchReport();
}

class ChangeReportType extends ReportsEvent {
  final ReportType type;
  const ChangeReportType(this.type);

  @override
  List<Object?> get props => [type];
}

class ChangeReportPeriod extends ReportsEvent {
  final ReportPeriod period;
  const ChangeReportPeriod(this.period);

  @override
  List<Object?> get props => [period];
}

class ExportReportPdf extends ReportsEvent {
  const ExportReportPdf();
}