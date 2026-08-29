import '../../../revenue_analysis_import.dart';

abstract class RevenueReportEvent extends Equatable {
  const RevenueReportEvent();

  @override
  List<Object?> get props => [];
}

class LoadRevenueReport extends RevenueReportEvent {
  final RevenueReportRequestModel request;

  const LoadRevenueReport({required this.request});

  @override
  List<Object?> get props => [request];
}

class ClearRevenueReport extends RevenueReportEvent {}