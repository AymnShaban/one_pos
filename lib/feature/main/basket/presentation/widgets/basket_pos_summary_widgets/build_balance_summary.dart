part of '../../../basket_imports.dart';

extension BalanceSummaryExt on _BasketPosSummaryState {
  Widget _buildBalanceSummary(double paid, double remaining) {
    return Row(
      children: [
        Expanded(
          child: _columnInfo(
            'new_invoice.paid'.tr(),
            paid.toStringAsFixed(3),
            color: Colors.green,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _columnInfo(
            'new_invoice.unpaid'.tr(),
            remaining.toStringAsFixed(3),
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
