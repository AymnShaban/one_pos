import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_pos/core/helper/helper.dart';

class QuantityInputSection extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final VoidCallback onAddPressed;
  final VoidCallback? onBarcodePressed;
  final Function(String)? onSubmitted;

  const QuantityInputSection({
    super.key,
    required this.controller,
    this.focusNode,
    required this.onAddPressed,
    this.onBarcodePressed,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Add button
          GestureDetector(
            onTap: onAddPressed,
            child: Container(
              width: 45.w,
              height: 35.h,
              decoration: BoxDecoration(
                color: const Color(0xFFD4A5A5),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Icons.add, color: Colors.white, size: 32.sp),
            ),
          ),
          SizedBox(width: 12.w),
          if (onBarcodePressed != null)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  bottomLeft: Radius.circular(12.r),
                ),
              ),
              child: IconButton(
                icon: Icon(Icons.qr_code_scanner,
                    size: 24.sp, color: Colors.black54),
                onPressed: onBarcodePressed,
                padding: EdgeInsets.zero,
              ),
            ),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode, // ← added
              textAlign: TextAlign.center,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onSubmitted: onSubmitted,
              style:AppTextTheme.captionBold,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 8.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide:
                  const BorderSide(color: Colors.black, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide:
                  const BorderSide(color: Colors.black, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide:
                  const BorderSide(color: Colors.black, width: 2.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
