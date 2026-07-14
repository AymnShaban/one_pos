import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/theme/app_text_theme.dart';

import '../../data/models/profit_item_model.dart';




class ProfitItemCard extends StatelessWidget {
  const ProfitItemCard({
    super.key,
    required this.item,
    required this.currencyLabel,
  });

  final ProfitItemModel item;
  final String currencyLabel;

  ({Color bg, Color text}) get _marginColors {
    final margin = item.marginPercent;
    if (margin < 10) {
      return (
      bg: AppColors.redBg,    // ← ProfitInquiryColors.marginLowBg
      text: AppColors.red,    // ← ProfitInquiryColors.marginLowText
      );
    }
    if (margin < 25) {
      return (
      bg: AppColors.amberBg,  // ← ProfitInquiryColors.marginMidBg
      text: AppColors.amber,  // ← ProfitInquiryColors.marginMidText
      );
    }
    return (
    bg: AppColors.greenBg,    // ← ProfitInquiryColors.marginHighBg
    text: AppColors.green,    // ← ProfitInquiryColors.marginHighText
    );
  }

  String _fmt(double v) {
    final s = v.round().toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i != 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    final margin = _marginColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,                            // ← ProfitInquiryColors.card
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF14283C).withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: AppTextTheme.body2Bold.copyWith(  // 14sp bold ≈ 13.5sp w800
                        fontWeight: FontWeight.w800,
                        color: AppColors.black,                // ← ProfitInquiryColors.text
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'الكمية المباعة: ${item.soldQuantity}',
                      style: AppTextTheme.labelMedium11Bold.copyWith( // 11sp bold ≈ 11sp w600
                        color: AppColors.grey,                 // ← ProfitInquiryColors.textDim
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: margin.bg,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'هامش ${item.marginPercent.round()}%',
                  style: AppTextTheme.labelMedium11Bold.copyWith( // 11sp bold ≈ 11sp w800
                    fontWeight: FontWeight.w800,
                    color: margin.text,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,                 // ← ProfitInquiryColors.background
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                _Figure(
                  label: 'التكلفة',
                  value: '${_fmt(item.cost)} $currencyLabel',
                  showDivider: true,
                ),
                _Figure(
                  label: 'المبيعات',
                  value: '${_fmt(item.sales)} $currencyLabel',
                  showDivider: true,
                ),
                _Figure(
                  label: 'الربح',
                  value: '${_fmt(item.profit)} $currencyLabel',
                  valueColor: AppColors.green,                  // ← ProfitInquiryColors.success
                  showDivider: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class _Figure extends StatelessWidget {
  const _Figure({
    required this.label,
    required this.value,
    required this.showDivider,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool showDivider;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
        decoration: BoxDecoration(
          border: showDivider
              ? Border(right: BorderSide(color: AppColors.grey)) // ← ProfitInquiryColors.line
              : null,
        ),
        child: Column(
          children: [
            Text(
              label,
              style: AppTextTheme.labelSmall9Bold.copyWith(     // 9sp bold ≈ 9.5sp w700
                color: AppColors.grey,                          // ← ProfitInquiryColors.textDim
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              value,
              style: AppTextTheme.captionBold.copyWith(         // 12sp bold w800
                fontWeight: FontWeight.w800,
                color: valueColor ?? AppColors.black,           // ← ProfitInquiryColors.text
              ),
            ),
          ],
        ),
      ),
    );
  }
}

