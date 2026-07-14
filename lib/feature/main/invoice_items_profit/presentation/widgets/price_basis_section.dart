import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/theme/app_text_theme.dart';





class PriceBasisSection extends StatelessWidget {
  const PriceBasisSection({
    super.key,
    required this.costPriceLabel,
    required this.salePriceLabel,
    required this.onTapCostPrice,
    required this.onTapSalePrice,
  });

  final String costPriceLabel;
  final String salePriceLabel;
  final VoidCallback onTapCostPrice;
  final VoidCallback onTapSalePrice;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _PriceSelectField(
            label: 'سعر التكلفة',
            value: costPriceLabel,
            onTap: onTapCostPrice,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _PriceSelectField(
            label: 'سعر البيع',
            value: salePriceLabel,
            onTap: onTapSalePrice,
          ),
        ),
      ],
    );
  }
}

class _PriceSelectField extends StatelessWidget {
  const _PriceSelectField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextTheme.labelMedium11Bold.copyWith(  // 11sp bold ≈ 11.5sp w600
            color: AppColors.grey,                         // ← ProfitInquiryColors.textDim
          ),
        ),
        SizedBox(height: 6.h),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,            // ← ProfitInquiryColors.background
              border: Border.all(color: AppColors.grey),  // ← ProfitInquiryColors.line
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: AppTextTheme.body2Bold.copyWith( // 14sp bold ≈ 13sp w600
                    color: AppColors.black,               // ← ProfitInquiryColors.text
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16.sp,
                  color: AppColors.grey,                  // ← ProfitInquiryColors.textDim
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

