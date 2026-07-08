part of '../../../basket_imports.dart';

extension CheckoutButtonExt on _BasketPosSummaryState {
  /// Full-width PAYMENT button. Lives here (instead of a standalone widget)
  /// so it can read the entered payments, discount/addition and selected
  /// customer that are held in this summary's local state.
  Widget _buildCheckoutButton({
    required double subtotal,
    required double finalValue,
    required double adjustmentAmount,
    required double remaining,
  }) {
    return BlocBuilder<NewInvoiceBloc, NewInvoiceState>(
      builder: (context, state) {
        final isSubmitting = state.submitStatus == Status.loading;
        return SizedBox(
          width: double.infinity,
          height: 54.h,
          child: ElevatedButton(
            onPressed: isSubmitting
                ? null
                : () => _submitInvoice(
                      subtotal: subtotal,
                      finalValue: finalValue,
                      adjustmentAmount: adjustmentAmount,
                      remaining: remaining,
                    ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainAppColor,
              elevation: 4,
              shadowColor: AppColors.mainAppColor.withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: isSubmitting
                ? SizedBox(
                    width: 24.sp,
                    height: 24.sp,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.payment_rounded,
                          color: Colors.white, size: 24.sp),
                      SizedBox(width: 12.w),
                      Text(
                        'payment'.tr().toUpperCase(),
                        style: AppTextTheme.titleLarge.copyWith(
                          color: AppColors.white,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  void _submitInvoice({
    required double subtotal,
    required double finalValue,
    required double adjustmentAmount,
    required double remaining,
  }) {
    final basketState = context.read<BasketBloc>().state;
    final setupState = context.read<InvoiceSetupBloc>().state;
    // Branch was extracted from InvoiceSetupBloc into the shared BranchBloc.
    final selectedBranch = context.read<BranchBloc>().selectedBranch;
    final user = getIt<IUserCache>().getUserModel();

    if (basketState.items.isEmpty) {
      showCustomSnackBar(context, 'cart_is_empty'.tr());
      return;
    }
    if (setupState.selectedPattern == null) {
      showCustomSnackBar(context, 'Please select an invoice pattern');
      return;
    }
    if (setupState.selectedCurrency == null) {
      showCustomSnackBar(context, 'Please select a currency');
      return;
    }
    if (user == null) {
      showCustomSnackBar(context, 'User not authenticated');
      return;
    }

    final items = basketState.items
        .asMap()
        .entries
        .map((e) => e.value.toCartItem(rowNumber: e.key + 1))
        .toList();

    // Map the entered payments to the API receipt model.
    final payWays = _payments.map((p) {
      final payWay = p['payWay'] as PayWayModel?;
      final method = p['method'] as String? ?? '';
      return PayReceiptModel(
        payingValue: p['amount'] as double,
        payingType: payWay?.code ?? 0,
        receiptNumber: p['receipt'] as String? ?? '-',
        payWayName: payWay?.arName.isNotEmpty == true ? payWay!.arName : method,
        payWayEnName:
            payWay?.enName.isNotEmpty == true ? payWay!.enName : method,
      );
    }).toList();

    final request = CreateInvoiceRequest(
      invoicePatternId: setupState.selectedPattern!.patternId,
      // ISO date-only (`yyyy-MM-dd`). .NET's System.Text.Json rejects the
      // old `yyyy/MM/dd` ("The JSON value could not be converted to
      // System.Nullable<DateTime>"), which cascades into the whole body
      // binding to null → "The invoice field is required." Verified against
      // the working Swagger cURL, which sends `2026-07-08`.
      invoiceDate: DateFormat('yyyy-MM-dd', 'en_US').format(DateTime.now()),
      companyBranchId: selectedBranch?.branchId ?? 1,
      remainder: remaining,
      currencyId: setupState.selectedCurrency!.currencyId,
      currencyRate: setupState.selectedCurrency!.rate,
      customerId: _selectedAccount?.accountId,
      totalValue: subtotal,
      totalDiscount: _isDiscountAddition ? 0 : adjustmentAmount,
      totalAddition: _isDiscountAddition ? adjustmentAmount : 0,
      finalValue: finalValue,
      payingType: payWays.isNotEmpty ? payWays.first.payingType : 0,
      createdBy: user.fullUserName,
      items: items,
      payWays: payWays,
    );

    context.read<NewInvoiceBloc>().add(SubmitInvoice(request));
  }
}
