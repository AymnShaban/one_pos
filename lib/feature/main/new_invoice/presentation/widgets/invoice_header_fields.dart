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
    return BlocBuilder<NewInvoiceBloc, NewInvoiceState>(
      builder: (context, state) {
        return Container(
          color: AppColors.whiteColor,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Column(
            children: [
              // ── Row 1: Seller + Pattern ──
              Row(
                children: [
                  // Seller
                  Expanded(
                    child: _LabeledField(
                      label: 'new_invoice.seller'.tr(),
                      child: Container(
                        height: 36.h,
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.secondaryColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            // Replace with cached seller name
                            'البائع',
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
                          ? 'new_invoice.select_price_quote_pattern'.tr()
                          : 'new_invoice.pattern'.tr(),
                      child: _StyledDropdown(
                        hint: isPriceQuote
                            ? 'new_invoice.select_price_quote_pattern'.tr()
                            : 'new_invoice.select_pattern'.tr(),
                        // Wire items from InvoiceCollectionBloc later
                        items: const [],
                        onChanged: (val) {},
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),

              // ── Row 2: Branch + Currency ──
              Row(
                children: [
                  // Branch dropdown
                  Expanded(
                    child: _LabeledField(
                      label: 'new_invoice.branch'.tr(),
                      child: _StyledDropdown(
                        hint: 'new_invoice.select_branch'.tr(),
                        // Wire items from InvoiceCollectionBloc later
                        items: const [],
                        onChanged: (val) {
                          if (val != null) {
                            context
                                .read<NewInvoiceBloc>()
                                .add(UpdateBranchId(val as int));
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
                      child: _StyledDropdown(
                        hint: 'new_invoice.currency'.tr(),
                        // Wire items from InvoiceCollectionBloc later
                        items: const [],
                        onChanged: (val) {
                          if (val != null) {
                            context.read<NewInvoiceBloc>().add(
                              UpdateCurrency(
                                currencyId: val['CurrencyID'],
                                rate:       (val['Rate'] as num).toDouble(),
                              ),
                            );
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
class _StyledDropdown extends StatelessWidget {
  final String hint;
  final List<DropdownMenuItem<dynamic>> items;
  final ValueChanged<dynamic> onChanged;

  const _StyledDropdown({
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      isExpanded: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.whiteColor,
        hintText: hint,
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
      items: items,
      onChanged: onChanged,
      style: AppTextTheme.caption.copyWith(color: AppColors.black),
    );
  }
}