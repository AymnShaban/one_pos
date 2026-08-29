import 'package:easy_localization/easy_localization.dart';
import '../../invoice_profit_imports.dart';

class InvoiceProfitAdvancedFiltersScreen extends StatefulWidget {
  final String initialViewMode;
  final String initialSortBy;
  final String initialGroupBy;
  final bool initialShowRemaining;
  final bool initialZeroInvoices;
  final bool initialCostFromLastPurchase;
  final bool initialFreeCost;
  final bool initialShowPaid;
  final bool initialShowClientBranch;
  final bool initialTotalWeight;
  final bool initialHideDiscount;
  final bool initialTotalReps;
  final double initialDiscountPercent;

  const InvoiceProfitAdvancedFiltersScreen({
    super.key,
    required this.initialViewMode,
    required this.initialSortBy,
    required this.initialGroupBy,
    this.initialShowRemaining = false,
    this.initialZeroInvoices = false,
    this.initialCostFromLastPurchase = false,
    this.initialFreeCost = false,
    this.initialShowPaid = true,
    this.initialShowClientBranch = false,
    this.initialTotalWeight = false,
    this.initialHideDiscount = false,
    this.initialTotalReps = false,
    this.initialDiscountPercent = 0.0,
  });

  @override
  State<InvoiceProfitAdvancedFiltersScreen> createState() =>
      _InvoiceProfitAdvancedFiltersScreenState();
}

