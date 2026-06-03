import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_pos/core/helper/helper.dart';

/// Barcode search/input field with scanner button and auto-detection
class BarcodeSearchField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onScanPressed;
  final Function(String barcode)? onBarcodeEntered;
  final FocusNode? focusNode;

  const BarcodeSearchField({
    super.key,
    required this.controller,
    required this.onScanPressed,
    this.onBarcodeEntered,
    this.focusNode,
  });

  @override
  State<BarcodeSearchField> createState() => _BarcodeSearchFieldState();
}

class _BarcodeSearchFieldState extends State<BarcodeSearchField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.qr_code_scanner,
                size: 18.sp,
                color: Colors.black87,
              ),
              onPressed: widget.onScanPressed,
            ),
          ),
          SizedBox(width: 6.w),
          SizedBox(
            width: 100,
            height: 35,
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              textAlign: TextAlign.right,
              keyboardType: TextInputType.number,
              onSubmitted: (value) {
                final barcode = value.trim();
                if (barcode.isNotEmpty && widget.onBarcodeEntered != null) {
                  widget.onBarcodeEntered!(barcode);
                }
              },
              style: AppTextTheme.captionBold,
              decoration: InputDecoration(

                hintText: 'scan_barcode'.tr(),
                hintStyle:AppTextTheme.caption.copyWith(color: Colors.black45),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Colors.black, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Colors.black, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Colors.black, width: 2.0),
                ),
              ),
            ),
          ),
          // Scanner button
        ],
      ),
    );
  }
}
