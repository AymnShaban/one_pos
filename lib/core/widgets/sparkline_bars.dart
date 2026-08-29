

import '../helper/helper.dart';

class SparklineBars extends StatelessWidget {
  final List<double> values;
  final double width;
  final double height;

  const SparklineBars({
    super.key,
    required this.values,
    this.width = 52,
    this.height = 20,
  });

  @override
  Widget build(BuildContext context) {
    final maxAbs = values.map((v) => v.abs()).fold<double>(1, (a, b) => a > b ? a : b);
    return SizedBox(
      width: width.w,
      height: height.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: values.map((v) {
          final h = (v.abs() / maxAbs * height.h).clamp(2.0.h, height.h);
          return Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              height: h,
              decoration: BoxDecoration(
                color: v < 0 ? const Color(0xFFF5CAC6) : const Color(0xFFD6DEEC),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
