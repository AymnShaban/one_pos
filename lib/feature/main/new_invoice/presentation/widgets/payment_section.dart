part of '../../new_invoice_imports.dart';


class PaymentSection extends StatelessWidget {
  final List<PaymentWayModel> payWays;
  final PaymentWayModel? selectedPayWay;
  final TextEditingController paidController;
  final TextEditingController receiptController;
  final List<PayReceiptModel> receipts;
  final double totalDue;
  final ValueChanged<PaymentWayModel?> onPayWayChanged;
  final VoidCallback onAddReceipt;
  final ValueChanged<int> onRemoveReceipt;

  const PaymentSection({
    super.key,
    required this.payWays,
    required this.selectedPayWay,
    required this.paidController,
    required this.receiptController,
    required this.receipts,
    required this.totalDue,
    required this.onPayWayChanged,
    required this.onAddReceipt,
    required this.onRemoveReceipt,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAr = context.isArabic;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // ── Input row ──────────────────────────────────────────────────────
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Payment way dropdown
            Flexible(
              flex: 3,
              child: _LabeledField(
                label: 'new_invoice.payment_method'.tr(),
                child: DropdownButtonFormField<PaymentWayModel>(
                  initialValue: selectedPayWay,
                  isExpanded: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.whiteColor,
                    hintText: 'new_invoice.payment_method'.tr(),
                    hintStyle: AppTextTheme.caption
                        .copyWith(color: AppColors.grey),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w, vertical: 0),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide:
                      BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide:
                      BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                          color: AppColors.mainAppColor, width: 1.5),
                    ),
                  ),
                  items: payWays
                      .map(
                        (pw) => DropdownMenuItem(
                      value: pw,
                      child: Text(
                        isAr ? pw.nameAr : pw.nameEn,
                        style: AppTextTheme.caption
                            .copyWith(color: AppColors.black),
                      ),
                    ),
                  )
                      .toList(),
                  onChanged: onPayWayChanged,
                ),
              ),
            ),
            SizedBox(width: 8.w),

            // Paid amount
            Flexible(
              flex: 2,
              child: _LabeledField(
                label: 'new_invoice.paid'.tr(),
                child: _InputField(
                  controller: paidController,
                  readOnly: selectedPayWay?.isCash == true,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d*')),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),

            // Receipt number
            Flexible(
              flex: 2,
              child: _LabeledField(
                label: 'new_invoice.receipt_number'.tr(),
                child: _InputField(
                  controller: receiptController,
                  keyboardType: TextInputType.text,
                ),
              ),
            ),
            SizedBox(width: 8.w),

            // Add button
            Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: ElevatedButton.icon(
                onPressed: onAddReceipt,
                icon: Icon(Icons.add,
                    color: AppColors.white, size: 18.sp),
                label: Text(
                  'new_invoice.add'.tr(),
                  style: AppTextTheme.caption
                      .copyWith(color: AppColors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainAppColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r)),
                  padding: EdgeInsets.symmetric(
                      horizontal: 14.w, vertical: 12.h),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),

        // ── Receipts table ─────────────────────────────────────────────────
        if (receipts.isNotEmpty) ...[
          // Header
          Container(
            padding:
            EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.mainAppColor,
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(10.r)),
            ),
            child: Row(
              children: [
                _TableHeader('new_invoice.payment_method'.tr()),
                _TableHeader('new_invoice.paid'.tr()),
                _TableHeader('new_invoice.receipt_number'.tr()),
                SizedBox(width: 32.w),
              ],
            ),
          ),

          // Rows
          Container(
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius:
              BorderRadius.vertical(bottom: Radius.circular(10.r)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: receipts.asMap().entries.map((entry) {
                final i = entry.key;
                final r = entry.value;
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 10.h),
                      child: Row(
                        children: [
                          // Pay way name
                          Expanded(
                            child: Text(
                              isAr ? r.payWayName : r.payWayEnName,
                              textAlign: TextAlign.center,
                              style: AppTextTheme.caption
                                  .copyWith(color: AppColors.black),
                            ),
                          ),

                          // Amount
                          Expanded(
                            child: Text(
                              r.payingValue.toStringAsFixed(2),
                              textAlign: TextAlign.center,
                              style: AppTextTheme.captionBold
                                  .copyWith(color: AppColors.black),
                            ),
                          ),

                          // Receipt number
                          Expanded(
                            child: Text(
                              r.receiptNumber,
                              textAlign: TextAlign.center,
                              style: AppTextTheme.caption
                                  .copyWith(color: AppColors.grey),
                            ),
                          ),

                          // Delete
                          GestureDetector(
                            onTap: () => onRemoveReceipt(i),
                            child: Icon(
                              Icons.delete_outline,
                              color: AppColors.red,
                              size: 18.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (i != receipts.length - 1)
                      Divider(
                          height: 1,
                          color: AppColors.backgroundColor),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }
}

// ── Table Header ──────────────────────────────────────────────────────────────
class _TableHeader extends StatelessWidget {
  final String text;

  const _TableHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextTheme.labelSmall.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
// ── Input Field ───────────────────────────────────────────────────────────────
class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;

  const _InputField({
    required this.controller,
    this.keyboardType = TextInputType.number,
    this.readOnly = false,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller:       controller,
      keyboardType:     keyboardType,
      readOnly:         readOnly,
      inputFormatters:  inputFormatters,
      textAlign:        TextAlign.right,
      style: AppTextTheme.caption.copyWith(color: AppColors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: readOnly
            ? AppColors.backgroundColor
            : AppColors.whiteColor,
        isDense: true,
        contentPadding:
        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide:
          BorderSide(color: AppColors.mainAppColor, width: 1.5),
        ),
      ),
    );
  }
}