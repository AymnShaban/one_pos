import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Action buttons for export and clear invoice
class ActionButtons extends StatelessWidget {
  final VoidCallback onExportPressed;
  final VoidCallback onClearPressed;
  final bool isLoading;

  const ActionButtons({
    super.key,
    required this.onExportPressed,
    required this.onClearPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Clear invoice button (outlined red)
        Expanded(
          child: OutlinedButton(
            onPressed: isLoading ? null : onClearPressed,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 18.h),
              side: const BorderSide(
                color: Color(0xFFE57373),
                width: 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'clear_invoice'.tr(),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFE57373),
              ),
            ),
          ),
        ),
        
        SizedBox(width: 16.w),
        
        // Export Excel button (yellow)
        Expanded(
          child: ElevatedButton(
            onPressed: isLoading ? null : onExportPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE8D952),
              padding: EdgeInsets.symmetric(vertical: 18.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 0,
            ),
            child: isLoading
                ? SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
                    ),
                  )
                : Text(
                    'export_excel'.tr(),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
