part of '../live_sales_report_imports.dart';

/// Body for `POST /api/SalMov1Reports`. The five `chk_*` flags map 1:1 to
/// the checkboxes on the live-sales screen. `selectedDelegateDtos` is
/// omitted from the encoded JSON when empty — per the server contract.
class SalesMovementsReportRequest extends Equatable {
  final DateTime fromDate;
  final DateTime toDate;
  final List<int> branchIds;
  final List<int> delegateIds;
  final bool allBranchesChecked;
  final bool allSalesManChecked;
  final bool showSalesManChecked;
  final bool weightChecked;
  final bool showByBranchCurrencyChecked;
  final String cultureName;

  const SalesMovementsReportRequest({
    required this.fromDate,
    required this.toDate,
    required this.branchIds,
    this.delegateIds = const [],
    this.allBranchesChecked = true,
    this.allSalesManChecked = true,
    this.showSalesManChecked = true,
    this.weightChecked = true,
    this.showByBranchCurrencyChecked = true,
    this.cultureName = 'ar',
  });

  Map<String, dynamic> toJson() {
    String fmt(DateTime d) =>
        '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';

    return {
      'fromDate': fmt(fromDate),
      'toDate': fmt(toDate),
      'selectedCompanyBranchDtos':
          branchIds.map((id) => id.toString()).toList(),
      // Omit the delegate list entirely when none are selected — the
      // server treats "no key" and "empty list" differently in some
      // deployments, and the user spec said *if not, don't add it*.
      if (delegateIds.isNotEmpty)
        'selectedDelegateDtos':
            delegateIds.map((id) => id.toString()).toList(),
      'chk_AllBranchesChecked': allBranchesChecked,
      'chk_AllSalesManChecked': allSalesManChecked,
      'chk_ShowSalesManChecked': showSalesManChecked,
      'chk_weightChecked': weightChecked,
      'chk_ShowByBranchCurrencyChecked': showByBranchCurrencyChecked,
      'cultureName': cultureName,
    };
  }

  @override
  List<Object?> get props => [
        fromDate,
        toDate,
        branchIds,
        delegateIds,
        allBranchesChecked,
        allSalesManChecked,
        showSalesManChecked,
        weightChecked,
        showByBranchCurrencyChecked,
        cultureName,
      ];
}
