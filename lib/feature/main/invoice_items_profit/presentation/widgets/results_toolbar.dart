import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/theme/app_text_theme.dart';
class ResultsToolbar extends StatelessWidget {
  const ResultsToolbar({super.key, required this.onSort});

  final VoidCallback onSort;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تفاصيل الأصناف',
              style: AppTextTheme.body2Bold.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'مرتبة حسب الأعلى ربحًا',
              style: AppTextTheme.labelMedium11Bold.copyWith(
                color: AppColors.grey,
              ),
            ),
          ],
        ),
        InkWell(
          onTap: onSort,
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,                    // ← ProfitInquiryColors.card
              border: Border.all(color: AppColors.grey),      // ← ProfitInquiryColors.line
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.swap_vert,
                  size: 13.sp,
                  color: AppColors.grey,                      // ← ProfitInquiryColors.textDim
                ),
                SizedBox(width: 6.w),
                Text(
                  'فرز',
                  style: AppTextTheme.labelMedium11Bold.copyWith( // 11sp bold ≈ 11.5sp w700
                    fontWeight: FontWeight.w700,
                    color: AppColors.grey,                    // ← ProfitInquiryColors.textDim
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

