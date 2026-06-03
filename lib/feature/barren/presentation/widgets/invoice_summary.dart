import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_pos/core/helper/helper.dart';

/// Invoice summary section showing totals
class InvoiceSummary extends StatelessWidget {
  final int itemCount;
  final double totalQuantity;

  const InvoiceSummary({
    super.key,
    required this.itemCount,
    required this.totalQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _SummaryItem(
          label: 'total_quantity'.tr(),
          value: totalQuantity == totalQuantity.toInt()
              ? totalQuantity.toInt().toString()
              : totalQuantity.toString(),
        ),
        
        // Divider
        Container(
          width: 1,
          height: 30.h,
          color: Colors.black12,
        ),
        
        // Item count
        _SummaryItem(
          label: 'item_count'.tr(),
          value: '$itemCount',
        ),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextTheme.caption,
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: AppTextTheme.body2Bold,
        ),
      ],
    );
  }
}
