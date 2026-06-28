part of '../../live_sales_report_imports.dart';

abstract class LiveSalesReportEvent extends Equatable {
  const LiveSalesReportEvent();

  @override
  List<Object?> get props => [];
}

/// Dispatched when the user taps the "معاينة / Preview" button. Carries
/// the full filter snapshot — the bloc forwards it verbatim to the
/// data source.
class LoadLiveSalesReport extends LiveSalesReportEvent {
  final DateTime fromDate;
  final DateTime toDate;
  final List<int> branchIds;
  final List<int> delegateIds;
  final bool allBranchesChecked;
  final bool showSalesManChecked;
  final bool weightChecked;
  final bool showByBranchCurrencyChecked;
  final String cultureName;

  const LoadLiveSalesReport({
    required this.fromDate,
    required this.toDate,
    required this.branchIds,
    this.delegateIds = const [],
    this.allBranchesChecked = true,
    this.showSalesManChecked = true,
    this.weightChecked = true,
    this.showByBranchCurrencyChecked = true,
    this.cultureName = 'ar',
  });

  @override
  List<Object?> get props => [
        fromDate,
        toDate,
        branchIds,
        delegateIds,
        allBranchesChecked,
        showSalesManChecked,
        weightChecked,
        showByBranchCurrencyChecked,
        cultureName,
      ];
}
