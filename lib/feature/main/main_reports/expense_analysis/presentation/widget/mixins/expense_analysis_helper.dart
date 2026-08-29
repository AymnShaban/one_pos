import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/constant/app_colors.dart';


mixin ExpenseAnalysisHelper {
  Widget buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Container(
            width: 6.w,
            height: 6.h,
            decoration: const BoxDecoration(color: AppColors.brand, shape: BoxShape.circle),
          ),
          SizedBox(width: 6.w),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12.5.sp,
              color: AppColors.brandDark,
            ),
          ),
        ],
      ),
    );
  }
}