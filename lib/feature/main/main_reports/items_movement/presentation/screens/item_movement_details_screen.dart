// feature/main/main_reports/item_movement/presentation/screens/item_movement_details_screen.dart
import 'package:easy_localization/easy_localization.dart';
import '../../items_movement_import.dart';

class ItemMovementDetailsScreen extends StatelessWidget {
  final ItemMovementResponseModel reportData;
  final DateTime fromDate;
  final DateTime toDate;

  const ItemMovementDetailsScreen({
    super.key,
    required this.reportData,
    required this.fromDate,
    required this.toDate,
  });

  @override
  Widget build(BuildContext context) {
    final items = reportData.items;

    return Scaffold(
      backgroundColor: AppColors.slateBg,
      appBar: GradientAppBar(
        title: "item_movement_report".tr(),
        subtitle:
        "${DateFormat('dd/MM/yyyy').format(fromDate)} - ${DateFormat('dd/MM/yyyy').format(toDate)}",
        onBack: () => Navigator.of(context).maybePop(),
        accentIcon: Container(
          width: 34.w,
          height: 34.h,
          decoration: BoxDecoration(
            color: AppColors.blue,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            Icons.inventory_2,
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
      body: items.isEmpty
          ? _buildEmptyState()
          : CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 6.h),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSummaryHeader(items),
                SizedBox(height: 12.h),
                _buildKpiGrid(items),
                SizedBox(height: 16.h),
                _buildSectionHeader(items),
              ]),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final item = items[index];
                  return _ItemCard(
                    item: item,
                    index: index,
                    isLast: index == items.length - 1,
                  );
                },
                childCount: items.length,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 6.h),
            sliver: SliverToBoxAdapter(
              child: _buildClosingBalanceCard(items),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(items),
    );
  }

  // ==================== EMPTY STATE ====================

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 80.sp,
            color: AppColors.textMuted.withOpacity(0.3),
          ),
          SizedBox(height: 16.h),
          Text(
            'no_data_found'.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== SUMMARY HEADER ====================

  Widget _buildSummaryHeader(List<ItemMovementItemModel> items) {
    final totalItems = items.length;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(10.r),
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
              "${totalItems} ${'items'.tr()}",
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

  Widget _buildKpiGrid(List<ItemMovementItemModel> items) {
    final totalIn = items.fold<double>(
      0.0,
          (sum, item) => sum + (item.totalInQty ?? 0),
    );
    final totalOut = items.fold<double>(
      0.0,
          (sum, item) => sum + (item.totalOutQty ?? 0),
    );
    final totalBalance = totalIn - totalOut;
    final totalItems = items.length;

    return KpiGrid(
      items: [
        KpiItem(
          label: "total_items".tr(),
          value: totalItems.toString(),
          valueColor: AppColors.blue,
        ),
        KpiItem(
          label: "total_in".tr(),
          value: _formatNumber(totalIn),
          valueColor: AppColors.green,
        ),
        KpiItem(
          label: "total_out".tr(),
          value: _formatNumber(totalOut),
          valueColor: AppColors.red,
        ),
        KpiItem(
          label: "net_balance".tr(),
          value: _formatNumber(totalBalance),
          valueColor: totalBalance >= 0 ? AppColors.green : AppColors.red,
        ),
      ],
    );
  }

  // ==================== SECTION HEADER ====================

  Widget _buildSectionHeader(List<ItemMovementItemModel> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "items_details".tr(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
            color: AppColors.brandDark,
          ),
        ),
        Text(
          "${items.length} ${'items'.tr()}",
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ==================== CLOSING BALANCE CARD ====================

  Widget _buildClosingBalanceCard(List<ItemMovementItemModel> items) {
    final totalIn = items.fold<double>(
      0.0,
          (sum, item) => sum + (item.totalInQty ?? 0),
    );
    final totalOut = items.fold<double>(
      0.0,
          (sum, item) => sum + (item.totalOutQty ?? 0),
    );
    final netBalance = totalIn - totalOut;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
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
                'net_balance'.tr(),
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          Text(
            _formatNumber(netBalance),
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: netBalance >= 0 ? AppColors.green : AppColors.red,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== BOTTOM BAR ====================

  Widget _buildBottomBar(List<ItemMovementItemModel> items) {
    final totalIn = items.fold<double>(
      0.0,
          (sum, item) => sum + (item.totalInQty ?? 0),
    );
    final totalOut = items.fold<double>(
      0.0,
          (sum, item) => sum + (item.totalOutQty ?? 0),
    );
    final netBalance = totalIn - totalOut;

    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
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
              _formatNumber(netBalance),
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

  String _formatNumber(double value) {
    return NumberFormat('#,##0.000', 'en_US').format(value);
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}

// ==================== ITEM CARD ====================

class _ItemCard extends StatefulWidget {
  final ItemMovementItemModel item;
  final int index;
  final bool isLast;

  const _ItemCard({
    required this.item,
    required this.index,
    required this.isLast,
  });

  @override
  State<_ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<_ItemCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final totalIn = item.totalInQty ?? 0;
    final totalOut = item.totalOutQty ?? 0;
    final balance = (item.finalBalance ?? 0);

    return GestureDetector(
      onTap: () => setState(() => _open = !_open),
      child: Container(
        margin: EdgeInsets.only(top: 8.h),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // ====== Header ======
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              child: Row(
                children: [
                  Container(
                    width: 32.w,
                    height: 32.h,
                    decoration: BoxDecoration(
                      color: AppColors.blueBg,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.inventory_2,
                      color: AppColors.blue,
                      size: 18.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),

                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.materialName,
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
                          '${'code'.tr()}: ${item.materialId}',
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

                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _formatNumber(balance),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: balance >= 0 ? AppColors.green : AppColors.red,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '${item.rows.length} ${'movements'.tr()}',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Icon(
                    _open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 22.w,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),

            // ==================== DETAILS SECTION ====================
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: _open
                  ? Container(
                width: double.infinity,
                color: AppColors.backgroundColor,
                padding: EdgeInsets.all(12.w),
                child: Column(
                  children: [
                    // ====== Summary Stats ======
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                            color: AppColors.line.withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              _buildDetailItem(
                                icon: Icons.arrow_downward,
                                label: 'total_in'.tr(),
                                value: _formatNumber(totalIn),
                                color: AppColors.green,
                              ),
                              _buildDetailItem(
                                icon: Icons.arrow_upward,
                                label: 'total_out'.tr(),
                                value: _formatNumber(totalOut),
                                color: AppColors.red,
                              ),
                              _buildDetailItem(
                                icon: Icons.account_balance,
                                label: 'balance'.tr(),
                                value: _formatNumber(balance),
                                color: balance >= 0
                                    ? AppColors.green
                                    : AppColors.red,
                                isBold: true,
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),

                          Row(
                            children: [
                              _buildDetailItem(
                                icon: Icons.trending_up,
                                label: 'max_purchase'.tr(),
                                value: _formatNumber(item.maxPurchase),
                                color: AppColors.orange,
                              ),
                              _buildDetailItem(
                                icon: Icons.trending_down,
                                label: 'min_purchase'.tr(),
                                value: _formatNumber(item.minPurchase),
                                color: AppColors.orange,
                              ),
                              _buildDetailItem(
                                icon: Icons.equalizer,
                                label: 'avg_purchase'.tr(),
                                value: _formatNumber(item.avgPurchase),
                                color: AppColors.orange,
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),

                          Row(
                            children: [
                              _buildDetailItem(
                                icon: Icons.sell,
                                label: 'max_sell'.tr(),
                                value: _formatNumber(item.maxSell),
                                color: AppColors.purple,
                              ),
                              _buildDetailItem(
                                icon: Icons.sell,
                                label: 'min_sell'.tr(),
                                value: _formatNumber(item.minSell),
                                color: AppColors.purple,
                              ),
                              _buildDetailItem(
                                icon: Icons.sell,
                                label: 'avg_sell'.tr(),
                                value: _formatNumber(item.avgSell),
                                color: AppColors.purple,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 12.h),

                    // ====== Transactions Section ======
                    if (item.rows.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'movement_details'.tr(),
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                          Text(
                            '${item.rows.length} ${'transactions'.tr()}',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),

                      ...item.rows.take(5).map((row) => _buildTransactionItem(row)),

                      if (item.rows.length > 5)
                        Padding(
                          padding: EdgeInsets.only(top: 6.h),
                          child: Center(
                            child: TextButton(
                              onPressed: () => _showAllTransactions(context, item),
                              child: Text(
                                '+ ${item.rows.length - 5} ${'more_transactions'.tr()}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
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

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool isBold = false,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 14.sp, color: color),
          SizedBox(height: 2.h),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 14.sp : 12.sp,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 9.sp,
              color: AppColors.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(ItemMovementRowModel row) {
    final inQty = row.qty1 ?? 0;
    final outQty = row.qty2 ?? 0;
    final balance = (row.qty1 ?? 0) - (row.qty2 ?? 0);

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.line.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  row.billName,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (row.isPosted)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    'posted'.tr(),
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: AppColors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 4.h),

          Wrap(
            spacing: 6.w,
            runSpacing: 4.h,
            children: [
              _buildInfoChip(Icons.calendar_today, _formatDate(row.date)),
              _buildInfoChip(Icons.storefront, row.store),
              if (row.customer.isNotEmpty)
                _buildInfoChip(Icons.person, row.customer),
            ],
          ),
          SizedBox(height: 6.h),

          Row(
            children: [
              _buildQtyChip('in'.tr(), inQty, AppColors.green),
              _buildQtyChip('out'.tr(), outQty, AppColors.red),
              _buildQtyChip('balance'.tr(), balance,
                  balance >= 0 ? AppColors.blue : AppColors.red),
            ],
          ),

          if (row.itemSerials.isNotEmpty)
            _buildExtraInfo(Icons.qr_code, 'serials'.tr(), row.itemSerials),
          if (row.explanationItem.isNotEmpty)
            _buildExtraInfo(Icons.description, 'explanation'.tr(), row.explanationItem),
          if (row.notes.isNotEmpty)
            _buildExtraInfo(Icons.note, 'notes'.tr(), row.notes),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10.sp, color: AppColors.textMuted),
          SizedBox(width: 4.w),
          Text(
            value,
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyChip(String label, double value, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Center(
          child: Text(
            '$label: ${_formatNumber(value)}',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExtraInfo(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 12.sp, color: AppColors.textMuted),
          SizedBox(width: 6.w),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.textDark,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showAllTransactions(BuildContext context, ItemMovementItemModel item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20.r),
            ),
          ),
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 10.h),
                  width: 36.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.line,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(14.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: AppColors.blueBg,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.inventory_2,
                            size: 20.sp,
                            color: AppColors.blue,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.materialName,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${item.rows.length} ${'transactions'.tr()}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        size: 22.sp,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1.h, color: AppColors.line),

              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.all(14.w),
                  itemCount: item.rows.length,
                  itemBuilder: (context, index) {
                    final row = item.rows[index];
                    return _buildFullTransactionRow(row);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFullTransactionRow(ItemMovementRowModel row) {
    final inQty = row.qty1 ?? 0;
    final outQty = row.qty2 ?? 0;
    final balance = (row.qty1 ?? 0) - (row.qty2 ?? 0);

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.line.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  row.billName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              if (row.isPosted)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppColors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    'posted'.tr(),
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: AppColors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 6.h),

          Wrap(
            spacing: 6.w,
            runSpacing: 4.h,
            children: [
              _buildInfoChip(Icons.calendar_today, _formatDate(row.date)),
              _buildInfoChip(Icons.storefront, row.store),
              if (row.customer.isNotEmpty)
                _buildInfoChip(Icons.person, row.customer),
              if (row.costCenter.isNotEmpty)
                _buildInfoChip(Icons.account_balance, row.costCenter),
            ],
          ),
          SizedBox(height: 8.h),

          Row(
            children: [
              _buildQtyChip('in'.tr(), inQty, AppColors.green),
              _buildQtyChip('out'.tr(), outQty, AppColors.red),
              _buildQtyChip('balance'.tr(), balance,
                  balance >= 0 ? AppColors.blue : AppColors.red),
            ],
          ),

          if (row.itemSerials.isNotEmpty)
            _buildExtraInfo(Icons.qr_code, 'serials'.tr(), row.itemSerials),
          if (row.expireDate.isNotEmpty)
            _buildExtraInfo(Icons.calendar_month, 'expire_date'.tr(), row.expireDate),
          if (row.explanationItem.isNotEmpty)
            _buildExtraInfo(Icons.description, 'explanation'.tr(), row.explanationItem),
          if (row.notes.isNotEmpty)
            _buildExtraInfo(Icons.note, 'notes'.tr(), row.notes),
        ],
      ),
    );
  }

  // ==================== HELPERS ====================

  String _formatNumber(double? value) {
    if (value == null) return '0.000';
    return NumberFormat('#,##0.000', 'en_US').format(value);
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
}