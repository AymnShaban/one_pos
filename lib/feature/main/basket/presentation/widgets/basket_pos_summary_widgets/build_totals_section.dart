part of '../../../basket_imports.dart';

extension TotalsSectionExt on _BasketPosSummaryState {
  Widget _buildTotalsSection(double total, double net, double discountAmount) {
    return Row(
      children: [
        Expanded(
          child: _summaryBox(
            'common.total'.tr().toUpperCase(),
            total.toStringAsFixed(3),
            AppColors.tealAccentColor,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _summaryBox(
            'new_invoice.net'.tr().toUpperCase(),
            net.toStringAsFixed(3),
            AppColors.mainAppColor,
          ),
        ),

        SizedBox(width: 4.w),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Row(
                children: [
                  _radioOption('new_invoice.add'.tr(), true),
                  _radioOption('new_invoice.discount'.tr(), false),
                ],
              ),
              Row(
                children: [
                  Text('%', style: AppTextTheme.captionBold),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: _smallInput((val) {
                      updateState(
                        () => _discountPercent = double.tryParse(val) ?? 0,
                      );
                    }, _discountPercent.toStringAsFixed(0)),
                  ),
                  Text('=', style: AppTextTheme.captionBold),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: _smallValueBox(discountAmount.toStringAsFixed(2), (
                      val,
                    ) {
                      final amount = double.tryParse(val) ?? 0;
                      updateState(() {
                        _discountPercent = total > 0
                            ? (amount / total) * 100
                            : 0;
                      });
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _summaryBox(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: AppTextTheme.captionBold.copyWith(color: Colors.white),
          ),
          Text(
            value,
            style: AppTextTheme.captionBold.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _radioOption(String label, bool value) {
    return Row(
      children: [
        Radio<bool>(
          value: value,
          groupValue: _isDiscountAddition,
          onChanged: (val) => updateState(() => _isDiscountAddition = val!),
          activeColor: AppColors.mainAppColor,
          visualDensity: VisualDensity.compact,
        ),
        Text(label, style: TextStyle(fontSize: 10.sp)),
      ],
    );
  }

  Widget _smallInput(Function(String) onChanged, String initial) {
    return Container(
      height: 30.h,
      padding: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        style: AppTextTheme.captionBold,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(border: InputBorder.none),
        onChanged: onChanged,
      ),
    );
  }

  Widget _smallValueBox(String value, Function(String) onChanged) {
    return EditableSmallBox(value: value, onChanged: onChanged);
  }
}
