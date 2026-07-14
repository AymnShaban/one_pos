import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/theme/app_text_theme.dart';

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,                          // ← ProfitInquiryColors.card
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF14283C).withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 14.sp, color: iconColor),
          SizedBox(height: 6.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextTheme.labelSmall.copyWith(          // 10sp ≈ 10.5sp w700
              fontWeight: FontWeight.w700,
              color: AppColors.grey,                          // ← ProfitInquiryColors.textDim
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            value,
            textAlign: TextAlign.center,
            style: AppTextTheme.body2Bold.copyWith(           // 14sp bold ≈ 13sp w800
              fontWeight: FontWeight.w800,
              color: valueColor ?? AppColors.black,           // ← ProfitInquiryColors.text
            ),
          ),
        ],
      ),
    );
  }
}

class ProfitStatsRow extends StatelessWidget {
  const ProfitStatsRow({
    super.key,
    required this.totalSales,
    required this.totalCost,
    required this.currencyLabel,
  });

  final double totalSales;
  final double totalCost;
  final String currencyLabel;

  double get _netProfit => totalSales - totalCost;

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
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.shopping_cart,
            iconColor: AppColors.mainAppColor,                // ← ProfitInquiryColors.primary
            label: 'إجمالي المبيعات',
            value: '${_fmt(totalSales)} $currencyLabel',
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _StatCard(
            icon: Icons.inventory_2,
            iconColor: AppColors.amber,                       // ← ProfitInquiryColors.costOrange
            label: 'إجمالي التكلفة',
            value: '${_fmt(totalCost)} $currencyLabel',
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _StatCard(
            icon: Icons.trending_up,
            iconColor: AppColors.green,                       // ← ProfitInquiryColors.success
            label: 'صافي الربح',
            value: '${_fmt(_netProfit)} $currencyLabel',
            valueColor: AppColors.green,                      // ← ProfitInquiryColors.success
          ),
        ),
      ],
    );
  }
}

