import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/widgets/filter_widgets.dart';
import '../mixins/expense_analysis_helper.dart';


class DateRangeSection extends StatelessWidget with ExpenseAnalysisHelper {
  final DateTime fromDate;
  final DateTime toDate;
  final Function(DateTime) onFromDateChanged;
  final Function(DateTime) onToDateChanged;

  const DateRangeSection({
    super.key,
    required this.fromDate,
    required this.toDate,
    required this.onFromDateChanged,
    required this.onToDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionHeader("period".tr()),
        Row(
          children: [
            Expanded(
              child: DateFieldTile(
                label: "from_date".tr(),
                value: fromDate,
                onChanged: onFromDateChanged,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: DateFieldTile(
                label: "to_date".tr(),
                value: toDate,
                onChanged: onToDateChanged,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}