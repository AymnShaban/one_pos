import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../../../core/helper/helper.dart';
import '../../data/models/branch_profit_response_model.dart';
import 'month_card.dart';
class ResultsPanel extends StatelessWidget {
  final BranchProfitResponseModel data;

  const ResultsPanel({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final hasRows = data.rows.isNotEmpty;
    final hasAnalysis = data.analysisRows.isNotEmpty;

    return ListView(
      padding: EdgeInsets.only(bottom: 20.h),
      children: [
        // ===== Summary Card =====
        _SummaryCard(data: data),

        // ===== Branch Cards (من RowModel) =====
        if (hasRows) ...[
          ...data.rows.asMap().entries.map((entry) {
            final index = entry.key;
            final row = entry.value;
            return BranchCard(
              data: row,
              index: index,
            );
          }),
        ],

        // ===== Analysis Rows =====
        if (hasAnalysis && !hasRows) ...[
          SizedBox(height: 10.h),
          _AnalysisHeader(count: data.analysisRows.length),
          ...data.analysisRows.asMap().entries.map((entry) {
            final index = entry.key;
            final row = entry.value;
            return _AnalysisCard(
              row: row,
              isLast: index == data.analysisRows.length - 1,
            );
          }),
        ],

        // ===== Empty State =====
        if (!hasRows && !hasAnalysis) ...[
          SizedBox(height: 20.h),
          _EmptyState(),
        ],
      ],
    );
  }
}

// ==================== SUMMARY CARD ====================

// ==================== SUMMARY CARD ====================

class _SummaryCard extends StatelessWidget {
  final BranchProfitResponseModel data;

  const _SummaryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final hasRows = data.rows.isNotEmpty;
    final hasAnalysis = data.analysisRows.isNotEmpty;

    // ===== حساب الإجماليات بناءً على البيانات الموجودة =====
    double totalNetProfit = 0;
    double totalSales = 0;
    double totalCost = 0;
    double totalExpended = 0;

    if (hasRows) {
      // من RowModel
      totalNetProfit = data.totalNetProfit;
      totalSales = data.totalSales;
      totalCost = data.totalCost;
      totalExpended = data.totalExpended;
    } else if (hasAnalysis) {
      // من AnalysisRow
      for (final row in data.analysisRows) {
        final balance = row.credit - row.debit;
        totalNetProfit += balance;
        totalSales += row.credit;
        totalCost += row.debit;
        totalExpended += row.debit; // في التحليل، المصروفات = المدين
      }
    }

    final isNegative = totalNetProfit < 0;

    return Container(
      margin: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 0),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.tintCream,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.tintCreamLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hasAnalysis && !hasRows
                ? 'branch_profit.total_balance'.tr()
                : 'branch_profit.total_net_profit'.tr(),
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.muted,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            _formatCurrency(totalNetProfit),
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              color: isNegative ? AppColors.red : AppColors.navyMid,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _TotalBox(
                label: hasAnalysis && !hasRows
                    ? 'branch_profit.total_credit'.tr()
                    : 'branch_profit.sales'.tr(),
                value: _formatShortCurrency(totalSales),
              ),
              SizedBox(width: 8.w),
              _TotalBox(
                label: hasAnalysis && !hasRows
                    ? 'branch_profit.total_debit'.tr()
                    : 'branch_profit.cost'.tr(),
                value: _formatShortCurrency(totalCost),
              ),
              SizedBox(width: 8.w),
              _TotalBox(
                label: 'branch_profit.expenses'.tr(),
                value: _formatShortCurrency(totalExpended),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    return NumberFormat('#,##0.000', 'en_US').format(amount);
  }

  String _formatShortCurrency(double amount) {

    return NumberFormat('#,##0', 'en_US').format(amount);
  }
}

// ==================== TOTAL BOX ====================

class _TotalBox extends StatelessWidget {
  final String label;
  final String value;

