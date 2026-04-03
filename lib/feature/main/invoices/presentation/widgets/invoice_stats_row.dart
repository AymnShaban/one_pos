import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/invoice_model.dart';

class InvoiceStatsRow extends StatelessWidget {
  final InvoiceStatsModel stats;

  const InvoiceStatsRow({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(
          label: 'إجمالي\nالفواتير',
          value: '${stats.total}',
          valueColor: const Color(0xff1A1A1A),
        ),
        SizedBox(width: 8.w),
        _StatCard(
          label: 'المكتملة',
          value: '${stats.completed}',
          valueColor: const Color(0xff40C057),
        ),
        SizedBox(width: 8.w),
        _StatCard(
          label: 'المعلقة',
          value: '${stats.pending}',
          valueColor: const Color(0xffF59F00),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              label,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 11.sp,
                color: const Color(0xff8A8F99),
                height: 1.4,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}