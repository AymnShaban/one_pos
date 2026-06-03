import 'package:easy_localization/easy_localization.dart';
import 'package:one_pos/core/helper/helper.dart';

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
              side: const BorderSide(color: Color(0xFFE57373), width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'clear_invoice'.tr(),
              style: AppTextTheme.body1,
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
                    style: AppTextTheme.body1,
                  ),
          ),
        ),
      ],
    );
  }
}