  const _TotalBox({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9.r),
          border: Border.all(color: AppColors.tintCreamLine),
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

// ==================== ANALYSIS HEADER ====================

class _AnalysisHeader extends StatelessWidget {
  final int count;

  const _AnalysisHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(14.w, 16.h, 14.w,10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'branch_profit.analysis'.tr(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
              color: AppColors.navyDark,
            ),
          ),
          Text(
            '$count ${'branch_profit.items'.tr()}',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== ANALYSIS CARD ====================

class _AnalysisCard extends StatefulWidget {
  final AnalysisRow row;
  final bool isLast;

  const _AnalysisCard({
    required this.row,
    required this.isLast,
  });

  @override
  State<_AnalysisCard> createState() => _AnalysisCardState();
}

class _AnalysisCardState extends State<_AnalysisCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final row = widget.row;
    final balance = row.credit - row.debit;
    final isNeg = balance < 0;
    final netColor = isNeg ? AppColors.red : AppColors.green;

    // استخراج الشهر والسنة من periodLabel
    String monthNum = '';
    String yearNum = '';
    if (row.periodLabel != null && row.periodLabel!.contains('/')) {
      final parts = row.periodLabel!.split('/');
      if (parts.length >= 2) {
        monthNum = parts[0];
        yearNum = parts[1];
      }
    }

    final bool isHeader = row.isHeader;


    final double debitRatio = row.credit > 0
        ? ((row.debit / row.credit) * 100).toDouble()
        : 0.0;
    final double balanceRatio = row.credit > 0
        ? ((balance.abs() / row.credit) * 100).toDouble()
        : 0.0;
    final double netMargin = row.credit > 0
        ? ((balance / row.credit) * 100).toDouble()
        : 0.0;

    // ألوان البادج
    final Color badgeColor = isHeader
        ? AppColors.navyLight.withOpacity(0.15)
        : (balance >= 0 ? AppColors.tintGreen : AppColors.tintBlue);

    final Color textColor = isHeader
        ? AppColors.navyLight
        : (balance >= 0 ? AppColors.green : AppColors.navyLight);

    return Container(
      margin: EdgeInsets.fromLTRB(14.w, widget.isLast ? 10.h : 0, 14.w, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),

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


                  // ===== Label =====
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          row.label ?? '',
                          style: TextStyle(
                            fontSize: isHeader ? 15.sp : 14.sp,
                            fontWeight: isHeader ? FontWeight.bold : FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                        if (row.periodLabel != null && !isHeader) ...[
                          SizedBox(height: 2.h),
                          Text(
                            row.periodLabel!,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                        if (isHeader) ...[
                          SizedBox(height: 2.h),
                          Text(
                            'branch_profit.analysis_header'.tr(),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // ===== Balance =====
                  Text(
                    _formatCurrency(balance),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: netColor,
                    ),
                  ),
                  SizedBox(width: 4.w),

                  // ===== Animated Arrow =====
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
                _AnalysisStatPill(
                  label: 'branch_profit.debit'.tr(),
                  value: row.debit > 0 ? _formatShortCurrency(row.debit) : '-',
                  color: row.debit > 0 ? AppColors.red : AppColors.muted,
                  bg: row.debit > 0 ? AppColors.redBg : AppColors.lineColor.withOpacity(0.3),
                ),
                SizedBox(width: 8.w),
                _AnalysisStatPill(
                  label: 'branch_profit.credit'.tr(),
                  value: row.credit > 0 ? _formatShortCurrency(row.credit) : '-',
                  color: row.credit > 0 ? AppColors.green : AppColors.muted,
                  bg: row.credit > 0 ? AppColors.greenBg : AppColors.lineColor.withOpacity(0.3),
                ),
                SizedBox(width: 8.w),
                _AnalysisStatPill(
                  label: 'branch_profit.balance'.tr(),
                  value: _formatShortCurrency(balance),
                  color: balance >= 0 ? AppColors.green : AppColors.red,
                  bg: balance >= 0 ? AppColors.greenBg : AppColors.redBg,
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
            secondChild: _AnalysisDetail(
              data: row,
              debitRatio: debitRatio,
              balanceRatio: balanceRatio,
              netMargin: netMargin,
              isNeg: isNeg,
              netColor: netColor,
              balance: balance,
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

// ==================== ANALYSIS STAT PILL ====================

class _AnalysisStatPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color bg;

  const _AnalysisStatPill({
    required this.label,
    required this.value,
    required this.color,
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
                color: color,
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

// ==================== ANALYSIS DETAIL ====================

class _AnalysisDetail extends StatelessWidget {
  final AnalysisRow data;
  final double debitRatio;
  final double balanceRatio;
  final double netMargin;
  final bool isNeg;
  final Color netColor;
  final double balance;

  const _AnalysisDetail({
    required this.data,
    required this.debitRatio,
    required this.balanceRatio,
    required this.netMargin,
    required this.isNeg,
    required this.netColor,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    final d = data;

    return Container(
      padding: EdgeInsets.fromLTRB(10.w, 4.h, 10.w, 8.h),
      decoration: const BoxDecoration(
       // border: Border(top: BorderSide(color: AppColors.lineColor)),
      ),
      child: Column(
        children: [
          SizedBox(height: 12.h),

          // ===== Chips =====
          Row(
            children: [
              _AnalysisMiniChip(
                value: '${debitRatio.toStringAsFixed(1)}%',
                label: 'branch_profit.debit_ratio'.tr(),
                color: AppColors.red,
              ),
              SizedBox(width: 8.w),
              _AnalysisMiniChip(
                value: '${balanceRatio.toStringAsFixed(1)}%',
                label: 'branch_profit.balance_ratio'.tr(),
                color: AppColors.gold,
              ),
              SizedBox(width: 8.w),
              _AnalysisMiniChip(
                value: '${netMargin.toStringAsFixed(1)}%',
                label: 'branch_profit.net_margin'.tr(),
                color: netColor,
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // ===== Doughnut Chart =====
          Text(
            'branch_profit.distribution'.tr(),
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.navyMid,
            ),
          ),
          SizedBox(height: 8.h),
          _DonutChartMini(
            values: [
              d.debit.abs(),
              d.credit.abs(),
              balance.abs(),
            ],
            colors: [
              AppColors.red,
              AppColors.green,
              netColor,
            ],
            labels: [
              'branch_profit.debit'.tr(),
              'branch_profit.credit'.tr(),
              isNeg ? 'branch_profit.net_loss'.tr() : 'branch_profit.net_balance'.tr(),
            ],
          ),



        ],
      ),
    );
  }
}

// ==================== ANALYSIS MINI CHIP ====================

class _AnalysisMiniChip extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _AnalysisMiniChip({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.lightGray,
          borderRadius: BorderRadius.circular(9.r),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: color,
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
    final maxVal = values.map((v) => v.abs()).fold<double>(0, (a, b) => a > b ? a : b);
    final ceiling = maxVal == 0 ? 1.0 : maxVal * 1.2;

    final screenWidth = MediaQuery.of(context).size.width;
    final barWidth = screenWidth < 400 ? 22 : 30;

    return SizedBox(
      height: 220.h,
      child: BarChart(
        BarChartData(
          maxY: ceiling,
          minY: 0,
          alignment: BarChartAlignment.spaceAround,

          // ===== شبكة =====
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: false,
            horizontalInterval: ceiling / 6,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: AppColors.lineColor.withOpacity(0.3),
                strokeWidth: 1,
                dashArray: [4, 4],
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
                return BarTooltipItem(
                  '${labels[group.x.toInt()]}\n${NumberFormat('#,##0.000', 'en_US').format(rod.toY)}',
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
                interval: ceiling / 6,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: EdgeInsets.only(left: 4.w),
                    child: Text(
                      NumberFormat('#,##0', 'en_US').format(value),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
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
                        fontSize: 11.sp,
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
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: values[i],
                  color: colors[i],
                  width: barWidth.toDouble(),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

// ==================== EMPTY STATE ====================

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 20.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.lineColor),
      ),
      child: Center(
        child: Text(
          'branch_profit.no_data'.tr(),
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.muted,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
