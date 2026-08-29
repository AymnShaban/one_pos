import 'package:easy_localization/easy_localization.dart';

import '../../revenue_analysis_import.dart';
class DisplayOptionsSection extends StatelessWidget {
  final bool showColumnValues;
  final bool detailedCostCenters;
  final bool detailedComparison;
  final ValueChanged<bool> onShowColumnValuesChanged;
  final ValueChanged<bool> onDetailedCostCentersChanged;
  final ValueChanged<bool> onDetailedComparisonChanged;

  const DisplayOptionsSection({
    super.key,
    required this.showColumnValues,
    required this.detailedCostCenters,
    required this.detailedComparison,
    required this.onShowColumnValuesChanged,
    required this.onDetailedCostCentersChanged,
    required this.onDetailedComparisonChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterSectionLabel(title: "display_options".tr()),
        ToggleCard(
          options: [
            ToggleOption(
              title: "show_column_values".tr(),
              subtitle: "show_column_values_sub".tr(),
              value: showColumnValues,
              onChanged: onShowColumnValuesChanged,
            ),
            ToggleOption(
              title: "detailed_cost_centers".tr(),
              subtitle: "detailed_cost_centers_sub".tr(),
              value: detailedCostCenters,
              onChanged: onDetailedCostCentersChanged,
            ),
            ToggleOption(
              title: "detailed_comparison".tr(),
              subtitle: "detailed_comparison_sub".tr(),
              value: detailedComparison,
              onChanged: onDetailedComparisonChanged,
            ),
          ],
        ),
      ],
    );
  }
}
