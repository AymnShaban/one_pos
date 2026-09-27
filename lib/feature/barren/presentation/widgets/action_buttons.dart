import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_pos/core/helper/helper.dart';

/// Action buttons for save, export and clear invoice
class ActionButtons extends StatelessWidget {
  final VoidCallback onSavePressed;
  final VoidCallback onExportPressed;
  final VoidCallback onClearPressed;

  final bool isSaving;
  final bool isExporting;

  const ActionButtons({
    super.key,
    required this.onSavePressed,
    required this.onExportPressed,
    required this.onClearPressed,
    this.isSaving = false,
    this.isExporting = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = isSaving || isExporting;

    return Row(
      children: [
        // Clear
        Expanded(
          child: SizedBox(
            height: 42.h,
            child: OutlinedButton.icon(
              onPressed: isDisabled ? null : onClearPressed,
              icon: Icon(Icons.delete_outline_rounded, size: 19.sp),
              label: Text(
                'clear_invoice'.tr(),
                style: AppTextTheme.body1.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.red,
                backgroundColor: AppColors.card,
                side: BorderSide(
                  color: AppColors.red.withValues(alpha: 0.65),
                  width: 1.2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.w),
              ),
            ),
          ),
        ),

        SizedBox(width: 8.w),

        // Save
        Expanded(
          child: SizedBox(
            height: 42.h,
            child: OutlinedButton.icon(
              onPressed: isDisabled ? null : onSavePressed,
              icon: isSaving
                  ? SizedBox(
                      width: 17.w,
                      height: 17.h,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.brand,
                        ),
                      ),
                    )
                  : Icon(Icons.save_outlined, size: 19.sp),
              label: Text(
                'save'.tr(),
                style: AppTextTheme.body1.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.brand,
                backgroundColor: AppColors.card,
                side: BorderSide(color: AppColors.brand, width: 1.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.w),
              ),
            ),
          ),
        ),

        SizedBox(width: 8.w),

        // Export Excel
        Expanded(
          child: SizedBox(
            height: 42.h,
            child: OutlinedButton.icon(
              onPressed: isDisabled ? null : onExportPressed,
              icon: isExporting
                  ? SizedBox(
                      width: 17.w,
                      height: 17.h,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.greenDark,
                        ),
                      ),
                    )
                  : Icon(Icons.table_view_outlined, size: 19.sp),
              label: Text(
                'export_excel'.tr(),
                style: AppTextTheme.body1.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.greenDark,
                backgroundColor: AppColors.card,
                side: BorderSide(
                  color: AppColors.greenDark.withValues(alpha: 0.65),
                  width: 1.2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.w),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
