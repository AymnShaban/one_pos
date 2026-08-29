// feature/main/main_reports/item_movement_balance/presentation/screens/item_movement_balance_details_screen.dart
import 'package:easy_localization/easy_localization.dart';
import '../../item_movement_balance_import.dart';

class ItemMovementBalanceDetailsScreen extends StatelessWidget {
  final ItemMovementBalanceResponseModel reportData;
  final DateTime fromDate;
  final DateTime toDate;

  const ItemMovementBalanceDetailsScreen({
    super.key,
    required this.reportData,
    required this.fromDate,
    required this.toDate,
  });

  @override
  Widget build(BuildContext context) {
    final items = reportData.rows.where((item) => !item.isGroupHeader).toList();
    final groups = reportData.rows.where((item) => item.isGroupHeader).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildAppBar(context),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 10.h),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSummaryHeader(),
                _buildKpiGrid(),
                SizedBox(height: 16.h),
                _buildSectionHeader(),
              ]),
            ),
          ),

          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w,vertical:10),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final item = reportData.rows[index];
                  if (item.isGroupHeader) {
                    return _buildGroupHeaderCard(item);
                  }
                  return _buildItemCard(item, index);
                },
                childCount: reportData.rows.length,
              ),
            ),
          ),

        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // ==================== APP BAR ====================

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return GradientAppBar(
      title: "item_movement_balance_report".tr(),
      subtitle:
      "${DateFormat('dd/MM/yyyy').format(fromDate)} - ${DateFormat('dd/MM/yyyy').format(toDate)}",
      onBack: () => Navigator.of(context).maybePop(),

    );
  }

  // ==================== SUMMARY HEADER ====================

  Widget _buildSummaryHeader() {
    final totalItems = reportData.rows.where((item) => !item.isGroupHeader).length;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
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
                size: 16.sp,
                color: AppColors.textMuted,
              ),
              SizedBox(width: 8.w),
              Text(
                '${_formatDate(fromDate)} - ${_formatDate(toDate)}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.blueBg,
              borderRadius: BorderRadius.circular(999.r),
            ),
            child: Text(
              "${totalItems} ${'items'.tr()}",
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== KPI GRID ====================

  Widget _buildKpiGrid() {
    final items = reportData.rows.where((item) => !item.isGroupHeader).toList();

    final totalOpeningBalance = items.fold<double>(
      0.0,
          (sum, item) => sum + (item.bRasid),
    );
    final totalIncoming = items.fold<double>(
      0.0,
          (sum, item) => sum + (item.matEnt),
    );
    final totalOutgoing = items.fold<double>(
      0.0,
          (sum, item) => sum + (item.matOut),
    );
    final totalBalance = items.fold<double>(
      0.0,
          (sum, item) => sum + (item.afRasid),
    );

    return KpiGrid(
      items: [
        KpiItem(
          label: "opening_balance".tr(),
          value: _formatNumber(totalOpeningBalance),
          valueColor: AppColors.blue,
        ),
        KpiItem(
          label: "incoming".tr(),
          value: _formatNumber(totalIncoming),
          valueColor: AppColors.green,
        ),
        KpiItem(
          label: "outgoing".tr(),
          value: _formatNumber(totalOutgoing),
          valueColor: AppColors.red,
        ),
        KpiItem(
          label: "closing_balance".tr(),
          value: _formatNumber(totalBalance),
          valueColor: totalBalance >= 0 ? AppColors.green : AppColors.red,
        ),
      ],
    );
  }

  // ==================== SECTION HEADER ====================

  Widget _buildSectionHeader() {
    final totalItems = reportData.rows.where((item) => !item.isGroupHeader).length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "items_details".tr(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: AppColors.textDark,
          ),
        ),
        Text(
          "${totalItems} ${'items'.tr()}",
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ==================== GROUP HEADER CARD ====================

  Widget _buildGroupHeaderCard(ItemMovementBalanceItemModel item) {
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.blue.withOpacity(0.15),
            AppColors.blue.withOpacity(0.05),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.blue.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.folder,
              size: 18.sp,
              color: AppColors.white,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              item.groupName ?? 'group'.tr(),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.blue,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              'group'.tr(),
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== ITEM CARD ====================

  Widget _buildItemCard(ItemMovementBalanceItemModel item, int index) {
    final isEven = index % 2 == 0;

    return Container(
      margin: EdgeInsets.only(top: 10.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isEven ? AppColors.white : AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.line.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.04),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ====== رأس الصنف ======
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.blueBg,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.inventory_2,
                  size: 18.sp,
                  color: AppColors.blue,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.mtName,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.barcode.isNotEmpty)
                      Text(
                        '${'barcode'.tr()}: ${item.barcode}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textMuted,
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(color: AppColors.blue.withOpacity(0.2)),
                ),
                child: Text(
                  'item'.tr(),
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // ====== الكميات ======
          _buildSectionTitle('quantities'.tr()),
          SizedBox(height: 6.h),
          _buildQuantityRow(
            icon: Icons.trending_up,
            label: 'opening'.tr(),
            value: _formatNumber(item.bRasid),
            color: AppColors.blue,
          ),
          _buildQuantityRow(
            icon: Icons.arrow_downward,
            label: 'incoming'.tr(),
            value: _formatNumber(item.matEnt),
            color: AppColors.green,
          ),
          _buildQuantityRow(
            icon: Icons.arrow_upward,
            label: 'outgoing'.tr(),
            value: _formatNumber(item.matOut),
            color: AppColors.red,
          ),
          _buildQuantityRow(
            icon: Icons.account_balance,
            label: 'balance'.tr(),
            value: _formatNumber(item.afRasid),
            color: item.afRasid >= 0 ? AppColors.green : AppColors.red,
            isBold: true,
          ),

          SizedBox(height: 12.h),
          _buildCustomDivider(),
          SizedBox(height: 12.h),

          // ====== التكاليف ======
          _buildSectionTitle('costs'.tr()),
          SizedBox(height: 6.h),
          _buildCostRow(
            label: 'opening'.tr(),
            value: _formatNumber(item.bCost),
            color: AppColors.blue,
          ),
          _buildCostRow(
            label: 'incoming'.tr(),
            value: _formatNumber(item.entCost),
            color: AppColors.green,
          ),
          _buildCostRow(
            label: 'outgoing'.tr(),
            value: _formatNumber(item.outCost),
            color: AppColors.red,
          ),
          _buildCostRow(
            label: 'balance'.tr(),
            value: _formatNumber(item.matCost),
            color: item.matCost >= 0 ? AppColors.green : AppColors.red,
            isBold: true,
          ),

          SizedBox(height: 12.h),
          _buildCustomDivider(),
          SizedBox(height: 12.h),

          // ====== الإجماليات ======
          _buildSectionTitle('totals'.tr()),
          SizedBox(height: 6.h),
          _buildTotalRow(
            label: 'opening'.tr(),
            value: _formatNumber(item.bTotal),
            color: AppColors.blue,
          ),
          _buildTotalRow(
            label: 'incoming'.tr(),
            value: _formatNumber(item.entTotal),
            color: AppColors.green,
          ),
          _buildTotalRow(
            label: 'outgoing'.tr(),
            value: _formatNumber(item.outTotal),
            color: AppColors.red,
          ),
          _buildTotalRow(
            label: 'balance'.tr(),
            value: _formatNumber(item.matTotal),
            color: item.matTotal >= 0 ? AppColors.green : AppColors.red,
            isBold: true,
          ),
        ],
      ),
    );
  }

  // ==================== CUSTOM DIVIDER ====================

  Widget _buildCustomDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1.5.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.blue.withOpacity(0.3),
                  AppColors.blue.withOpacity(0.1),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Icon(
          Icons.circle,
          size: 6.sp,
          color: AppColors.blue.withOpacity(0.3),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Container(
            height: 1.5.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.blue.withOpacity(0.1),
                  AppColors.blue.withOpacity(0.3),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==================== SECTION TITLE ====================

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textMuted,
        letterSpacing: 0.5,
      ),
    );
  }

  // ==================== QUANTITY ROW ====================

  Widget _buildQuantityRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool isBold = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14.sp,
            color: color,
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 14.sp : 13.sp,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== COST ROW ====================

  Widget _buildCostRow({
    required String label,
    required String value,
    required Color color,
    bool isBold = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        children: [
          SizedBox(width: 24.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 14.sp : 13.sp,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== TOTAL ROW ====================

  Widget _buildTotalRow({
    required String label,
    required String value,
    required Color color,
    bool isBold = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        children: [
          SizedBox(width: 24.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 14.sp : 13.sp,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== CLOSING BALANCE CARD ====================


  // ==================== BOTTOM BAR (ثابت مع الرصيد الختامي وصافي الحركة) ====================

  Widget _buildBottomBar() {
    final items = reportData.rows.where((item) => !item.isGroupHeader).toList();

    final totalBalance = items.fold<double>(
      0.0,
          (sum, item) => sum + (item.afRasid),
    );
    final totalIncoming = items.fold<double>(
      0.0,
          (sum, item) => sum + (item.matEnt),
    );
    final totalOutgoing = items.fold<double>(
      0.0,
          (sum, item) => sum + (item.matOut),
    );
    final netMovement = totalIncoming - totalOutgoing;

    return SafeArea(
      top: true,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 18.h),
        decoration: BoxDecoration(
          color: AppColors.textDark,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ====== الرصيد الختامي ======
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.account_balance,
                      color: AppColors.white,
                      size: 18.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "closing_balance".tr(),
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text(
                  _formatNumber(totalBalance),
                  style: TextStyle(
                    color: totalBalance >= 0 ? const Color(0xFF8FE3C7) : Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            // ====== الفاصل ======
            Container(
              height: 1.h,
              color: Colors.white.withOpacity(0.1),
            ),
            SizedBox(height: 8.h),
            // ====== صافي الحركة ======
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      netMovement >= 0 ? Icons.trending_up : Icons.trending_down,
                      color: netMovement >= 0 ? const Color(0xFF8FE3C7) : Colors.redAccent,
                      size: 18.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "net_movement".tr(),
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text(
                  _formatNumber(netMovement),
                  style: TextStyle(
                    color: netMovement >= 0 ? const Color(0xFF8FE3C7) : Colors.redAccent,
                    fontWeight: FontWeight.w800,
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==================== HELPERS ====================

  String _formatNumber(double value) {
    if (value == 0) return '0';
    return NumberFormat('#,##0.00', 'en_US').format(value);
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}