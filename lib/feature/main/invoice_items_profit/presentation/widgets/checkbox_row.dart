import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/theme/app_text_theme.dart';



class CheckboxRow extends StatelessWidget {
  const CheckboxRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.isHighlighted = false,
    this.showBottomBorder = true,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isHighlighted;
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
            bottom: BorderSide(
              color: AppColors.grey,
            ),
          )
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextTheme.body2Bold.copyWith(

                color: isHighlighted
                    ? AppColors.mainAppColor
                    : AppColors.black,
              ),
            ),
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: value
                    ? AppColors.mainAppColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(
                  color: value
                      ? AppColors.mainAppColor
                      : AppColors.secondaryAppColor,
                  width: 2,
                ),
              ),
              child: value
                  ? Icon(Icons.check, size: 12.sp, color: AppColors.whiteColor)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

