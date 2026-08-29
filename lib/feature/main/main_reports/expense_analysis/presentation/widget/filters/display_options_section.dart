import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/widgets/filter_widgets.dart';
import '../mixins/expense_analysis_helper.dart';



class DisplayOptionsSection extends StatelessWidget with ExpenseAnalysisHelper {
  final bool showColumnValues;
  final bool compareToBudget;
  final bool multiDatabase;
  final Function(bool) onShowColumnValuesChanged;
  final Function(bool) onCompareToBudgetChanged;
  final Function(bool) onMultiDatabaseChanged;

  const DisplayOptionsSection({
    super.key,
    required this.showColumnValues,
    required this.compareToBudget,
    required this.multiDatabase,
    required this.onShowColumnValuesChanged,
    required this.onCompareToBudgetChanged,
    required this.onMultiDatabaseChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionHeader("additional_options".tr()),
        ToggleCard(
          options: [
            ToggleOption(
              title: "show_column_values".tr(),
              subtitle: "show_column_values_sub".tr(),
              value: showColumnValues,
              onChanged: onShowColumnValuesChanged,
            ),
            ToggleOption(
              title: "compare_to_budget".tr(),
              subtitle: "compare_to_budget_sub".tr(),
              value: compareToBudget,
              onChanged: onCompareToBudgetChanged,
            ),
            ToggleOption(
              title: "multi_database".tr(),
              subtitle: "multi_database_sub".tr(),
              value: multiDatabase,
              onChanged: onMultiDatabaseChanged,
            ),
          ],
        ),
      ],
    );
  }
}