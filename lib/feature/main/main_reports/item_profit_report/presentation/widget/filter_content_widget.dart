import 'package:one_pos/feature/main/main_reports/item_profit_report/presentation/widget/period_section.dart';
import 'package:one_pos/feature/main/main_reports/item_profit_report/presentation/widget/price_types_section.dart';

import '../../../invoices_profit/invoice_profit_imports.dart';
import '../../data/models/price_type_model.dart';
import 'branches_section.dart';
import 'cost_filters_section.dart';
import 'display_options_section.dart';

class FilterContentWidget extends StatelessWidget {
  final DateTime fromDate;
  final DateTime toDate;
  final Function(DateTime) onFromDateChanged;
  final Function(DateTime) onToDateChanged;
  final bool costZero;
  final bool costEqualsSale;
  final bool costGreaterThanSale;
  final bool showReturns;
  final bool hideClient;
  final bool clientBranch;
  final Function(bool) onCostZeroChanged;
  final Function(bool) onCostEqualsSaleChanged;
  final Function(bool) onCostGreaterThanSaleChanged;
  final Function(bool) onShowReturnsChanged;
  final Function(bool) onHideClientChanged;
  final Function(bool) onClientBranchChanged;
  final PriceTypeModel salePrice;
  final PriceTypeModel costPrice;
  final Function(PriceTypeModel) onSalePriceChanged;
  final Function(PriceTypeModel) onCostPriceChanged;
  final bool isLoading;

  const FilterContentWidget({
    required this.fromDate,
    required this.toDate,
    required this.onFromDateChanged,
    required this.onToDateChanged,
    required this.costZero,
    required this.costEqualsSale,
    required this.costGreaterThanSale,
    required this.showReturns,
    required this.hideClient,
    required this.clientBranch,
    required this.onCostZeroChanged,
    required this.onCostEqualsSaleChanged,
    required this.onCostGreaterThanSaleChanged,
    required this.onShowReturnsChanged,
    required this.onHideClientChanged,
    required this.onClientBranchChanged,
    required this.salePrice,
    required this.costPrice,
    required this.onSalePriceChanged,
    required this.onCostPriceChanged,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 10.h),
      children: [
        PeriodSectionWidget(
          fromDate: fromDate,
          toDate: toDate,
          onFromDateChanged: onFromDateChanged,
          onToDateChanged: onToDateChanged,
        ),
        SizedBox(height: 12.h),
        PriceTypesSectionWidget(
          salePrice: salePrice,
          costPrice: costPrice,
          onSalePriceChanged: onSalePriceChanged,
          onCostPriceChanged: onCostPriceChanged,
          isLoading: isLoading,
        ),
        BranchesSectionWidget(isLoading: isLoading),
        SizedBox(height: 12.h),
        DisplayOptionsSectionWidget(
          showReturns: showReturns,
          hideClient: hideClient,
          clientBranch: clientBranch,
          onShowReturnsChanged: onShowReturnsChanged,
          onHideClientChanged: onHideClientChanged,
          onClientBranchChanged: onClientBranchChanged,
          isLoading: isLoading,
        ),
        SizedBox(height: 12.h),
        CostFiltersSectionWidget(
          costZero: costZero,
          costEqualsSale: costEqualsSale,
          costGreaterThanSale: costGreaterThanSale,
          onCostZeroChanged: onCostZeroChanged,
          onCostEqualsSaleChanged: onCostEqualsSaleChanged,
          onCostGreaterThanSaleChanged: onCostGreaterThanSaleChanged,
          isLoading: isLoading,
        ),
      ],
    );
  }
}