import 'package:easy_localization/easy_localization.dart';
import '../../expense_analysis_imports.dart';

class ExpenseAnalysisResultsScreen extends StatefulWidget {
  final ExpenseReportResponseModel reportData;

  const ExpenseAnalysisResultsScreen({
    super.key,
    required this.reportData,
  });

  @override
  State<ExpenseAnalysisResultsScreen> createState() =>
      _ExpenseAnalysisResultsScreenState();
}

class _ExpenseAnalysisResultsScreenState
    extends State<ExpenseAnalysisResultsScreen> {
  int visibleCount = 4;

  @override
  Widget build(BuildContext context) {
    final report = widget.reportData;
    final accounts = report.accounts;
    final monthlyTotals = report.monthlyTotals;
    final sortedMonths = monthlyTotals.keys.toList()..sort();

    final year = sortedMonths.isNotEmpty
        ? sortedMonths.first.split('-').first
        : DateTime.now().year.toString();

    final allMonths = List.generate(
      12,
          (index) => '$year-${(index + 1).toString().padLeft(2, '0')}',
    );

    final Map<String, double> allMonthlyValues = {};
    for (var month in allMonths) {
      allMonthlyValues[month] = monthlyTotals[month] ?? 0.0;
    }


    final maxMonth = allMonthlyValues.values.isNotEmpty
        ? allMonthlyValues.values.reduce((a, b) => a > b ? a : b)
        : 0.0;

    final visible = accounts.take(visibleCount).toList();
    final totalMonths = allMonths.length;

    return Scaffold(
      backgroundColor: AppColors.slateBg,
      appBar: GradientAppBar(
        title: "expense_analysis_monthly".tr(),
        subtitle: _getDateRange(sortedMonths),
        onBack: () => Navigator.of(context).pop(),
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
                color: AppColors.red.withOpacity(0.2),
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
                  children: [
                    Text(
                      "total_expenses".tr(),
                      style: TextStyle(
                        color: AppColors.textMuted, // ✅ لون رمادي
                        fontSize: 12.sp,
                      ),
                    ),
                    Text(
                      formatNumber(report.grandTotal, decimals: 3),
                      style: TextStyle(
                        color: AppColors.red, // ✅ لون أحمر
                        fontWeight: FontWeight.w800,
                        fontSize: 24.sp,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: AppColors.red.withOpacity(0.1), // ✅ خلفية حمراء فاتحة
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Text(
                        "$totalMonths ${"months".tr()}",
                        style: TextStyle(
                          color: AppColors.red, // ✅ لون أحمر
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),

                // 📊 الأعمدة
                SizedBox(
                  height: 36.h,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: allMonths.asMap().entries.map((entry) {
                      final month = entry.value;
                      final value = allMonthlyValues[month] ?? 0;
                      final h = maxMonth > 0
                          ? (value / maxMonth * 36.h).clamp(2.0.h, 36.0.h)
                          : 0.0;

                      final hasValue = value > 0;

                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 1.w),
                          height: h,
                          decoration: BoxDecoration(
                            color: hasValue
                                ? AppColors.red.withOpacity(0.85) // ✅ أحمر غامق
                                : AppColors.red.withOpacity(0.15), // ✅ أحمر فاتح جداً
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(3.r),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 6.h),

                // 📝 أرقام الشهور
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: allMonths.map((month) {
                    final monthNumber = _getMonthNumber(month);
                    final hasValue = (allMonthlyValues[month] ?? 0) > 0;

                    return Text(
                      monthNumber,
                      style: TextStyle(
                        color: hasValue
                            ? AppColors.red.withOpacity(0.8) // ✅ أحمر غامق
                            : AppColors.red.withOpacity(0.25), // ✅ أحمر فاتح
                        fontSize: 8.sp,
                        fontWeight: hasValue ? FontWeight.w600 : FontWeight.normal,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),


          for (final account in visible)
            _ExpenseAccountCard(
              account: account,
              sortedMonths: sortedMonths,
              maxMonth: maxMonth,
            ),

          if (visibleCount < accounts.length)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Center(
                child: TextButton(
                  onPressed: () => setState(
                        () => visibleCount =
                        (visibleCount + 4).clamp(0, accounts.length),
                  ),
                  child: Text(
                    "show_more".tr(),
                    style: TextStyle(
                      color: AppColors.brandDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 18.h),
          decoration: const BoxDecoration(color: AppColors.textDark),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "total_expenses".tr(),
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12.sp,
                ),
              ),
              Text(
                formatNumber(report.grandTotal, decimals: 3),
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

  String _getDateRange(List<String> sortedMonths) {
    if (sortedMonths.isEmpty) return '';
    final first = sortedMonths.first;
    final last = sortedMonths.last;
    final firstParts = first.split('-');
    final lastParts = last.split('-');
    if (firstParts.length == 2 && lastParts.length == 2) {
      final firstMonth = int.parse(firstParts[1]);
      final lastMonth = int.parse(lastParts[1]);
      final year = firstParts[0];
      return '${_getMonthName(firstMonth)} - ${_getMonthName(lastMonth)} ';
    }
    return '';
  }

  String _getMonthName(int month) {
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
      'ديسمبر'
    ];
    return months[month - 1];
  }

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

// ============================================================
// EXPENSE ACCOUNT CARD (Expandable with Chart)
// ============================================================
class _ExpenseAccountCard extends StatefulWidget {
  final ExpenseAccountReportModel account;
  final List<String> sortedMonths;
  final double maxMonth;

  const _ExpenseAccountCard({
    required this.account,
    required this.sortedMonths,
    required this.maxMonth,
  });

  @override
  State<_ExpenseAccountCard> createState() => _ExpenseAccountCardState();
}

class _ExpenseAccountCardState extends State<_ExpenseAccountCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final account = widget.account;
    final sortedMonths = widget.sortedMonths;
    final maxMonth = widget.maxMonth;
    final isLoss = account.total < 0;

    return Container(
      margin: EdgeInsets.only(top: 10.h),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isLoss ? const Color(0xFFF3CBC6) : AppColors.line,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _open = !_open),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.h),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          account.accountName,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.brandDark,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          account.total.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        "${account.total > 0 ? ' ' : ''}${formatNumber(account.total, decimals: 3)}",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        _open ? Icons.expand_less : Icons.expand_more,
                        color: AppColors.textMuted,
                        size: 20.sp,
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
              padding: EdgeInsets.fromLTRB(13.w, 8.h, 13.w, 12.h),
              decoration: const BoxDecoration(
                color: Color(0xFFFAFBFD),
                border: Border(top: BorderSide(color: AppColors.line)),
              ),
              child: Column(
                children: [
                  ...sortedMonths.map((month) {
                    final value = account.periodValues[month] ?? 0;
                    final monthName = _getMonthName(month);
                    return _detailRow(
                      monthName,
                      formatNumber(value, decimals: 3),
                    );
                  }),
                ],
              ),
            )
                : const SizedBox(width: double.infinity, height: 0),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String name, String value, {Color? color, bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 11.5.sp,
              color: AppColors.textMuted,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11.5.sp,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
              color: color ?? AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(String monthKey) {
    try {
      final parts = monthKey.split('-');
      if (parts.length == 2) {
        final month = int.parse(parts[1]);
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
          'ديسمبر'
        ];
        final year = parts[0];
        return '${months[month - 1]} $year';
      }
    } catch (e) {
      return monthKey;
    }
    return monthKey;
  }
}// ✅ دالة لاستخراج رقم الشهر من المفتاح
String _getMonthNumber(String monthKey) {
  try {
    final parts = monthKey.split('-');
    if (parts.length == 2) {
      final month = int.parse(parts[1]);
      return month.toString();
    }
  } catch (e) {
    return monthKey;
  }
  return monthKey;
}