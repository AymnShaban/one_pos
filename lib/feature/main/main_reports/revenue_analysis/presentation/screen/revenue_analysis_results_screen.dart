import 'package:easy_localization/easy_localization.dart';

import '../../../expense_analysis/expense_analysis_imports.dart';
import '../../data/models/revenue_report_response_model.dart';

class RevenueAnalysisResultsScreen extends StatelessWidget {
  final RevenueReportResponseModel reportData;

  const RevenueAnalysisResultsScreen({
    super.key,
    required this.reportData,
  });

  @override
  Widget build(BuildContext context) {
    final monthKeys = reportData.monthlyTotals.keys.toList()..sort();

    // ✅ استخراج السنة من أول شهر موجود
    final year = monthKeys.isNotEmpty
        ? monthKeys.first.split('-').first
        : DateTime.now().year.toString();

    // ✅ توليد كل شهور السنة (12 شهر)
    final allMonths = List.generate(
      12,
          (index) => '$year-${(index + 1).toString().padLeft(2, '0')}',
    );

    // ✅ القيم لكل شهر (الموجودين بس، والباقي 0)
    final Map<String, double> allMonthlyValues = {};
    for (var month in allMonths) {
      allMonthlyValues[month] = reportData.monthlyTotals[month] ?? 0.0;
    }

    // ✅ القيم كـ List
    final months = allMonths.map((e) => allMonthlyValues[e] ?? 0).toList();

    // ✅ أكبر قيمة من كل الشهور
    final maxMonth = months.isEmpty
        ? 1.0
        : months.reduce((a, b) => a > b ? a : b);

    return Scaffold(
      backgroundColor: AppColors.slateBg,
      appBar: GradientAppBar(
        title: "revenue_analysis_monthly".tr(),
        subtitle: reportData.monthlyTotals.isEmpty
            ? ""
            : "${formatMonth(reportData.monthlyTotals.keys.first)} - ${formatMonth(reportData.monthlyTotals.keys.last)}",
        onBack: () => Navigator.of(context).maybePop(),
        actions: [
          AppBarIconButton(
            icon: Icons.print,
            onTap: () {},
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 10.h),
        children: [
          Container(
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: Colors.white, // ✅ خلفية بيضاء
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: AppColors.teal.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "total_revenue".tr(),
                          style: TextStyle(
                            color: AppColors.textMuted, // ✅ لون رمادي
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(width: 25.w),
                        Text(
                          formatNumber(reportData.grandTotal),
                          style: TextStyle(
                            color: AppColors.teal, // ✅ لون أخضر (teal)
                            fontWeight: FontWeight.w800,
                            fontSize: 24.sp,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.teal.withOpacity(0.1), // ✅ خلفية خضراء فاتحة
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Text(
                        "${reportData.accounts.length}",
                        style: TextStyle(
                          color: AppColors.teal, // ✅ لون أخضر
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),

                // ✅ Monthly Chart - 12 شهر كاملين
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // الأعمدة
                    SizedBox(
                      height: 50.h,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: allMonths.asMap().entries.map((entry) {
                          final month = entry.value;
                          final value = allMonthlyValues[month] ?? 0;
                          final h = maxMonth == 0
                              ? 6.h
                              : (value / maxMonth * 36.h).clamp(6.0, 36.h);

                          // ✅ تمييز الشهور اللي فيها قيم
                          final hasValue = value > 0;

                          return Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: h,
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                                  decoration: BoxDecoration(
                                    color: hasValue
                                        ? AppColors.teal.withOpacity(0.85) // ✅ أخضر غامق
                                        : AppColors.teal.withOpacity(0.15), // ✅ أخضر فاتح
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(3.r),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // ✅ أرقام الشهور
                    Row(
                      children: allMonths.map((monthKey) {
                        final hasValue = (allMonthlyValues[monthKey] ?? 0) > 0;
                        final monthNumber = _getMonthNumber(monthKey);

                        return Expanded(
                          child: Text(
                            monthNumber,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 9.sp,
                              color: hasValue
                                  ? AppColors.teal.withOpacity(0.8) // ✅ أخضر غامق
                                  : AppColors.teal.withOpacity(0.25), // ✅ أخضر فاتح
                              fontWeight: hasValue ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          for (final account in reportData.accounts)
            ExpandableAccountCard(
              name: account.accountName,
              code: '',
              total: account.total,
              months: account.periodValues.entries
                  .map(
                    (e) => MonthValue(
                  e.key,
                  e.value,
                ),
              )
                  .toList(),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
          decoration: const BoxDecoration(color: AppColors.textDark),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "total_7_months".tr(),
                style: TextStyle(color: Colors.white70, fontSize: 12.sp),
              ),
              Text(
                formatNumber(reportData.grandTotal),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 15.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ دالة مساعدة لاختصار اسم الشهر
  String _getShortMonthName(String monthKey) {
    try {
      final parts = monthKey.split('-');
      if (parts.length == 2) {
        final month = int.parse(parts[1]);
        const shortMonths = [
          'ينا',
          'فبر',
          'مار',
          'أبر',
          'ماي',
          'يون',
          'يول',
          'أغس',
          'سبت',
          'أكت',
          'نوف',
          'ديس'
        ];
        return shortMonths[month - 1];
      }
    } catch (e) {
      return monthKey;
    }
    return monthKey;
  }
}

// دالة formatMonth (نفسها موجودة في مكان آخر)
String formatMonth(String value) {
  final date = DateTime.parse("$value-01");

  const months = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];

  return months[date.month - 1];
}
String _getMonthNumber(String monthKey) {
  try {
    final parts = monthKey.split('-');
    if (parts.length == 2) {
      final month = int.parse(parts[1]);
      return month.toString(); // ✅ رقم الشهر
    }
  } catch (e) {
    return monthKey;
  }
  return monthKey;
}