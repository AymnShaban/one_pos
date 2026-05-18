part of '../../basket_imports.dart';

class PaymentButtonSection extends StatelessWidget {
  const PaymentButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: BlocBuilder<BasketBloc, BaseState<ItemModel>>(
        builder: (context, state) {
          final total = state.items.fold<double>(
            0,
            (sum, item) => sum + item.totalSplitPrice,
          );
          if (total == 0) return const SizedBox.shrink();

          return SizedBox(
            width: double.infinity,
            height: 54.h,
            child: ElevatedButton(
              onPressed: () {
                // Payment logic here
                showCustomSnackBar(context, 'Processing Payment...');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainAppColor,
                elevation: 4,
                shadowColor: AppColors.mainAppColor.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.payment_rounded, color: Colors.white, size: 24.sp),
                  SizedBox(width: 12.w),
                  Text(
                    'payment'.tr().toUpperCase(),
                    style: AppTextTheme.titleLarge.copyWith(
                      color: AppColors.white,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
