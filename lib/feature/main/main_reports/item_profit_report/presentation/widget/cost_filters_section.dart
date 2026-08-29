import 'package:easy_localization/easy_localization.dart';

import '../../../invoices_profit/invoice_profit_imports.dart';

class CostFiltersSectionWidget extends StatelessWidget {
  final bool costZero;
  final bool costEqualsSale;
  final bool costGreaterThanSale;
  final Function(bool) onCostZeroChanged;
  final Function(bool) onCostEqualsSaleChanged;
  final Function(bool) onCostGreaterThanSaleChanged;
  final bool isLoading;

  const CostFiltersSectionWidget({
    required this.costZero,
    required this.costEqualsSale,
    required this.costGreaterThanSale,
    required this.onCostZeroChanged,
    required this.onCostEqualsSaleChanged,
    required this.onCostGreaterThanSaleChanged,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterSectionLabel(title: "cost_filters".tr()),
        SizedBox(height: 8.h),
        ToggleCard(options: [
          ToggleOption(
            title: "filter_cost_zero".tr(),
            value: costZero,
            onChanged: (v) {
              if (isLoading) return;
              onCostZeroChanged(v);
            },
          ),
          ToggleOption(
            title: "filter_cost_equals_sale".tr(),
            value: costEqualsSale,
            onChanged: (v) {
              if (isLoading) return;
              onCostEqualsSaleChanged(v);
            },
          ),
          ToggleOption(
            title: "filter_cost_bigger_sale".tr(),
            value: costGreaterThanSale,
            onChanged: (v) {
              if (isLoading) return;
              onCostGreaterThanSaleChanged(v);
            },
          ),
        ]),
      ],
    );
  }
}


