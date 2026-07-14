import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/theme/app_text_theme.dart';



class ProfitSummaryCard extends StatelessWidget {
  const ProfitSummaryCard({
    super.key,
    required this.itemsCount,
    required this.invoicesCount,
  });

  final int itemsCount;
  final int invoicesCount;

  // ← ProfitInquiryColors.resultCardGradient
  static const _resultCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.mainAppColor, AppColors.tealAccentColor],
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        gradient: _resultCardGradient,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.grid_view_rounded,
                  size: 18.sp,
                  color: AppColors.whiteColor,
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'أرباح الأصناف',
                    style: AppTextTheme.captionBold.copyWith(     // 12sp bold ≈ 12.5sp w600
                      color: AppColors.whiteColor.withValues(alpha: 0.8),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '$itemsCount صنف · $invoicesCount فاتورة',
                    style: AppTextTheme.body1Bold.copyWith(       // 16sp bold ≈ 15.5sp w800
                      fontWeight: FontWeight.w800,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.whiteColor.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '$invoicesCount فاتورة',
              style: AppTextTheme.captionBold.copyWith(           // 12sp bold ≈ 12.5sp w700
                fontWeight: FontWeight.w700,
                color: AppColors.whiteColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

