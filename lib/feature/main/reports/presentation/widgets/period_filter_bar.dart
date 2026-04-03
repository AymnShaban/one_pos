part of '../../reports_imports.dart';

class PeriodFilterBar extends StatelessWidget {
  final ReportPeriod selected;

  const PeriodFilterBar({super.key, required this.selected});

  static const _periods = [
    ReportPeriod.today,
    ReportPeriod.week,
    ReportPeriod.month,
    ReportPeriod.custom,
  ];

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'الفترة الزمنية',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff1A1A1A),
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.calendar_month_outlined,
                size: 18.sp,
                color: const Color(0xff8A8F99),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: _periods.reversed.map((period) {
              final isSelected = selected == period;
              return Expanded(
                child: GestureDetector(
                  onTap: () => context
                      .read<ReportsBloc>()
                      .add(ChangeReportPeriod(period)),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.only(
                      left: period != ReportPeriod.custom ? 8.w : 0,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xff3B5BDB)
                          : const Color(0xffF0F2F8),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      period.arLabel,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xff1A1A1A),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}