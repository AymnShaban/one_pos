import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/app_colors.dart';
import '../../domain/entities/invoice_product.dart';

class InvoiceItemRow extends StatefulWidget {
  final InvoiceProduct product;
  final VoidCallback onDelete;
  final ValueChanged<double> onRealQuantityChanged;

  const InvoiceItemRow({
    super.key,
    required this.product,
    required this.onDelete,
    required this.onRealQuantityChanged,
  });

  @override
  State<InvoiceItemRow> createState() => _InvoiceItemRowState();
}

class _InvoiceItemRowState extends State<InvoiceItemRow> {
  late TextEditingController _qtyController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _qtyController = TextEditingController(
      text: _fmt(widget.product.realQuantity),
    );

    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusLost);
  }

  @override
  void didUpdateWidget(InvoiceItemRow oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.product.realQuantity != widget.product.realQuantity &&
        !_focusNode.hasFocus) {
      _qtyController.text = _fmt(widget.product.realQuantity);
    }
  }

  void _onFocusLost() {
    if (!_focusNode.hasFocus) {
      _commitValue();
    }
  }

  void _commitValue() {
    final parsed = double.tryParse(_qtyController.text.trim());

    if (parsed != null && parsed > 0) {
      if (parsed != widget.product.realQuantity) {
        widget.onRealQuantityChanged(parsed);
      }
    } else {
      _qtyController.text = _fmt(widget.product.realQuantity);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusLost);
    _focusNode.dispose();
    _qtyController.dispose();
    super.dispose();
  }

  String _fmt(num value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    var text = value.toStringAsFixed(2);

    text = text.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');

    return text;
  }

  Color _diffColor(num diff) {
    if (diff > 0) return AppColors.greenDark;
    if (diff < 0) return AppColors.red;
    return AppColors.textMuted;
  }

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    final product = widget.product;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: AppColors.brand.withValues(alpha: 0.55),
          width: 1.1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ======================================================
          // Product name
          // ======================================================
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  product.displayName(isAr),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              SizedBox(width: 8.w),

              InkWell(
                onTap: widget.onDelete,
                borderRadius: BorderRadius.circular(6.r),
                child: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.textMuted,
                    size: 18.sp,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // ======================================================
          // Barcode
          // ======================================================
          Text(
            product.barcode,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.5.sp,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
              letterSpacing: .2,
            ),
          ),

          SizedBox(height: 7.h),

          Divider(height: 1, thickness: .7, color: AppColors.borderColor),

          SizedBox(height: 7.h),

          // ======================================================
          // Values
          // ======================================================
          Row(
            children: [
              Expanded(
                child: _MetricCell(
                  label: 'stock_quantity'.tr(),
                  value: _fmt(product.stockQuantity),
                  valueColor: AppColors.textPrimary,
                ),
              ),

              Container(width: 1, height: 30.h, color: AppColors.borderColor),

              Expanded(
                child: _EditableMetric(
                  label: 'real_quantity'.tr(),
                  controller: _qtyController,
                  focusNode: _focusNode,
                  onSubmitted: (_) => _commitValue(),
                ),
              ),

              Container(width: 1, height: 30.h, color: AppColors.borderColor),

              Expanded(
                child: _MetricCell(
                  label: 'result'.tr(),
                  value: _fmt(product.diff),
                  valueColor: _diffColor(product.diff),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ================================================================
// Metric
// ================================================================

class _MetricCell extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _MetricCell({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 9.5.sp,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),

        SizedBox(height: 2.h),

        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

// ================================================================
// Editable Real Quantity
// ================================================================

class _EditableMetric extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onSubmitted;

  const _EditableMetric({
    required this.label,
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 9.5.sp,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),

        SizedBox(height: 2.h),

        SizedBox(
          width: 58.w,
          height: 28.h,
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            textAlign: TextAlign.center,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [_DecimalTextInputFormatter(2)],
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: AppColors.brandLight,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 3.h,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.r),
                borderSide: BorderSide(color: AppColors.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.r),
                borderSide: BorderSide(color: AppColors.brand, width: 1.2),
              ),
            ),
            onFieldSubmitted: onSubmitted,
          ),
        ),
      ],
    );
  }
}

// ================================================================
// Decimal Formatter
// ================================================================

class _DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange;

  _DecimalTextInputFormatter(this.decimalRange);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final regExp = RegExp('^\\d*\\.?\\d{0,$decimalRange}\$');

    return regExp.hasMatch(newValue.text) ? newValue : oldValue;
  }
}
