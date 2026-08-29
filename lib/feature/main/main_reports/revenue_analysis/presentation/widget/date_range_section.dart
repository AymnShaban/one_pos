import 'package:easy_localization/easy_localization.dart';

import '../../revenue_analysis_import.dart';
class DateRangeSection extends StatelessWidget {
  final DateTime fromDate;
  final DateTime toDate;
  final ValueChanged<DateTime> onFromDateChanged;
  final ValueChanged<DateTime> onToDateChanged;

  const DateRangeSection({
    super.key,
    required this.fromDate,
    required this.toDate,
    required this.onFromDateChanged,
    required this.onToDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
