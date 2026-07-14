import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/theme/app_text_theme.dart';

class RadioFilterRow extends StatelessWidget {
  const RadioFilterRow({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 2.w),
        child: Row(
          children: [
            Container(
              width: 19.w,
              height: 19.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? AppColors.mainAppColor         // ← ProfitInquiryColors.primary
                      : AppColors.secondaryAppColor,   // ← ProfitInquiryColors.checkboxBorder
                  width: 2,
                ),
              ),
              child: selected
                  ? Center(
                child: Container(
                  width: 9.w,
                  height: 9.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.mainAppColor, // ← ProfitInquiryColors.primary
                  ),
                ),
              )
                  : null,
            ),
            SizedBox(width: 10.w),
            Text(
              label,
              style: AppTextTheme.body2Bold.copyWith(   // 14sp bold ≈ 13sp w600
                color: AppColors.black,                 // ← ProfitInquiryColors.text
              ),
            ),
          ],
        ),
      ),
    );
  }
}

