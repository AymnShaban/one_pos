part of '../../new_invoice_imports.dart';

class InvoiceHeaderFields extends StatelessWidget {
  final Map<String, dynamic>? editInvoice;
  final bool isPriceQuote;

  const InvoiceHeaderFields({
    super.key,
    this.editInvoice,
    this.isPriceQuote = false,
  });

  @override
  Widget build(BuildContext context) {
    final isAr       = context.locale.languageCode == 'ar';
    final sellerName = HiveServiceImpl.instance.getSellerName() ?? '';

    return BlocBuilder<InvoiceSetupBloc, InvoiceSetupState>(
      builder: (context, colState) {
        return Container(
          color: AppColors.whiteColor,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Column(
            children: [
              // ── Row 1: Seller + Pattern ──────────────────────────────────
              Row(
                children: [
                  // Seller (read-only)
                  Expanded(
                    child: _LabeledField(
                      label: 'new_invoice.seller'.tr(),
                      child: Container(
                        height: 40.h,
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.secondaryColor),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            sellerName,
                            style: AppTextTheme.caption
                                .copyWith(color: AppColors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),

                  // Pattern dropdown
                  Expanded(
                    child: _LabeledField(
                      label: isPriceQuote
                          ? 'new_invoice.price_quote_pattern'.tr()
                          : 'new_invoice.pattern'.tr(),
                      child: colState.patternsStatus == Status.loading
                          ? _LoadingField()
                          : _StyledDropdown<InvoicePatternModel>(
                        value: colState.selectedPattern,
                        hint: isPriceQuote
                            ? 'new_invoice.select_price_quote_pattern'.tr()
                            : 'new_invoice.select_pattern'.tr(),
                        items: colState.patterns
                            .map(
                              (p) => DropdownMenuItem(
                            value: p,
                            child: Text(
                              isAr
                                  ? p.patternArName
                                  : p.patternEnName,
                              style: AppTextTheme.caption
                                  .copyWith(color: AppColors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                            .toList(),
                        onChanged: (p) {
                          if (p != null) {
                            context
                                .read<InvoiceSetupBloc>()
                                .add(SelectPattern(p.patternId));
                            context
                                .read<NewInvoiceBloc>()
                                .add(UpdatePatternId(p.patternId));
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),

              // ── Row 2: Branch + Currency ─────────────────────────────────
              Row(
                children: [
                  // Branch dropdown
                  Expanded(
                    child: _LabeledField(
                      label: 'new_invoice.branch'.tr(),
                      child: colState.branchesStatus == Status.loading
                          ? _LoadingField()
                          : _StyledDropdown<BranchModel>(
                        value: colState.selectedBranch,
                        hint: 'new_invoice.select_branch'.tr(),
                        items: colState.branches
                            .map(
                              (b) => DropdownMenuItem(
                            value: b,
                            child: Text(
                              isAr
                                  ? b.branchArName
                                  : b.branchEnName,
                              style: AppTextTheme.caption
                                  .copyWith(color: AppColors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                            .toList(),
                        onChanged: (b) {
                          if (b != null) {
                            context
                                .read<InvoiceSetupBloc>()
                                .add(SelectBranch(
                              branchId:     b.branchId,
                              isPriceQuote: isPriceQuote,
                            ));
                            context
                                .read<NewInvoiceBloc>()
                                .add(UpdateBranchId(b.branchId));
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),

                  // Currency dropdown
                  Expanded(
                    child: _LabeledField(
                      label: 'new_invoice.currency'.tr(),
                      child: colState.currenciesStatus == Status.loading
                          ? _LoadingField()
                          : _StyledDropdown<CurrencyModel>(
                        value: colState.selectedCurrency,
                        hint: 'new_invoice.currency'.tr(),
                        items: colState.currencies
                            .map(
                              (c) => DropdownMenuItem(
                            value: c,
                            child: Text(
                              isAr
                                  ? c.currencyArName
                                  : c.currencyEnName,
                              style: AppTextTheme.caption
                                  .copyWith(color: AppColors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                            .toList(),
                        onChanged: (c) {
                          if (c != null) {
                            context
                                .read<InvoiceSetupBloc>()
                                .add(SelectCurrency(
                              currencyId: c.currencyId,
                              rate:       c.rate,
                            ));
                            context
                                .read<NewInvoiceBloc>()
                                .add(UpdateCurrency(
                              currencyId: c.currencyId,
                              rate:       c.rate,
                            ));
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Labeled Field ─────────────────────────────────────────────────────────────
class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;

  const _LabeledField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: AppTextTheme.caption.copyWith(color: AppColors.black),
        ),
        SizedBox(height: 4.h),
        child,
      ],
    );
  }
}

// ── Styled Dropdown ───────────────────────────────────────────────────────────
class _StyledDropdown<T> extends StatelessWidget {
  final T? value;
  final String hint;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _StyledDropdown({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue:      value,        // ← fixed: was initialValue
      isExpanded: true,
      decoration: InputDecoration(
        filled:    true,
        fillColor: AppColors.whiteColor,
        hintText:  hint,
        hintStyle: AppTextTheme.caption.copyWith(color: AppColors.grey),
        contentPadding:
        EdgeInsets.symmetric(horizontal: 12.w, vertical: 0),
        isDense: true,
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
      items:     items,
      onChanged: onChanged,
      style:     AppTextTheme.caption.copyWith(color: AppColors.black),
    );
  }
}

// ── Loading placeholder ───────────────────────────────────────────────────────
class _LoadingField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color:        AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
        border:       Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: SizedBox(
          width: 16.w,
          height: 16.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.mainAppColor,
          ),
        ),
      ),
    );
  }
}