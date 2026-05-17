part of '../../sales_imports.dart';

class BasketBottomBar extends StatelessWidget {
  const BasketBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BasketBloc, BaseState<BasketItemModel>>(
      builder: (context, state) {
        if (state.items.isEmpty) {
          return const SizedBox.shrink();
        }

        final totalItems = state.items.length;
        final totalPrice = state.items.fold<double>(
          0,
          (sum, item) => sum + item.totalSplitPrice,
        );

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BasketScreen()),
            );
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.mainAppColor, AppColors.tealAccentColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.mainAppColor.withValues(alpha: 0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                // Items count badge with animation feel
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                       Icon(Icons.shopping_basket_rounded, color: Colors.white, size: 18.sp),
                       SizedBox(width: 8.w),
                       Text(
                        '$totalItems',
                        style: AppTextTheme.body2Bold.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                
                // Basket Info
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'your_basket'.tr(),
                        style: AppTextTheme.labelSmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      Text(
                        '${totalPrice.toStringAsFixed(2)} ${"EGP".tr()}',
                        style: AppTextTheme.body1.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Navigate text/icon
                Text(
                  'view_basket'.tr(),
                  style: AppTextTheme.labelMedium11Bold.copyWith(color: Colors.white),
                ),
                SizedBox(width: 4.w),
                const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 14),
              ],
            ),
          ),
        );
      },
    );
  }
}
