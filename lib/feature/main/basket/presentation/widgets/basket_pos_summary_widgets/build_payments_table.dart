part of '../../../basket_imports.dart';

extension PaymentsTableExt on _BasketPosSummaryState {
  Widget _buildPaymentsTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
            color: AppColors.mainAppColor.withValues(alpha: 0.1),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'new_invoice.payment_method'.tr(),
                    style: AppTextTheme.labelSmall9Bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    'new_invoice.paid'.tr(),
                    style: AppTextTheme.labelSmall9Bold,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'new_invoice.receipt_number'.tr(),
                    style: AppTextTheme.labelSmall9Bold,
                    textAlign: TextAlign.end,
                  ),
                ),
                SizedBox(width: 30.w),
              ],
            ),
          ),
          ..._payments.map(
            (p) => Container(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(p['method'], style: AppTextTheme.caption),
                  ),
                  Expanded(
                    child: Text(
                      p['amount'].toStringAsFixed(2),
                      style: AppTextTheme.caption,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      p['receipt'],
                      style: AppTextTheme.caption,
                      textAlign: TextAlign.end,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.remove_circle,
                      color: Colors.red,
                      size: 20,
                    ),
                    onPressed: () => updateState(() => _payments.remove(p)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
