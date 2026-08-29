import 'package:easy_localization/easy_localization.dart';

import '../../../invoices_profit/invoice_profit_imports.dart';

class BottomBarWidget extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onReset;
  final VoidCallback onApply;

  const BottomBarWidget({
    required this.isLoading,
    required this.onReset,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Reset Button (Secondary)
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: isLoading ? null : onReset,
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.slateBg,
                  foregroundColor: AppColors.textDark,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: BorderSide(color: AppColors.line, width: 1.5),
                  ),
                  disabledBackgroundColor: AppColors.slateBg.withOpacity(0.4),
                  disabledForegroundColor: AppColors.textMuted.withOpacity(0.5),
                ),
                child: Text(
                  "reset".tr(),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Show Report Button (Primary)
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: isLoading ? null : onApply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brand,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  disabledBackgroundColor: AppColors.brand.withOpacity(0.4),
                ),
                child: isLoading
                    ? SizedBox(
                  width: 22.w,
                  height: 22.h,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long,
                      size: 18.sp,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "show_report".tr(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
