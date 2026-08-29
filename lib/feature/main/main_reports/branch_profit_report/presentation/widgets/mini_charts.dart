import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../../../core/helper/helper.dart';


class DonutChartMini extends StatelessWidget {
  final List<double> values;
  final List<Color> colors;
  final List<String> labels;

  const DonutChartMini({
    super.key,
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
              // ===== Touch للدائري =====
              pieTouchData: PieTouchData(
                enabled: true,
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  // يمكن إضافة تفاعل هنا
                },
              ),
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

class BarChartMini extends StatelessWidget {
  final List<double> values;
  final List<Color> colors;
  final List<String> labels;

  const BarChartMini({
    super.key,
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
          minY: values.any((v) => v < 0) ? -ceiling * 0.3 : 0,
          alignment: BarChartAlignment.spaceAround,

          // ===== شبكة خفيفة =====
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

          // ===== TOOLTIP =====
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
                    color: const Color(0xFF1F2A3C),
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
                        color: const Color(0xFF1F2A3C),
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
                        color: const Color(0xFF1F2A3C),
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
