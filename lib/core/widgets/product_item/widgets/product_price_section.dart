import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constant/app_colors.dart';
import '../../../theme/app_text_theme.dart';

class ProductPriceSection extends StatelessWidget {
  final double price;
  final double priceAfterDiscount;
  final bool hasDiscount;
  final double? customerQuantity;

  /// Currency label rendered next to every amount. Pass the active
  /// currency's `currencySymbol` (or its localized name) here — falls back
  /// to the `'EGP'` translation when null/empty so callers that haven't
  /// been wired to a real currency source still render something sensible.
  final String? currencyLabel;

  const ProductPriceSection({
    super.key,
    required this.price,
    required this.priceAfterDiscount,
    required this.hasDiscount,
    this.customerQuantity,
    this.currencyLabel,
  });

  @override
  Widget build(BuildContext context) {
    final currency = (currencyLabel != null && currencyLabel!.isNotEmpty)
        ? currencyLabel!
        : 'EGP'.tr();
    final hasLimit = customerQuantity != null && customerQuantity! > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '${priceAfterDiscount.toStringAsFixed(2)} $currency',
              style: AppTextTheme.bodyMedium.copyWith(
                color: Colors.black87,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (hasDiscount && !hasLimit) ...[
              const SizedBox(width: 4),
              Text(
                'instead_of'.tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextTheme.labelSmall9Bold,
              ),
              const SizedBox(width: 4),
              Text(
                '${price.toStringAsFixed(2)} $currency',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextTheme.captionBold.copyWith(
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
            if (hasLimit && hasDiscount) ...[
              SizedBox(width: 4.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppColors.mainAppColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  '${'limit'.tr()} ${customerQuantity!.toInt()}',
                  style: AppTextTheme.labelSmall9Bold.copyWith(
                    color: AppColors.mainAppColor,
                    fontSize: 9.sp,
                  ),
                ),
              ),
            ],
          ],
        ),
        if (hasLimit && hasDiscount)
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Row(
              children: [
                Text(
                  '${'after_limit_price'.tr()}: ',
                  style: AppTextTheme.labelSmall9Bold.copyWith(fontSize: 9.sp),
                ),
                Text(
                  '${price.toStringAsFixed(2)} $currency',
                  style: AppTextTheme.captionBold.copyWith(
                    color: Colors.grey,
                    fontSize: 9.sp,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
