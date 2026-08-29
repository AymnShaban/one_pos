



import '../../../../../../core/widgets/sparkline_bars.dart';
import '../../../expense_analysis/expense_analysis_imports.dart';



class MonthValue {
  final String label;
  final double value;
  MonthValue(this.label, this.value);
}


class ExpandableAccountCard extends StatefulWidget {
  final String name;
  final String code;
  final double total;
  final List<MonthValue> months;
  final bool highlight;

  const ExpandableAccountCard({
    super.key,
    required this.name,
    required this.code,
    required this.total,
    required this.months,
    this.highlight = false,
  });

  @override
  State<ExpandableAccountCard> createState() => _ExpandableAccountCardState();
}

class _ExpandableAccountCardState extends State<ExpandableAccountCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final titleColor = widget.highlight ? Colors.white : AppColors.textDark;
    final codeColor = widget.highlight ? Colors.white.withOpacity(0.55) : AppColors.textMuted;

    return Container(
      margin: EdgeInsets.only(top: 10.h),
      decoration: BoxDecoration(
        color: widget.highlight ? AppColors.textDark : AppColors.card,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: widget.highlight ? AppColors.textDark : AppColors.line,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _open = !_open),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 13.w,
                vertical: 12.h,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: titleColor,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          widget.code,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: codeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SparklineBars(
                    values: widget.months.map((m) => m.value).toList(),
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          formatNumber(widget.total),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5.sp,
                            color: widget.total < 0
                                ? AppColors.red
                                : (widget.highlight
                                ? Colors.white
                                : AppColors.textDark),
                          ),
                        ),
                      ),
                      Icon(
                        _open
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 16.sp,
                        color: widget.highlight
                            ? Colors.white.withOpacity(0.6)
                            : AppColors.textMuted,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            child: _open
                ? Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                13.w,
                10.h,
                13.w,
                12.h,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFFFAFBFD),
                border: Border(
                  top: BorderSide(color: AppColors.line),
                ),
              ),
              child: Column(
                children: widget.months
                    .map(
                      (m) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          m.label,
                          style: TextStyle(
                            fontSize: 11.5.sp,
                            color: AppColors.textMuted,
                          ),
                        ),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            formatNumber(m.value),
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w600,
                              color: m.value < 0
                                  ? AppColors.red
                                  : AppColors.textDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                    .toList(),
              ),
            )
                : const SizedBox(
              width: double.infinity,
              height: 0,
            ),
          ),
        ],
      ),
    );
  }
}
