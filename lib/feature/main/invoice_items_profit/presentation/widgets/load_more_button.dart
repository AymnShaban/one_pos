import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/theme/app_text_theme.dart';

class LoadMoreButton extends StatelessWidget {
  const LoadMoreButton({
    super.key,
    required this.remainingCount,
    required this.onTap,
  });

  final int remainingCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,                   // ← ProfitInquiryColors.card
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF14283C).withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.refresh,
              size: 14.sp,
              color: AppColors.mainAppColor,             // ← ProfitInquiryColors.primary
            ),
            SizedBox(width: 8.w),
            Text(
              'عرض المزيد من الأصناف ($remainingCount)',
              style: AppTextTheme.captionBold.copyWith(  // 12sp bold ≈ 12.5sp w700
                color: AppColors.mainAppColor,           // ← ProfitInquiryColors.primary
              ),
            ),
          ],
        ),
      ),
    );
  }
}

