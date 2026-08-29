
import 'package:easy_localization/easy_localization.dart';

import '../../../invoices_profit/invoice_profit_imports.dart';

class PeriodSectionWidget extends StatelessWidget {
  final DateTime fromDate;
  final DateTime toDate;
  final Function(DateTime) onFromDateChanged;
  final Function(DateTime) onToDateChanged;

  const PeriodSectionWidget({super.key,
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
        FilterSectionLabel(title: "period".tr()),
        SizedBox(height: 8.h),
        Row(
          children: [
            DateFieldTile(
              label: "from_date".tr(),
              value: fromDate,
              onChanged: onFromDateChanged,
            ),
            SizedBox(width: 10.w),
            DateFieldTile(
              label: "to_date".tr(),
              value: toDate,
              onChanged: onToDateChanged,
            ),
          ],
        ),
      ],
    );
  }
}