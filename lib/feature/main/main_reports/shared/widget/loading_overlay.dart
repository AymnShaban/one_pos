import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/helper/helper.dart';



class ReportsLoadingOverlay extends StatelessWidget {
  const ReportsLoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          width: 180.w,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 52.w,
                height: 52.h,
                child: CircularProgressIndicator(
                  strokeWidth: 3.5,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.brand),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'loading_report'.tr(),
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'please_wait'.tr(),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textMuted,
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDot(0),
                  _buildDot(1),
                  _buildDot(2),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      width: 6.w,
      height: 6.w,
      decoration: BoxDecoration(
        color: AppColors.brand.withOpacity(0.3 + (index * 0.2)),
        shape: BoxShape.circle,
      ),
    );
  }
}
