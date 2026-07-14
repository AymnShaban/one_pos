import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/theme/app_text_theme.dart';
class ToggleSwitchRow extends StatelessWidget {
  const ToggleSwitchRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.showBottomBorder = true,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showBottomBorder;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 2.w),
        decoration: BoxDecoration(
          border: showBottomBorder
              ? Border(
            bottom: BorderSide(color: AppColors.grey),  // ← ProfitInquiryColors.line
          )
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextTheme.body2Bold.copyWith(         // 14sp bold ≈ 13.5sp w600
                color: AppColors.black,                       // ← ProfitInquiryColors.text
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 40.w,
              height: 23.h,
              padding: EdgeInsets.all(2.5.r),
              decoration: BoxDecoration(
                color: value
                    ? AppColors.green                         // ← ProfitInquiryColors.success
                    : AppColors.secondaryAppColor,            // ← ProfitInquiryColors.switchOff
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: value ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  width: 18.w,
                  height: 18.w,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

