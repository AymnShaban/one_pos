
import '../helper/helper.dart';


class KpiItem {
  final String label;
  final String value;
  final Color? valueColor;
  KpiItem({required this.label, required this.value, this.valueColor});
}

class KpiGrid extends StatelessWidget {
  final List<KpiItem> items;
  const KpiGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10.h,
      crossAxisSpacing: 10.w,
      childAspectRatio: 2.3,
      children: items.map((k) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.line),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(k.label, style: TextStyle(fontSize: 11.sp, color: AppColors.textMuted)),
              SizedBox(height: 4.h),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  k.value,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16.sp,
                    color: k.valueColor ?? AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