class _InvoiceProfitAdvancedFiltersScreenState
    extends State<InvoiceProfitAdvancedFiltersScreen> {
  final TextEditingController _discountController = TextEditingController();


  late String viewMode;
  late String sortBy;
  late String groupBy;
  late bool report_showRemaining;
  late bool report_zeroInvoices;
  late bool report_costFromLastPurchase;
  late bool report_freeCost;
  late bool report_showPaid;
  late bool report_showClientBranch;
  late bool report_totalWeight;
  late bool report_hideDiscount;
  late bool report_totalReps;

  String tr(String key) => key.tr();

  @override
  void initState() {
    super.initState();


    viewMode = widget.initialViewMode;
    sortBy = widget.initialSortBy;
    groupBy = widget.initialGroupBy;


    report_showRemaining = widget.initialShowRemaining;
    report_zeroInvoices = widget.initialZeroInvoices;
    report_costFromLastPurchase = widget.initialCostFromLastPurchase; // false
    report_freeCost = widget.initialFreeCost;                    // false
    report_showPaid = widget.initialShowPaid;                    // true
    report_showClientBranch = widget.initialShowClientBranch;    // false
    report_totalWeight = widget.initialTotalWeight;              // false
    report_hideDiscount = widget.initialHideDiscount;            // false
    report_totalReps = widget.initialTotalReps;                  // false
    _discountController.text = widget.initialDiscountPercent.toString();
  }

  void _returnResult() {
    Navigator.of(context).pop({
      'viewMode': viewMode,
      'sortBy': sortBy,
      'groupBy': groupBy,
      'showRemaining': report_showRemaining,
      'zeroInvoices': report_zeroInvoices,
      'costFromLastPurchase': report_costFromLastPurchase,
      'freeCost': report_freeCost,
      'showPaid': report_showPaid,
      'showClientBranch': report_showClientBranch,
      'totalWeight': report_totalWeight,
      'hideDiscount': report_hideDiscount,
      'totalReps': report_totalReps,
      'discountPercent': double.tryParse(_discountController.text) ?? 0.0,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.slateBg,
      appBar: GradientAppBar(
        title: tr("advanced_filter"),
        subtitle: tr("report_options_and_views"),
        onBack: _returnResult,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============================================================
            // 1. REPORT OPTIONS (خيارات التقرير)
            // ============================================================
            FilterSectionLabel(title: tr("report_options")),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.line),
              ),
              child: Column(
                children: [
                  Wrap(
                    spacing: 15.w,
                    runSpacing: 10.h,
                    children: [
                      _buildCheckbox(
                        tr("show_remaining"),
                        report_showRemaining,
                            (v) => setState(() => report_showRemaining = v),
                      ),
                      _buildCheckbox(
                        tr("zero_invoices"),
                        report_zeroInvoices,
                            (v) => setState(() => report_zeroInvoices = v),
                      ),
                      _buildCheckbox(
                        tr("cost_from_last_purchase"),
                        report_costFromLastPurchase,
                            (v) => setState(() => report_costFromLastPurchase = v),
                      ),
                      _buildCheckbox(
                        tr("free_cost"),
                        report_freeCost,
                            (v) => setState(() => report_freeCost = v),
                      ),
                      _buildCheckbox(
                        tr("show_paid"),
                        report_showPaid,
                            (v) => setState(() => report_showPaid = v),
                      ),
                      _buildCheckbox(
                        tr("show_client_branch"),
                        report_showClientBranch,
                            (v) => setState(() => report_showClientBranch = v),
                      ),
                      _buildCheckbox(
                        tr("total_weight"),
                        report_totalWeight,
                            (v) => setState(() => report_totalWeight = v),
                      ),
                      _buildCheckbox(
                        tr("hide_discount"),
                        report_hideDiscount,
                            (v) => setState(() => report_hideDiscount = v),
                      ),
                      _buildCheckbox(
                        tr("total_reps"),
                        report_totalReps,
                            (v) => setState(() => report_totalReps = v),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: TextField(
                      controller: _discountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: tr("discount_percent"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // ============================================================
            // 2. VIEW CONTROLS
            // ============================================================
            FilterSectionLabel(title: tr("view_controls")),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // (1) View Mode
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr("view_mode"),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.brandDark,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Wrap(
                        spacing: 8.w,
                        children: [
                          _buildRadio(
                            "analytical".tr(),
                            "analytical",
                            viewMode,
                                (v) => setState(() => viewMode = v),
                          ),
                          _buildRadio(
                            "monthly".tr(),
                            "monthly",
                            viewMode,
                                (v) => setState(() => viewMode = v),
                          ),
                          _buildRadio(
                            "daily".tr(),
                            "daily",
                            viewMode,
                                (v) => setState(() => viewMode = v),
                          ),
                          _buildRadio(
                            "weekly".tr(),
                            "weekly",
                            viewMode,
                                (v) => setState(() => viewMode = v),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Divider(color: AppColors.line),
                  ),

                  // (2) Sort By
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr("sort_by"),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.brandDark,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Wrap(
                        spacing: 8.w,
                        children: [
                          _buildRadio(
                            "date".tr(),
                            "date",
                            sortBy,
                                (v) => setState(() => sortBy = v),
                          ),
                          _buildRadio(
                            "invoice_number".tr(),
                            "invoice_number",
                            sortBy,
                                (v) => setState(() => sortBy = v),
                          ),
                          _buildRadio(
                            "customer".tr(),
                            "customer",
                            sortBy,
                                (v) => setState(() => sortBy = v),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Divider(color: AppColors.line),
                  ),

                  // (3) Group By
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr("group_by"),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.brandDark,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Wrap(
                        spacing: 8.w,
                        children: [
                          _buildRadio(
                            "pattern".tr(),
                            "pattern",
                            groupBy,
                                (v) => setState(() => groupBy = v),
                          ),
                          _buildRadio(
                            "group_customer".tr(),
                            "customer",
                            groupBy,
                                (v) => setState(() => groupBy = v),
                          ),
                          _buildRadio(
                            "group_date".tr(),
                            "date",
                            groupBy,
                                (v) => setState(() => groupBy = v),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FilterBottomBar(
        primaryLabel: tr("apply"),
        secondaryLabel: tr("back"),
        onSecondary: _returnResult,
        onPrimary: _returnResult,
      ),
    );
  }

  // ----------------- Helper Widgets -----------------
  Widget _buildCheckbox(String label, bool value, Function(bool) onChanged) {
    return SizedBox(
      width: 140.w,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 24.h,
            width: 24.w,
            child: Checkbox(
              value: value,
              onChanged: (val) => onChanged(val ?? false),
              activeColor: AppColors.brand,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 12.sp),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadio<T>(
      String label,
      T value,
      T groupValue,
      Function(T) onChanged,
      ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<T>(
          value: value,
          groupValue: groupValue,
          onChanged: (val) => onChanged(val as T),
          activeColor: AppColors.brand,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }
}