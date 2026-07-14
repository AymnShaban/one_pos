import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_date_field.dart';


class AppDateRangePicker extends StatelessWidget {
  const AppDateRangePicker({
    super.key,
    required this.fromDate,
    required this.toDate,
    required this.onFromDateChanged,
    required this.onToDateChanged,
  });

  final DateTime fromDate;
  final DateTime toDate;

  final ValueChanged<DateTime> onFromDateChanged;
  final ValueChanged<DateTime> onToDateChanged;


  Future<void> _pickDate(
      BuildContext context,
      DateTime initial,
      ValueChanged<DateTime> onPicked,
      ) async {

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      onPicked(picked);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Expanded(
          child: AppDateField(
            label: 'from_date',
            date: fromDate,
            onTap: () => _pickDate(
              context,
              fromDate,
              onFromDateChanged,
            ),
          ),
        ),

        SizedBox(width: 10.w),


        Expanded(
          child: AppDateField(
            label: 'to_date',
            date: toDate,
            onTap: () => _pickDate(
              context,
              toDate,
              onToDateChanged,
            ),
          ),
        ),

      ],
    );
  }
}