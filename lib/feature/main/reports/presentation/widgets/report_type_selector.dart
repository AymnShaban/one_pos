part of '../../reports_imports.dart';

class ReportTypeSelector extends StatelessWidget {
  final ReportType selected;

  const ReportTypeSelector({super.key, required this.selected});

  static const _types = [
    (
    type: ReportType.dailySales,
    icon: Icons.attach_money_rounded,
    color: Color(0xff3B5BDB),
    ),
    (
    type: ReportType.trends,
    icon: Icons.trending_up_rounded,
    color: Color(0xff9B59B6),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _types.map((item) {
        final isSelected = selected == item.type;
        return Expanded(
          child: GestureDetector(
            onTap: () => context
                .read<ReportsBloc>()
                .add(ChangeReportType(item.type)),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(
                left: item.type != ReportType.trends ? 8.w : 0,
              ),
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
                border: isSelected
                    ? Border.all(color: const Color(0xff3B5BDB), width: 2)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      color: item.color,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      item.icon,
                      color: Colors.white,
                      size: 22.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    item.type.arLabel,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? const Color(0xff3B5BDB)
                          : const Color(0xff1A1A1A),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}