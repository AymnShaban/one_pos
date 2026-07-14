import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../constant/app_colors.dart';
import '../../theme/app_text_theme.dart';


class AppDateField extends StatelessWidget {
  const AppDateField({
    super.key,
    required this.label,
    required this.date,
    required this.onTap,
  });

  final String label;
  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextTheme.labelMedium11Bold.copyWith(
            color: AppColors.grey,
          ),
        ),

        SizedBox(height: 6.h),

        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.r),

          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 10.h,
            ),

            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              border: Border.all(
                color: AppColors.grey,
              ),
              borderRadius: BorderRadius.circular(10.r),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text(
                  DateFormat('MM/dd/yyyy').format(date),
                  style: AppTextTheme.body2Bold.copyWith(
                    color: AppColors.black,
                  ),
                ),

                Icon(
                  Icons.calendar_today,
                  size: 13.sp,
                  color: AppColors.mainAppColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}