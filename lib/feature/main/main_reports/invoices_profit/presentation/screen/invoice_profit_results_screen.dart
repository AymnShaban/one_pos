

import 'package:easy_localization/easy_localization.dart';

import '../../invoice_profit_imports.dart';

class InvoiceProfitResultsScreen extends StatelessWidget {
  final InvoiceProfitResponseModel reportData;

  const InvoiceProfitResultsScreen({
    super.key,
    required this.reportData,
  });

  @override
  Widget build(BuildContext context) {
    final invoices = reportData.rows;


    final totalSum = reportData.totalSum;
    final costSum = reportData.costSum;
    final benifitSum = reportData.benifitSum;
    final finalSum = reportData.finalSum;
    final recordCount = invoices.length;

    return Scaffold(
      backgroundColor: AppColors.slateBg,
      appBar: GradientAppBar(
        title: "invoice_profits".tr(),
        subtitle: "${"from".tr()} ${_getDateRange(invoices)}",
        onBack: () => Navigator.of(context).maybePop(),
        actions: [
          AppBarIconButton(icon: Icons.print, onTap: () {}),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 10.h),
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 9.h),
            margin: EdgeInsets.only(bottom: 12.h),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.line),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getDateRange(invoices),
                  style: TextStyle(fontSize: 11.5.sp, color: AppColors.textMuted),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: AppColors.brandLight,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    "$recordCount ${"records".tr()}",
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.brandDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
          KpiGrid(items: [
            KpiItem(
              label: "total".tr(),
              value: formatNumber(totalSum, decimals: 3),
            ),
            KpiItem(
              label: "cost".tr(),
              value: formatNumber(costSum, decimals: 3),
            ),
            KpiItem(
              label: "profits".tr(),
              value: formatNumber(benifitSum, decimals: 3),
              valueColor: AppColors.teal,
            ),
            KpiItem(
              label: "net_profit".tr(),
              value: formatNumber(finalSum, decimals: 3),
              valueColor: finalSum < 0 ? AppColors.red : AppColors.teal,
            ),
          ]),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "invoice_detail".tr(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.5.sp,
                  color: AppColors.brandDark,
                ),
              ),
              Text(
                "${invoices.length} ${"of".tr()} $recordCount",
                style: TextStyle(
                  fontSize: 10.5.sp,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          for (final inv in invoices) _InvoiceCard(invoice: inv),
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
                "total_summary".tr(),
                style: TextStyle(color: Colors.white70, fontSize: 12.sp),
              ),
              Row(
                children: [
                  Text(
                    formatNumber(totalSum, decimals: 3),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    "${"net".tr()} ${formatNumber(finalSum, decimals: 3)}",
                    style: TextStyle(
                      color: finalSum < 0 ? AppColors.red : const Color(0xFFF5CAC6),
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDateRange(List<InvoiceProfitItem> invoices) {
    if (invoices.isEmpty) return '';

    // استخراج التواريخ من dateDisplay
    final dates = invoices.map((e) => e.dateDisplay).toList()..sort();

    if (dates.isEmpty) return '';

    final first = dates.first;
    final last = dates.last;

    return "$first - $last";
  }
}

class _InvoiceCard extends StatefulWidget {
  final InvoiceProfitItem invoice;

  const _InvoiceCard({required this.invoice});

  @override
  State<_InvoiceCard> createState() => _InvoiceCardState();
}

class _InvoiceCardState extends State<_InvoiceCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final inv = widget.invoice;
    final isLoss = inv.benifit < 0 || inv.finalProfit < 0;

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
                        Row(
                          children: [



                            Text(
                              "${'bill_no'.tr()} #${inv.blNo}",
                              style: TextStyle(
                                fontSize: 12.5.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.brandDark,
                              ),
                            ),
                            SizedBox(width: 8.w),

                            Icon(
                              Icons.calendar_today_outlined,
                              size: 10.sp,
                              color: AppColors.textMuted,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              inv.dateDisplay,
                              style: TextStyle(
                                fontSize: 10.5.sp,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),

                        Text(
                          inv.billType,
                          style: TextStyle(
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.brandDark,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: isLoss ? AppColors.redBg : AppColors.tealBg,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isLoss ? Icons.trending_down : Icons.trending_up,
                              size: 12.sp,
                              color: isLoss ? AppColors.red : AppColors.teal,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              formatNumber(inv.benifit, decimals: 3),
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: isLoss ? AppColors.red : AppColors.teal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4.h),

                      Text(
                        formatNumber(inv.total, decimals: 3),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          color: AppColors.textDark,
                        ),
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

                  _detailRow(
                    "customer_name".tr(),
                    inv.acName,
                  ),

                  _detailRow(
                    "total".tr(),
                    formatNumber(inv.total, decimals: 3),
                  ),

                  _detailRow(
                    "discount".tr(),
                    formatNumber(inv.disc, decimals: 3),
                  ),

                  _detailRow(
                    "extra".tr(),
                    formatNumber(inv.extra, decimals: 3),
                  ),

                  _detailRow(
                    "cost".tr(),
                    formatNumber(inv.cost, decimals: 3),
                  ),

                  _detailRow(
                    "net_value".tr(),
                    formatNumber(inv.netValue, decimals: 3),
                  ),

                  _detailRow(
                    "net_profit".tr(),
                    formatNumber(inv.finalProfit, decimals: 3),
                    color: inv.finalProfit < 0 ? AppColors.red : AppColors.teal,
                  ),

                  _detailRow(
                    "cost_profit_percentage".tr(),
                    inv.costProfitsPercentage,
                  ),

                  if (inv.isReturn) ...[
                    _detailRow(
                      "return".tr(),
                      "yes".tr(),
                      color: AppColors.red,
                    ),
                  ],
                ],
              ),
            )
                : const SizedBox(width: double.infinity, height: 0),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String name, String value, {Color? color}) {
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
              fontWeight: FontWeight.w600,
              color: color ?? AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}





