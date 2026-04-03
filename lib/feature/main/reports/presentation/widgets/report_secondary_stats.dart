part of '../../reports_imports.dart';

class ReportSecondaryStats extends StatelessWidget {
  final ReportSummaryModel report;

  const ReportSecondaryStats({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Average invoice
        Expanded(
          child: _SecondaryCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'متوسط الفاتورة',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xff8A8F99),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  report.averageInvoice.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff1A1A1A),
                  ),
                ),
                Text(
                  'ريال سعودي',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xff8A8F99),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12.w),

        // Payment methods
        Expanded(
          child: _SecondaryCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'طرق الدفع',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xff8A8F99),
                  ),
                ),
                SizedBox(height: 10.h),
                _PaymentRow(
                  label: 'نقدي',
                  amount: report.cashAmount,
                ),
                SizedBox(height: 6.h),
                _PaymentRow(
                  label: 'بطاقة',
                  amount: report.cardAmount,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SecondaryCard extends StatelessWidget {
  final Widget child;

  const _SecondaryCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _PaymentRow extends StatelessWidget {
  final String label;
  final double amount;

  const _PaymentRow({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${amount.toInt()}',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xff1A1A1A),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            color: const Color(0xff8A8F99),
          ),
        ),
      ],
    );
  }
}