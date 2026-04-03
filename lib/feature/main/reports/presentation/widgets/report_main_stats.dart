part of '../../reports_imports.dart';

class ReportMainStats extends StatelessWidget {
  final ReportSummaryModel report;

  const ReportMainStats({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Total Sales — Blue
        Expanded(
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xff3B5BDB),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'إجمالي المبيعات',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  report.totalSales.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'ريال سعودي',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12.w),

        // Invoice Count — Green
        Expanded(
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xff40C057),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'عدد الفواتير',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '${report.invoicesCount}',
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'فاتورة',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}