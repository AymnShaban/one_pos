part of '../../../basket_imports.dart';

extension QuantitySectionExt on _BasketPosSummaryState {
  Widget _buildQuantitySection(num totalQty, int itemCount) {
    return Row(
      children: [
        Expanded(
          child: _columnInfo(
            'new_invoice.total_quantity'.tr(),
            totalQty.toString(),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _columnInfo(
            'new_invoice.item_count'.tr(),
            itemCount.toString(),
          ),
        ),
      ],
    );
  }

  Widget _columnInfo(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextTheme.labelSmall9Bold),
        SizedBox(height: 4.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: AppTextTheme.captionBold.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
