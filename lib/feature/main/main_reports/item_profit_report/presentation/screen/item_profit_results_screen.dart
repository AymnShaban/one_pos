import 'package:easy_localization/easy_localization.dart';

import '../../../invoices_profit/invoice_profit_imports.dart';

import '../../data/models/item_profit_response_model.dart';

class ItemProfitResultsScreen extends StatelessWidget {
  final ItemProfitResponseModel reportData;

  const ItemProfitResultsScreen({
    super.key,
    required this.reportData,
  });

  @override
  Widget build(BuildContext context) {
    final invoices = _getAllBills();

    return Scaffold(
      backgroundColor: AppColors.slateBg,
      appBar: GradientAppBar(
        title: "item_profit_results".tr(),
        subtitle: _getDateRange(),
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
          // Summary Header
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
                  _getDateRange(),
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    color: AppColors.textMuted,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: AppColors.brandLight,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    "${invoices.length} ${'bills'.tr()}",
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

          // KPI Grid
          KpiGrid(items: [
            KpiItem(
              label: "total_value".tr(),
              value: formatNumber(reportData.totalValue, decimals: 3),
            ),
            KpiItem(
              label: "total_cost".tr(),
              value: formatNumber(reportData.totalCost, decimals: 3),
            ),
            KpiItem(
              label: "total_qty".tr(),
              value: formatNumber(reportData.totalQty, decimals: 3),
            ),


            KpiItem(
              label: "total_profit".tr(),
              value: formatNumber(reportData.totalProfit, decimals: 3),
              valueColor: AppColors.teal,
            ),
          ]),

          SizedBox(height: 16.h),

          // Bills Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "bills".tr(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.5.sp,
                  color: AppColors.brandDark,
                ),
              ),
              Text(
                "${invoices.length} ${'bills'.tr()}",
                style: TextStyle(
                  fontSize: 10.5.sp,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          // Bills List
          for (final bill in invoices) _InvoiceExpansionCard(bill: bill),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 18.h),
        decoration: const BoxDecoration(color: AppColors.textDark),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "total_profit".tr(),
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12.sp,
              ),
            ),
            Text(
              formatNumber(reportData.totalProfit, decimals: 3),
              style: TextStyle(
                color: const Color(0xFF8FE3C7),
                fontWeight: FontWeight.w800,
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BillModel> _getAllBills() {
    final List<BillModel> allBills = [];
    for (final branch in reportData.branchGroups) {
      allBills.addAll(branch.bills);
    }
    return allBills;
  }

  String _getDateRange() {
    return "${formatDate(reportData.startDate)} ${'to'.tr()} ${formatDate(reportData.endDate)}";
  }

  String formatDate(String dateTimeString) {
    try {
      final date = DateTime.parse(dateTimeString);
      return "${date.year.toString().padLeft(4, '0')}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}";
    } catch (e) {
      return dateTimeString;
    }
  }
}

/// Invoice Expansion Card
class _InvoiceExpansionCard extends StatefulWidget {
  final BillModel bill;

  const _InvoiceExpansionCard({required this.bill});

  @override
  State<_InvoiceExpansionCard> createState() => _InvoiceExpansionCardState();
}

class _InvoiceExpansionCardState extends State<_InvoiceExpansionCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final bill = widget.bill;
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
          GestureDetector(
            onTap: () => setState(() => _open = !_open),
            child: Container(
              color: const Color(0xFFF3F6FC),
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
                              "${'bill_no'.tr()} #${bill.blNo}",
                              style: TextStyle(
                                fontSize: 12.5.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.brandDark,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              bill.dateDisplay,
                              style: TextStyle(
                                fontSize: 10.5.sp,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          bill.customerName.isNotEmpty ? bill.customerName : 'without_customer'.tr(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: AppColors.brandLight,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      bill.isReturn ? 'return'.tr() : 'sale'.tr(),
                      style: TextStyle(
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.brandDark,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatNumber(bill.billValue, decimals: 3),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                        ),
                      ),
                      Icon(
                        _open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        size: 16.w,
                        color: AppColors.textMuted,
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
                ? Padding(
              padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 10.h),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                      child: Text(
                        "${'items'.tr()} (${bill.items.length})",
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                  for (final item in bill.items) _ItemTile(item: item),
                ],
              ),
            )
                : SizedBox(width: double.infinity, height: 0),
          ),
        ],
      ),
    );
  }
}

/// Item Tile
class _ItemTile extends StatefulWidget {
  final ItemProfitItemModel item;

  const _ItemTile({required this.item});

  @override
  State<_ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<_ItemTile> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Container(
      margin: EdgeInsets.only(bottom: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _open = !_open),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.matName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "${item.qty.toStringAsFixed(3)} ${item.unit} × ${item.price.toStringAsFixed(3)}",
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    formatNumber(item.profit, decimals: 3),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: item.profit > 0 ? AppColors.teal : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: _open
                ? Container(
              width: double.infinity,
              color: const Color(0xFFFAFBFD),
              padding: EdgeInsets.fromLTRB(10.w, 6.h, 10.w, 8.h),
              child: Column(
                children: [
                  _row("cost_price".tr(), formatNumber(item.costPrice, decimals: 3)),
                  _row("discount".tr(), formatNumber(item.discount, decimals: 3)),
                  _row("total".tr(), formatNumber(item.total, decimals: 3)),
                  if (item.notes.isNotEmpty)
                    _row("notes".tr(), item.notes),
                ],
              ),
            )
                : SizedBox(width: double.infinity, height: 0),
          ),
        ],
      ),
    );
  }

  Widget _row(String name, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.textMuted,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
