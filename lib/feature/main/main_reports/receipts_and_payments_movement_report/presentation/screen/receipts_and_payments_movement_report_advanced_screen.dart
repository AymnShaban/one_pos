import 'package:easy_localization/easy_localization.dart';
import '../../receipts_and_payments_movement_report_import.dart';

class ReceiptsAndPaymentsMovementReportAdvancedFiltersScreen extends StatefulWidget {
  final int initialSelectedCount;

  const ReceiptsAndPaymentsMovementReportAdvancedFiltersScreen({
    super.key,
    required this.initialSelectedCount,
  });

  @override
  State<ReceiptsAndPaymentsMovementReportAdvancedFiltersScreen> createState() =>
      _ReceiptsAndPaymentsMovementReportAdvancedFiltersScreenState();
}

class _ReceiptsAndPaymentsMovementReportAdvancedFiltersScreenState
    extends State<ReceiptsAndPaymentsMovementReportAdvancedFiltersScreen> {

  // ✅ Default values matching the JSON
  bool showReceipts = true;      // selectedEntries (id: 1,2)
  bool showPayments = true;      // selectedEntries (id: 3,4)
  bool showNetVoucher = true;    // showEntryNet
  bool showPosted = true;        // showPosted
  bool showUnposted = true;      // showNotPosted
  bool repByClient = true;       // employeeAccordingToCustomer

  // ✅ Order By - false = by date (JSON: orderByCode: false)
  int sortIndex = 0; // 0: date, 1: voucher number

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.slateBg,
      appBar: GradientAppBar(
        title: "advanced_filter".tr(),
        subtitle: "display_options_order".tr(),
        onBack: () => Navigator.of(context).pop<Map<String, dynamic>>(_getResult()),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 10.h),
        children: [
          // ============================================================
          // 📋 Display Options
          // ============================================================
          FilterSectionLabel(title: "display_options".tr()),
          ToggleCard(options: [
            ToggleOption(
              title: "receipt_vouchers".tr(),
              value: showReceipts,
              onChanged: (v) => setState(() => showReceipts = v),
            ),
            ToggleOption(
              title: "payment_vouchers".tr(),
              value: showPayments,
              onChanged: (v) => setState(() => showPayments = v),
            ),
            ToggleOption(
              title: "show_net_voucher".tr(),
              value: showNetVoucher,
              onChanged: (v) => setState(() => showNetVoucher = v),
            ),
            ToggleOption(
              title: "show_posted".tr(),
              value: showPosted,
              onChanged: (v) => setState(() => showPosted = v),
            ),
            ToggleOption(
              title: "show_unposted".tr(),
              value: showUnposted,
              onChanged: (v) => setState(() => showUnposted = v),
            ),
            ToggleOption(
              title: "rep_by_client".tr(),
              value: repByClient,
              onChanged: (v) => setState(() => repByClient = v),
            ),
          ]),
          SizedBox(height: 16.h),

          // ============================================================
          // 📋 Order By
          // ============================================================
          FilterSectionLabel(title: "order_by".tr()),
          SegmentedFilter(
            options: ["by_date".tr(), "by_voucher_number".tr()],
            selectedIndex: sortIndex,
            onChanged: (i) => setState(() => sortIndex = i),
          ),
        ],
      ),
      bottomNavigationBar: FilterBottomBar(
        primaryLabel: "apply".tr(),
        secondaryLabel: "back".tr(),
        onSecondary: () => Navigator.of(context).pop<Map<String, dynamic>>(_getResult()),
        onPrimary: () => Navigator.of(context).pop<Map<String, dynamic>>(_getResult()),
      ),
    );
  }

  // ============================================================
  // ✅ Result Builder
  // ============================================================
  Map<String, dynamic> _getResult() {
    // ✅ Build selectedSourceIds based on showReceipts and showPayments
    final List<int> selectedSourceIds = [];

    // Receipt Vouchers: id 1, 2
    if (showReceipts) {
      selectedSourceIds.addAll([1, 2]);
    }

    // Payment Vouchers: id 3, 4
    if (showPayments) {
      selectedSourceIds.addAll([3, 4]);
    }

    return {
      'selectedSourceIds': selectedSourceIds,
      'showReceipts': showReceipts,
      'showPayments': showPayments,
      'showNetVoucher': showNetVoucher,
      'showPosted': showPosted,
      'showUnposted': showUnposted,
      'repByClient': repByClient,
      'sortIndex': sortIndex,
    };
  }
}