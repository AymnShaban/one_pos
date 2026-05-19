part of '../../../basket_imports.dart';

extension PaymentInputSectionExt on _BasketPosSummaryState {
  Widget _buildPaymentInputSection(double remaining) {
    final isAr = context.locale.languageCode == 'ar';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _payWayDropdown(
                'new_invoice.payment_method'.tr(),
                isAr,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              flex: 1,
              child: _labeledInput(
                'new_invoice.receipt_number'.tr(),
                (val) => _receiptNumber = val,
                '0',
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              flex: 1,
              child: _labeledInput(
                'new_invoice.paid'.tr(),
                (_) {},
                remaining.toStringAsFixed(2),
                controller: _paidController,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ElevatedButton(
          onPressed: () {
            // Use the amount the user typed; only fall back to the remaining
            // amount when the field is left empty.
            final typed = double.tryParse(_paidController.text.trim());
            final amount =
                (typed != null && typed > 0) ? typed : remaining;
            if (amount <= 0) return;
            updateState(() {
              _payments.add({
                'method': _selectedPayWay?.displayName(isAr) ?? '',
                'amount': amount,
                'receipt': _receiptNumber,
              });
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainAppColor,
            minimumSize: Size(double.infinity, 45.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, color: Colors.white),
              SizedBox(width: 8.w),
              Text(
                'new_invoice.add'.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _labeledInput(
    String label,
    Function(String) onChanged,
    String hint, {
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4.h),
        Container(
          height: 30.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            controller: controller,
            style: AppTextTheme.captionBold,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
            ),
            keyboardType: TextInputType.number,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _payWayDropdown(String label, bool isAr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4.h),
        Container(
          height: 30.h,
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: BlocBuilder<PayWaysBloc, BaseState<PayWayModel>>(
            bloc: _payWaysBloc,
            builder: (context, state) {
              if (state.status == Status.loading) {
                return Center(
                  child: SizedBox(
                    width: 16.w,
                    height: 16.w,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }

              final ways = state.items;
              if (ways.isEmpty) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    state.status == Status.failure
                        ? 'common.error'.tr()
                        : 'no_products'.tr(),
                    style: AppTextTheme.caption,
                  ),
                );
              }

              // Default to the first way once data arrives.
              if (_selectedPayWay == null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted && _selectedPayWay == null) {
                    updateState(() => _selectedPayWay = ways.first);
                  }
                });
              }
              final selected = ways.contains(_selectedPayWay)
                  ? _selectedPayWay
                  : ways.first;

              return DropdownButtonHideUnderline(
                child: DropdownButton<PayWayModel>(
                  style: AppTextTheme.caption,
                  value: selected,
                  isExpanded: true,
                  items: ways
                      .map(
                        (p) => DropdownMenuItem(
                          value: p,
                          child: Text(
                            p.displayName(isAr),
                            style: AppTextTheme.caption,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) =>
                      updateState(() => _selectedPayWay = val),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
