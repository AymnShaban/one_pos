import 'package:easy_localization/easy_localization.dart';


import '../../../../../core/helper/helper.dart';
import '../../../../../core/widgets/gradient_app_bar.dart';
import '../../../../../core/widgets/kpi_grid.dart';
import '../../data/models/customer_account_response_model.dart';

class ClientStatementResultsScreen extends StatelessWidget {
  final CustomerAccountStatementResponseModel statementData;
  final String clientName;
  final DateTime fromDate;
  final DateTime toDate;

  const ClientStatementResultsScreen({
    super.key,
    required this.statementData,
    required this.clientName,
    required this.fromDate,
    required this.toDate,
  });

  @override
  Widget build(BuildContext context) {
    final items = statementData.customerAccountsReportResultDtos;

    return Scaffold(
      backgroundColor: AppColors.slateBg,
      appBar: GradientAppBar(
        title: "client_statement".tr(),
        subtitle: statementData.acName ?? clientName,
        onBack: () => Navigator.of(context).maybePop(),
        accentIcon: Container(
          width: 34.w,
          height: 34.h,
          decoration: BoxDecoration(
            color: AppColors.blue,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            Icons.account_balance,
            color: AppColors.whiteColor,
            size: 16.sp,
          ),
        ),
        actions: [
          AppBarIconButton(
            icon: Icons.print,
            onTap: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 10.h),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSummaryHeader(items),
                _buildKpiGrid(items),
                SizedBox(height: 16.h),
                _buildSectionHeader(items),
                _buildOpeningBalanceCard(items),
              ]),
            ),
          ),

          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return _TransactionCard(
                    item: items[index],
                    index: index,
                    isLast: index == items.length - 1,
                  );
                },
                childCount: items.length,
              ),
            ),
          ),

          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 10.h),
            sliver: SliverToBoxAdapter(
              child: _buildClosingBalanceCard(items),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(items),
    );
  }

  // ==================== SUMMARY HEADER ====================

  Widget _buildSummaryHeader(List<CustomerAccountStatementItemModel> items) {
    return Container(
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
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 14.sp,
                color: AppColors.textMuted,
              ),
              SizedBox(width: 6.w),
              Text(
                '${_formatDate(fromDate)} - ${_formatDate(toDate)}',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: AppColors.brandLight,
              borderRadius: BorderRadius.circular(999.r),
            ),
            child: Text(
              "${items.length} ${'transactions'.tr()}",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.brandDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== KPI GRID ====================

  Widget _buildKpiGrid(List<CustomerAccountStatementItemModel> items) {
    final totalDebit = items.fold<double>(
      0.0,
          (sum, item) => sum + (double.tryParse(item.debit ?? '0') ?? 0.0),
    );
    final totalCredit = items.fold<double>(
      0.0,
          (sum, item) => sum + (double.tryParse(item.credit ?? '0') ?? 0.0),
    );
    final firstBalance = double.tryParse(items.first.balance ?? '0') ?? 0.0;
    final lastBalance = double.tryParse(items.last.balance ?? '0') ?? 0.0;

    return KpiGrid(items: [
      KpiItem(
        label: "opening_balance".tr(),
        value: _formatCurrency(firstBalance),
        valueColor: firstBalance >= 0 ? AppColors.green : AppColors.red,
      ),
      KpiItem(
        label: "total_debit".tr(),
        value: _formatCurrency(totalDebit),
        valueColor: AppColors.red,
      ),
      KpiItem(
        label: "total_credit".tr(),
        value: _formatCurrency(totalCredit),
        valueColor: AppColors.green,
      ),
      KpiItem(
        label: "closing_balance".tr(),
        value: _formatCurrency(lastBalance),
        valueColor: lastBalance >= 0 ? AppColors.green : AppColors.red,
      ),
    ]);
  }

  // ==================== SECTION HEADER ====================

  Widget _buildSectionHeader(List<CustomerAccountStatementItemModel> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "transactions".tr(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
            color: AppColors.brandDark,
          ),
        ),
        Text(
          "${items.length} ${'transactions'.tr()}",
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ==================== OPENING BALANCE CARD ====================

  Widget _buildOpeningBalanceCard(List<CustomerAccountStatementItemModel> items) {
    final firstBalance = double.tryParse(items.first.balance ?? '0') ?? 0.0;

    return Container(
      margin: EdgeInsets.only(top: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.amberBg.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.amber.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance,
                size: 18.sp,
                color: AppColors.amber,
              ),
              SizedBox(width: 8.w),
              Text(
                'opening_balance'.tr(),
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          Text(
            _formatCurrency(firstBalance),
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: firstBalance >= 0 ? AppColors.green : AppColors.red,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== CLOSING BALANCE CARD ====================

  Widget _buildClosingBalanceCard(List<CustomerAccountStatementItemModel> items) {
    final lastBalance = double.tryParse(items.last.balance ?? '0') ?? 0.0;

    return Container(
      margin: EdgeInsets.only(top: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.blueBg.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.blue.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance,
                size: 18.sp,
                color: AppColors.blue,
              ),
              SizedBox(width: 8.w),
              Text(
                'closing_balance'.tr(),
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          Text(
            _formatCurrency(lastBalance),
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: lastBalance >= 0 ? AppColors.green : AppColors.red,
            ),
          ),
        ],
      ),
    );
  }




  // ==================== BOTTOM BAR ====================

  Widget _buildBottomBar(List<CustomerAccountStatementItemModel> items) {
    final totalDebit = items.fold<double>(
      0.0,
          (sum, item) => sum + (double.tryParse(item.debit ?? '0') ?? 0.0),
    );
    final totalCredit = items.fold<double>(
      0.0,
          (sum, item) => sum + (double.tryParse(item.credit ?? '0') ?? 0.0),
    );
    final netBalance = totalCredit - totalDebit;

    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 18.h),
        decoration: const BoxDecoration(color: AppColors.textDark),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  netBalance >= 0 ? Icons.trending_up : Icons.trending_down,
                  color: netBalance >= 0 ? const Color(0xFF8FE3C7) : Colors.redAccent,
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  "net_movement".tr(),
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
            Text(
              _formatCurrency(netBalance),
              style: TextStyle(
                color: netBalance >= 0 ? const Color(0xFF8FE3C7) : Colors.redAccent,
                fontWeight: FontWeight.w800,
                fontSize: 17.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== HELPERS ====================

  String _formatCurrency(double amount) {
    return NumberFormat('#,##0.000', 'en_US').format(amount);
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}

// ==================== TRANSACTION CARD ====================

class _TransactionCard extends StatefulWidget {
  final CustomerAccountStatementItemModel item;
  final int index;
  final bool isLast;

  const _TransactionCard({
    required this.item,
    required this.index,
    required this.isLast,
  });

  @override
  State<_TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<_TransactionCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final debit = double.tryParse(item.debit ?? '0') ?? 0.0;
    final credit = double.tryParse(item.credit ?? '0') ?? 0.0;
    final balance = double.tryParse(item.balance ?? '0') ?? 0.0;
    final date = _parseDate(item.date);

    // تحديد نوع الحركة
    final isDebit = debit > 0;
    final isCredit = credit > 0;
    final isOpeningBalance = item.notes?.contains('الرصــــيد الســــابق') ?? false;

    return  GestureDetector(
      onTap: () => setState(() => _open = !_open),
      child: Container(
        margin: EdgeInsets.only(top: 8.h),
        decoration: BoxDecoration(
          color: AppColors.card, // ✅ لون واحد لكل الكاردات
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.h),
              child: Row(
                children: [
                  // السهم يوضح نوع الحركة
                  Container(
                    width: 30.w,
                    height: 30.h,
                    decoration: BoxDecoration(
                      color: isDebit ? AppColors.redBg : (isCredit ? AppColors.greenBg : AppColors.blueBg),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      isDebit ? Icons.arrow_downward : (isCredit ? Icons.arrow_upward : Icons.remove),
                      color: isDebit ? AppColors.red : (isCredit ? AppColors.green : AppColors.blue),
                      size: 18.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),

                  // الاسم ورقم المستند
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isOpeningBalance ? 'الرصيد الافتتاحي' : (item.document ?? '-'),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          isOpeningBalance ? '' : (item.notes ?? ''),
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textMuted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // المبلغ
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          isDebit ? _formatCurrency(debit) : (isCredit ? _formatCurrency(credit) : '-'),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: isDebit ? AppColors.red : (isCredit ? AppColors.green : AppColors.textMuted),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          date != null ? _formatDate(date) : '',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // سهم التوسيع
                  Icon(
                    _open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 24.w,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),

            // ==================== DETAILS SECTION (زي ما كانت) ====================
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: _open
                  ? Container(
                width: double.infinity,
                color: AppColors.backgroundColor,
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [

                    _buildDetailRow(
                      icon: Icons.receipt_long,
                      label: 'doc_no'.tr(),
                      value: item.document ?? '-',
                      iconColor: AppColors.blue,
                    ),
                    _buildDetailRow(
                      icon: Icons.calendar_today,
                      label: 'date'.tr(),
                      value: date != null ? _formatDate(date) : '-',
                      iconColor: AppColors.orange,
                    ),
                    if (debit > 0)
                      _buildDetailRow(
                        icon: Icons.arrow_downward,
                        label: 'debit'.tr(),
                        value: _formatCurrency(debit),
                        iconColor: AppColors.red,
                        valueColor: AppColors.red,
                      ),
                    if (credit > 0)
                      _buildDetailRow(
                        icon: Icons.arrow_upward,
                        label: 'credit'.tr(),
                        value: _formatCurrency(credit),
                        iconColor: AppColors.green,
                        valueColor: AppColors.green,
                      ),
                    _buildDetailRow(
                      icon: Icons.account_balance,
                      label: 'balance'.tr(),
                      value: _formatCurrency(balance),
                      iconColor: balance >= 0 ? AppColors.green : AppColors.red,
                      valueColor: balance >= 0 ? AppColors.green : AppColors.red,
                    ),
                    if (item.notes != null && item.notes!.isNotEmpty && !item.notes!.contains('الرصيد'))
                      _buildDetailRow(
                        icon: Icons.note,
                        label: 'notes'.tr(),
                        value: item.notes!,
                        iconColor: AppColors.purple,
                      ),
                  ],
                ),
              )
                  : const SizedBox(width: double.infinity, height: 0),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== DETAIL ROW (عمود واحد) ====================

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          // الأيقونة
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(
              icon,
              size: 16.sp,
              color: iconColor,
            ),
          ),
          SizedBox(width: 12.w),

          // التسمية (Label)
          SizedBox(
            width: 80.w, // عرض ثابت للتسمية عشان تكون منتظمة
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),


          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: valueColor ?? AppColors.textDark,
              ),
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== HELPERS ====================

  String _formatCurrency(double amount) {
    return NumberFormat('#,##0.000', 'en_US').format(amount);
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  DateTime? _parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      final formats = [
        'dd / MM / yyyy',
        'dd/MM/yyyy',
        'yyyy-MM-dd',
        'MM/dd/yyyy',
        'yyyy-MM-ddTHH:mm:ss',
        'yyyy-MM-ddTHH:mm:ss.SSS',
      ];

      for (var format in formats) {
        try {
          return DateFormat(format).parse(dateString.trim());
        } catch (_) {}
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}