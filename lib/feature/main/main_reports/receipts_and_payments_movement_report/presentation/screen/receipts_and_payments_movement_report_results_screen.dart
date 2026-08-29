import 'package:easy_localization/easy_localization.dart';
import '../../receipts_and_payments_movement_report_import.dart';

class ReceiptsAndPaymentsMovementReportResultsScreen extends StatelessWidget {
  final EtMovementReportResponseModel reportData;

  const ReceiptsAndPaymentsMovementReportResultsScreen({
    super.key,
    required this.reportData,
  });

  @override
  Widget build(BuildContext context) {
    final items = reportData.data;
    final totalReceipts = reportData.totalReceipt;
    final totalPayments = reportData.totalPayment;
    final net = totalReceipts - totalPayments;
    final hasData = items.isNotEmpty;

    // ✅ لو فيه رسالة من الـ API (زي "لا توجد قيود")
    if (reportData.message != null && reportData.message!.isNotEmpty && !hasData) {
      return _buildEmptyState(context, reportData.message!);
    }

    // ✅ لو مفيش بيانات
    if (!hasData) {
      return _buildEmptyState(context, "no_data_available".tr());
    }

    return Scaffold(
      backgroundColor: AppColors.slateBg,
      appBar: GradientAppBar(
        title: "receipts_and_payments_movement".tr(),
        subtitle: _getDateRange(items),
        onBack: () => Navigator.of(context).maybePop(),
        actions: [
          AppBarIconButton(icon: Icons.print, onTap: () {}),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 10.h),
        children: [
          // ============================================================
          // 📋 ملخص السجلات
          // ============================================================
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
                  "${items.length} ${"records".tr()}",
                  style: TextStyle(fontSize: 11.5.sp, color: AppColors.textMuted),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: AppColors.brandLight,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    _getDateRange(items),
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

          // ============================================================
          // 📊 إجمالي القبض والصرف
          // ============================================================
          Row(
            children: [
              // ✅ إجمالي القبض (أخضر)
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(13.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.teal, Color(0xFF0E8A70)],
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "total_receipt".tr(),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: 10.5.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        formatNumber(totalReceipts, decimals: 3),
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
              SizedBox(width: 10.w),

              // ✅ إجمالي الصرف (أحمر)
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(13.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.red, Color(0xFFA32D28)],
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "total_payment".tr(),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: 10.5.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        formatNumber(totalPayments, decimals: 3),
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
            ],
          ),
          SizedBox(height: 16.h),

          // ============================================================
          // 📋 قائمة السندات
          // ============================================================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "vouchers".tr(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.5.sp,
                  color: AppColors.brandDark,
                ),
              ),
              Text(
                "${items.length} ${"of".tr()} ${items.length}",
                style: TextStyle(
                  fontSize: 10.5.sp,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          // ✅ عرض السندات
          for (final item in items) _VoucherCard(item: item),
        ],
      ),

      // ============================================================
      // 📌 Bottom Bar - صافي الحركة
      // ============================================================
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 18.h),
          decoration: const BoxDecoration(color: AppColors.textDark),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "net_movement".tr(),
                style: TextStyle(color: Colors.white70, fontSize: 12.sp),
              ),
              Text(
                "${net >= 0 ? '+' : ''}${formatNumber(net, decimals: 3)}",
                style: TextStyle(
                  color: net >= 0 ? const Color(0xFF8FE3C7) : AppColors.red,
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

  // ============================================================
  // ✅ Empty State
  // ============================================================
  Widget _buildEmptyState(BuildContext context, String message) {
    return Scaffold(
      backgroundColor: AppColors.slateBg,
      appBar: GradientAppBar(
        title: "receipts_and_payments_movement".tr(),
        onBack: () => Navigator.of(context).maybePop(),
        actions: [
          AppBarIconButton(icon: Icons.print, onTap: () {}),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 80.sp,
                color: AppColors.textMuted.withOpacity(0.5),
              ),
              SizedBox(height: 16.h),
              Text(
                message,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                "no_vouchers_found".tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.arrow_back, size: 18.sp),
                label: Text("back_to_filters".tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brand,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ✅ Helper Methods
  // ============================================================

  String _getDateRange(List<EtMovementItem> items) {
    if (items.isEmpty) return '';

    final dates = items.map((e) => e.etDate).toList()..sort();
    if (dates.isEmpty) return '';

    final first = DateFormat('dd-MM-yyyy').format(dates.first);
    final last = DateFormat('dd-MM-yyyy').format(dates.last);

    return "$first - $last";
  }
}

// ============================================================
// 📋 Voucher Card (قابل للطي)
// ============================================================
class _VoucherCard extends StatefulWidget {
  final EtMovementItem item;

  const _VoucherCard({required this.item});

  @override
  State<_VoucherCard> createState() => _VoucherCardState();
}

class _VoucherCardState extends State<_VoucherCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    // ✅ تحديد نوع السند: قبض (receipt) أم صرف (payment)
    final isReceipt = item.entryType == 11 || item.entryType == 12; // 11=نقدي, 12=بنكي
    final isPayment = item.entryType == 21 || item.entryType == 22; // 21=نقدي, 22=بنكي

    final accent = isReceipt ? AppColors.teal : AppColors.red;
    final accentBg = isReceipt ? AppColors.tealBg : AppColors.redBg;
    final icon = isReceipt ? Icons.south_west : Icons.north_east;
    final sign = isReceipt ? '+' : '-';

    return Container(
      margin: EdgeInsets.only(top: 10.h),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.line),
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
                  // ✅ أيقونة النوع
                  Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: accentBg,
                      borderRadius: BorderRadius.circular(11.r),
                    ),
                    child: Icon(icon, color: accent, size: 18.sp),
                  ),
                  SizedBox(width: 10.w),

                  // ✅ معلومات السند
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              item.arName,
                              style: TextStyle(
                                fontSize: 12.5.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              "#${item.etNumber}",
                              style: TextStyle(
                                fontSize: 10.5.sp,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          item.acName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textMuted,
                          ),
                        ),
                        // ✅ نوع السند (نقدي / بنكي)
                        Container(
                          margin: EdgeInsets.only(top: 3.h),
                          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: isReceipt ? AppColors.tealBg : AppColors.redBg,
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                          child: Text(
                            isReceipt ? "receipt".tr() : "payment".tr(),
                            style: TextStyle(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                              color: accent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ✅ المبلغ والتاريخ
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "$sign${formatNumber(item.balance, decimals: 3)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5.sp,
                          color: accent,
                        ),
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy').format(item.etDate),
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColors.textMuted,
                        ),
                      ),
                      Icon(
                        _open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        size: 16.sp,
                        color: AppColors.textMuted,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ✅ تفاصيل السند (عند التوسيع)
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
                  _detailRow("voucher_type".tr(), item.arName),
                  _detailRow("voucher_number".tr(), item.etNumber.toString()),
                  _detailRow("date".tr(), DateFormat('dd/MM/yyyy').format(item.etDate)),
                  _detailRow("account".tr(), item.acName),
                  _detailRow("balance".tr(), formatNumber(item.balance, decimals: 3)),
                  if (item.chkNum != null && item.chkNum!.isNotEmpty)
                    _detailRow("check_number".tr(), item.chkNum!),
                  if (item.chkDate != null)
                    _detailRow("due_date".tr(), DateFormat('dd/MM/yyyy').format(item.chkDate!)),
                  if (item.empName != null && item.empName!.isNotEmpty)
                    _detailRow("rep_name".tr(), item.empName!),
                  if (item.receivedFrom != null && item.receivedFrom!.isNotEmpty)
                    _detailRow("received_from".tr(), item.receivedFrom!),
                  if (item.deliveredTo != null && item.deliveredTo!.isNotEmpty)
                    _detailRow("delivered_to".tr(), item.deliveredTo!),
                  if (item.coName != null && item.coName!.isNotEmpty)
                    _detailRow("cost_center".tr(), item.coName!),
                  if (item.notes != null && item.notes!.isNotEmpty)
                    _detailRow("notes".tr(), item.notes!),
                  _detailRow("posted".tr(), item.isPost ? "yes".tr() : "no".tr()),
                ],
              ),
            )
                : const SizedBox(width: double.infinity, height: 0),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String name, String value) {
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
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}