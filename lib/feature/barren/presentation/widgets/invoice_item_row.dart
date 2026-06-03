import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/invoice_product.dart';

/// One basket card per scanned product. The card is split into two rows so
/// the six fields fit comfortably on a phone:
///
///   Row 1 (identity): product name | barcode | delete
///   Row 2 (numbers):  stock  | real qty (editable) | diff (coloured)
///
/// `diff = realQuantity - stockQuantity`: green when surplus, red when
/// shortage, neutral when equal. Editing real-qty commits on focus-loss
/// (same pattern the basket uses).
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
    _qtyController =
        TextEditingController(text: _fmt(widget.product.realQuantity));
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
    if (!_focusNode.hasFocus) _commitValue();
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

  /// `green` surplus, `red` shortage, neutral grey when equal.
  Color _diffColor(num diff) {
    if (diff > 0) return const Color(0xFF2E7D32);
    if (diff < 0) return const Color(0xFFC62828);
    return Colors.black54;
  }

  /// Whole numbers print plainly (3), fractions trim trailing zeros (2.5).
  String _fmt(num v) {
    if (v == v.roundToDouble()) return v.toInt().toString();
    var s = v.toStringAsFixed(2);
    if (s.contains('.')) {
      s = s.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    }
    return s;
  }

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';
    final p = widget.product;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Row 1: name | barcode | delete ───────────────────────
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Text(
                  p.displayName(isAr),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  p.barcode,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13.sp, color: Colors.black54),
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline,
                    color: const Color(0xFFE57373), size: 22.sp),
                onPressed: widget.onDelete,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Divider(height: 1, color: Colors.grey.shade200),
          SizedBox(height: 6.h),

          // ── Row 2: stock | real qty | diff ───────────────────────
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _MetricCell(
                  label: 'stock_quantity'.tr(),
                  value: _fmt(p.stockQuantity),
                  valueColor: Colors.black87,
                ),
              ),
              Expanded(
                flex: 2,
                child: _EditableMetric(
                  label: 'real_quantity'.tr(),
                  controller: _qtyController,
                  focusNode: _focusNode,
                  onSubmitted: (_) => _commitValue(),
                ),
              ),
              Expanded(
                flex: 2,
                child: _MetricCell(
                  label: 'result'.tr(),
                  value: _fmt(p.diff),
                  valueColor: _diffColor(p.diff),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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
          style: TextStyle(fontSize: 10.sp, color: Colors.black54),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

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
          style: TextStyle(fontSize: 10.sp, color: Colors.black54),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          width: 80.w,
          height: 32.h,
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            textAlign: TextAlign.center,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [_DecimalTextInputFormatter(2)],
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide:
                    BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(
                    color: Color(0xFF1976D2), width: 1.5),
              ),
            ),
            onFieldSubmitted: onSubmitted,
          ),
        ),
      ],
    );
  }
}

/// Rejects any edit that puts more than [decimalRange] digits past the dot
/// — so the real-qty field stays like 35.71, not 35.7133. Same shape as the
/// formatter used in the basket inline edits.
class _DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange;

  _DecimalTextInputFormatter(this.decimalRange);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;
    final regExp = RegExp('^\\d*\\.?\\d{0,$decimalRange}\$');
    return regExp.hasMatch(newValue.text) ? newValue : oldValue;
  }
}
