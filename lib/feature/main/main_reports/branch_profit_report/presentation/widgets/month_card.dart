import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../../../core/helper/helper.dart';
import '../../data/models/branch_profit_response_model.dart';



class BranchCard extends StatefulWidget {
  final RowModel data;
  final int index;

  const BranchCard({
    super.key,
    required this.data,
    required this.index,
  });

  @override
  State<BranchCard> createState() => _BranchCardState();
}

class _BranchCardState extends State<BranchCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final isNeg = d.netProfit < 0;
    final netColor = isNeg ? AppColors.red : AppColors.navyLight;
    final branchName = d.branchName ?? d.branchEName ?? 'branch_profit.unknown_branch'.tr();

    // حساب النسب المئوية
    final double grossMargin = d.totalSales > 0
        ? ((d.benifit / d.totalSales) * 100).toDouble()
        : 0.0;
    final double expenseRatio = d.totalSales > 0
        ? ((d.expended / d.totalSales) * 100).toDouble()
        : 0.0;
    final double netMargin = d.totalSales > 0
        ? ((d.netProfit / d.totalSales) * 100).toDouble()
        : 0.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.lineColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // ===== Header (clickable) =====
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 13.h),
              child: Row(
                children: [
                  Container(
                    width: 38.w,
                    height: 38.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.tintBlue,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      '${widget.index + 1}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navyLight,
                        height: 1.1,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          branchName,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.ink,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        if (d.periodLabel != null)
                          Text(
                            d.periodLabel!,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.muted,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    _formatCurrency(d.netProfit),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: netColor,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20.sp,
                      color: _expanded ? AppColors.gold : AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ===== Stats Strip =====
          Padding(
            padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 13.h),
            child: Row(
              children: [
                _StatPill(
                  label: 'branch_profit.sales'.tr(),
                  value: _formatShortCurrency(d.totalSales),
                  bg: AppColors.tintBlue,
                ),
                SizedBox(width: 8.w),
                _StatPill(
                  label: 'branch_profit.cost'.tr(),
                  value: _formatShortCurrency(d.cost),
                  bg: AppColors.tintGreen,
                ),
                SizedBox(width: 8.w),
                _StatPill(
                  label: 'branch_profit.expense'.tr(),
                  value: _formatShortCurrency(d.expended),
                  bg: const Color(0xFFF7F9FC),
                ),
              ],
            ),
          ),

          // ===== Expanded Detail =====
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            sizeCurve: Curves.easeInOut,
            crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: SizedBox(width: double.infinity, height: 0),
            secondChild: _BranchDetail(
              data: d,
              grossMargin: grossMargin,
              expenseRatio: expenseRatio,
              netMargin: netMargin,
              isNeg: isNeg,
              netColor: netColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    return NumberFormat('#,##0.000', 'en_US').format(amount);
  }

  String _formatShortCurrency(double amount) {
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}

// ==================== STAT PILL ====================

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final Color bg;

  const _StatPill({
    required this.label,
    required this.value,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color: AppColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== BRANCH DETAIL ====================

class _BranchDetail extends StatelessWidget {
  final RowModel data;
  final double grossMargin;
  final double expenseRatio;
  final double netMargin;
  final bool isNeg;
  final Color netColor;

  const _BranchDetail({
    required this.data,
    required this.grossMargin,
    required this.expenseRatio,
    required this.netMargin,
    required this.isNeg,
    required this.netColor,
  });

  @override
  Widget build(BuildContext context) {
    final d = data;

    return Container(
      padding: EdgeInsets.fromLTRB(0, 4, 0, 18),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.lineColor)),
      ),
      child: Column(
        children: [
          SizedBox(height: 12.h),
          // ===== Chips =====
          Row(
            children: [
              _MiniChip(
                value: '${grossMargin.toStringAsFixed(1)}%',
                label: 'branch_profit.gross_margin'.tr(),
              ),
              SizedBox(width: 8.w),
              _MiniChip(
                value: '${expenseRatio.toStringAsFixed(1)}%',
                label: 'branch_profit.expense_ratio'.tr(),
              ),
              SizedBox(width: 8.w),
              _MiniChip(
                value: '${netMargin.toStringAsFixed(1)}%',
                label: 'branch_profit.net_margin'.tr(),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // ===== Doughnut Chart =====
          Text(
            'branch_profit.sales_distribution'.tr(),
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.navyMid,
            ),
          ),
          SizedBox(height: 8.h),
          _DonutChartMini(
            values: [d.cost, d.expended, d.netProfit.abs()],
            colors: [AppColors.navyLight, AppColors.gold, netColor],
            labels: [
              'branch_profit.cost_of_sales'.tr(),
              'branch_profit.expense'.tr(),
              isNeg ? 'branch_profit.loss'.tr() : 'branch_profit.net_profit'.tr(),
            ],
          ),
          SizedBox(height: 18.h),

          // ===== Bar Chart =====
          Text(
            'branch_profit.financial_comparison'.tr(),
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.navyMid,
            ),
          ),
          SizedBox(height: 8.h),
          _BarChartMini(
            values: [
              d.totalSales,
              d.cost,
              d.benifit,
              d.expended,
              d.netProfit,
            ],
            colors: [
              AppColors.navyLight,
              AppColors.gold,
              AppColors.green,
              const Color(0xFFE57373),
              netColor,
            ],
            labels: [
              'branch_profit.sales'.tr(),
              'branch_profit.cost'.tr(),
              'branch_profit.gross_profit'.tr(),
              'branch_profit.expense'.tr(),
              'branch_profit.net_profit'.tr(),
            ],
          ),
        ],
      ),
    );
  }
}

// ==================== MINI CHIP ====================

class _MiniChip extends StatelessWidget {
  final String value;
  final String label;

  const _MiniChip({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F9FC),
          borderRadius: BorderRadius.circular(9.r),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color: AppColors.muted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== DOUGHNUT CHART ====================

class _DonutChartMini extends StatelessWidget {
  final List<double> values;
  final List<Color> colors;
  final List<String> labels;

  const _DonutChartMini({
    required this.values,
    required this.colors,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    final total = values.fold<double>(0, (a, b) => a + b);
    return Column(
      children: [
        SizedBox(
          height: 140.h,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 35.r,
              sections: List.generate(values.length, (i) {
                final pct = total == 0 ? 0 : (values[i] / total) * 100;
                return PieChartSectionData(
                  value: values[i] <= 0 ? 0.0001 : values[i],
                  color: colors[i],
                  radius: 45.r,
                  showTitle: pct >= 8,
                  title: '${pct.toStringAsFixed(1)}%',
                  titleStyle: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 14.w,
          runSpacing: 6.h,
          alignment: WrapAlignment.center,
          children: List.generate(labels.length, (i) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10.w,
                  height: 10.h,
                  margin: EdgeInsets.only(left: 4.w),
                  decoration: BoxDecoration(
                    color: colors[i],
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.muted,
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}

// ==================== BAR CHART ====================

// ==================== BAR CHART ====================

class _BarChartMini extends StatelessWidget {
  final List<double> values;
  final List<Color> colors;
  final List<String> labels;

  const _BarChartMini({
    required this.values,
    required this.colors,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    // حساب القيمة القصوى المطلقة
    final maxVal = values.map((v) => v.abs()).fold<double>(0, (a, b) => a > b ? a : b);

    // إذا كانت كل القيم صفر، نحدد حد أقصى افتراضي
    final ceiling = maxVal == 0 ? 1.0 : maxVal * 1.2;

    // التحقق من وجود قيم سالبة
    final hasNegativeValues = values.any((v) => v < 0);

    // تحديد الحد الأدنى والأقصى
    final minY = hasNegativeValues ? -ceiling : 0.0;
    final maxY = ceiling;

    final screenWidth = MediaQuery.of(context).size.width;
    final barWidth = screenWidth < 400 ? 22 : 30;

    return SizedBox(
      height: 220.h,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          minY: minY,
          alignment: BarChartAlignment.spaceAround,

          // ===== شبكة =====
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: false,
            horizontalInterval: hasNegativeValues ? ceiling / 4 : ceiling / 6,
            getDrawingHorizontalLine: (value) {
              // خط الصفر يظهر فقط إذا كان في منتصف الرسم البياني (عند وجود قيم سالبة)
              final isZeroLine = hasNegativeValues && value == 0;
              return FlLine(
                color: isZeroLine
                    ? AppColors.ink.withOpacity(0.5)
                    : AppColors.lineColor.withOpacity(0.3),
                strokeWidth: isZeroLine ? 2 : 1,
                dashArray: isZeroLine ? null : [4, 4],
              );
            },
          ),

          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: AppColors.lineColor, width: 1.5),
              left: BorderSide(color: AppColors.lineColor, width: 1.5),
              right: const BorderSide(color: Colors.transparent),
              top: const BorderSide(color: Colors.transparent),
            ),
          ),

          // ===== Touch =====
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              tooltipPadding: EdgeInsets.all(12.w),
              tooltipMargin: 8.h,
              getTooltipColor: (group) => Colors.white,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final value = rod.toY;
                final isNegative = value < 0;
                final label = labels[group.x.toInt()];
                final formattedValue = NumberFormat('#,##0.000', 'en_US').format(value.abs());

                final displayValue = isNegative ? '- $formattedValue' : formattedValue;

                return BarTooltipItem(
                  '$label\n$displayValue',
                  TextStyle(
                    color: AppColors.ink,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                );
              },
            ),
          ),

          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

            // ===== المحور الأيسر (الأرقام) =====
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 55.w,
                interval: hasNegativeValues ? ceiling / 4 : ceiling / 6,
                getTitlesWidget: (value, meta) {
                  // إذا كانت القيمة 0 ولا يوجد قيم سالبة، لا نعرضها
                  if (value == 0 && !hasNegativeValues) {
                    return const SizedBox.shrink();
                  }

                  final displayValue = value < 0
                      ? '-${NumberFormat('#,##0', 'en_US').format(value.abs())}'
                      : NumberFormat('#,##0', 'en_US').format(value);

                  return Padding(
                    padding: EdgeInsets.only(left: 4.w),
                    child: Text(
                      displayValue,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: value == 0 ? AppColors.ink : AppColors.muted,
                      ),
                    ),
                  );
                },
              ),
            ),

            // ===== المحور السفلي (التسميات) =====
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 55.h,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= labels.length) return const SizedBox.shrink();
                  return Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Text(
                      labels[i],
                      style: TextStyle(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
          ),

          // ===== الأعمدة =====
          barGroups: List.generate(values.length, (i) {
            final value = values[i];
            final isNegative = value < 0;
            final isZero = value == 0;
            final color = colors[i];

            // الأعمدة السالبة باللون الأحمر، الموجبة بلونها الأصلي، الصفر بالرمادي
            Color barColor;
            if (isZero) {
              barColor = AppColors.lineColor;
            } else if (isNegative) {
              barColor = AppColors.red;
            } else {
              barColor = color;
            }

            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: value,
                  color: barColor,
                  width: barWidth.toDouble(),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(isNegative ? 0 : 4.r),
                    bottom: Radius.circular(isNegative ? 4.r : 0),
                  ),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
