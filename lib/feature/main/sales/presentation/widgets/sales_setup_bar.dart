part of '../../sales_imports.dart';

/// Compact single-row selector bar for the sales tab:
/// Pattern | Currency | Branch, backed by [InvoiceSetupBloc].
///
/// On mount we kick `LoadInvoiceSetupData` so the shared
/// `/api/InvoiceSetting/GetAllTypes` is hit once — the bloc then fans out
/// to currencies / branches and (auto-selected branch in hand) fires
/// `LoadPatternsByBranch` to populate the pattern dropdown. We only fire
/// the load if the bloc hasn't already produced patterns; this lets other
/// screens (new-invoice / invoice-collection) reuse the same bloc instance
/// without doubling the network call.
///
/// Changing the branch reloads its patterns (handled by [InvoiceSetupBloc])
/// and re-fetches the product list for the active category via [SalesBloc].
class SalesSetupBar extends StatefulWidget {
  const SalesSetupBar({super.key});

  @override
  State<SalesSetupBar> createState() => _SalesSetupBarState();
}

class _SalesSetupBarState extends State<SalesSetupBar> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<InvoiceSetupBloc>();
    final s = bloc.state;
    final notLoadedYet = s.patternsStatus != Status.loading &&
        s.patternsStatus != Status.success &&
        s.patterns.isEmpty;
    if (notLoadedYet) {
      bloc.add(const LoadInvoiceSetupData(branchId: 0));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return BlocBuilder<InvoiceSetupBloc, InvoiceSetupState>(
      builder: (context, state) {
        return Container(
          color: AppColors.whiteColor,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Pattern ──────────────────────────────────────────────────
              Expanded(
                child: _SalesSelector(
                  label: 'new_invoice.pattern'.tr(),
                  status: state.patternsStatus,
                  isEmpty: state.patterns.isEmpty,
                  onRetry: () => context
                      .read<InvoiceSetupBloc>()
                      .add(const LoadInvoiceSetupData(branchId: 0)),
                  child: _dropdown<InvoicePatternModel>(
                    value: state.selectedPattern,
                    hint: 'new_invoice.pattern'.tr(),
                    items: state.patterns
                        .map(
                          (p) => DropdownMenuItem(
                            value: p,
                            child: Text(
                              isAr ? p.patternArName : p.patternEnName,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextTheme.caption
                                  .copyWith(color: AppColors.black),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (p) {
                      if (p != null) {
                        context
                            .read<InvoiceSetupBloc>()
                            .add(SelectPattern(p.patternId));
                      }
                    },
                  ),
                ),
              ),
              SizedBox(width: 8.w),

              // ── Currency ─────────────────────────────────────────────────
              Expanded(
                child: _SalesSelector(
                  label: 'new_invoice.currency'.tr(),
                  status: state.currenciesStatus,
                  isEmpty: state.currencies.isEmpty,
                  onRetry: () => context
                      .read<InvoiceSetupBloc>()
                      .add(const LoadInvoiceSetupData(branchId: 0)),
                  child: _dropdown<CurrencyModel>(
                    value: state.selectedCurrency,
                    hint: 'new_invoice.currency'.tr(),
                    items: state.currencies
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Text(
                              isAr ? c.currencyArName : c.currencyEnName,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextTheme.caption
                                  .copyWith(color: AppColors.black),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (c) {
                      if (c != null) {
                        context.read<InvoiceSetupBloc>().add(
                              SelectCurrency(
                                currencyId: c.currencyId,
                                rate: c.rate,
                              ),
                            );
                      }
                    },
                  ),
                ),
              ),
              SizedBox(width: 8.w),

              // ── Branch ───────────────────────────────────────────────────
              Expanded(
                child: _SalesSelector(
                  label: 'new_invoice.branch'.tr(),
                  status: state.branchesStatus,
                  isEmpty: state.branches.isEmpty,
                  onRetry: () => context
                      .read<InvoiceSetupBloc>()
                      .add(const LoadInvoiceSetupData(branchId: 0)),
                  child: _dropdown<BranchModel>(
                    value: state.selectedBranch,
                    hint: 'new_invoice.branch'.tr(),
                    items: state.branches
                        .map(
                          (b) => DropdownMenuItem(
                            value: b,
                            child: Text(
                              isAr ? b.branchArName : b.branchEnName,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextTheme.caption
                                  .copyWith(color: AppColors.black),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (b) {
                      if (b != null) {
                        context
                            .read<InvoiceSetupBloc>()
                            .add(SelectBranch(branchId: b.branchId));
                        // Reload the product list for the newly selected branch.
                        context
                            .read<SalesBloc>()
                            .add(const ReloadProducts());
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _dropdown<T>({
    required T? value,
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.whiteColor,
        hintText: hint,
        hintStyle: AppTextTheme.caption.copyWith(color: AppColors.grey),
        contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0),
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
          borderSide: BorderSide(color: AppColors.mainAppColor, width: 1.5),
        ),
      ),
      items: items,
      onChanged: onChanged,
      style: AppTextTheme.caption.copyWith(color: AppColors.black),
    );
  }
}

/// Small labeled slot used by [SalesSetupBar] — a caption label above the
/// dropdown, swapped for a loading spinner, a failure box, or an
/// empty-result box (both tappable to re-request the data) so it's always
/// visible whether the API returned options for this field.
class _SalesSelector extends StatelessWidget {
  final String label;
  final Status status;
  final bool isEmpty;
  final VoidCallback onRetry;
  final Widget child;

  const _SalesSelector({
    required this.label,
    required this.status,
    required this.isEmpty,
    required this.onRetry,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final Widget field;
    if (status == Status.loading) {
      field = _box(
        borderColor: Colors.grey.shade300,
        child: SizedBox(
          width: 14.w,
          height: 14.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.mainAppColor,
          ),
        ),
      );
    } else if (status == Status.failure) {
      field = _RetryBox(
        onTap: onRetry,
        borderColor: AppColors.red,
        icon: Icons.error_outline,
        color: AppColors.red,
        text: 'common.error'.tr(),
      );
    } else if (isEmpty) {
      field = _RetryBox(
        onTap: onRetry,
        borderColor: Colors.grey.shade400,
        icon: Icons.refresh,
        color: AppColors.grey,
        text: 'common.retry'.tr(),
      );
    } else {
      field = child;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          overflow: TextOverflow.ellipsis,
          style: AppTextTheme.caption.copyWith(color: AppColors.black),
        ),
        SizedBox(height: 4.h),
        field,
      ],
    );
  }

  Widget _box({required Color borderColor, required Widget child}) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: borderColor),
      ),
      child: Center(child: child),
    );
  }
}

/// Tappable placeholder shown when a list failed to load or came back empty;
/// tapping it re-requests the invoice-setup data.
class _RetryBox extends StatelessWidget {
  final VoidCallback onTap;
  final Color borderColor;
  final IconData icon;
  final Color color;
  final String text;

  const _RetryBox({
    required this.onTap,
    required this.borderColor,
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        height: 40.h,
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14.sp, color: color),
            SizedBox(width: 4.w),
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: AppTextTheme.caption.copyWith(color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
