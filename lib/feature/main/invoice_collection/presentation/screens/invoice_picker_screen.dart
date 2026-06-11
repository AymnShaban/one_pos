part of '../../invoice_collection_imports.dart';

/// "البحث عن فاتورة" — the invoice picker the collection form opens via
/// the فاتورة button. Picking a row pops back with the chosen
/// [CollectionInvoiceRowModel].
///
/// Search routing mirrors the old cubit's `onChanged`:
///   empty   → load-all-for-customer (the customer pre-selected on the
///             collection form, or `-1` if none)
///   digits  → search by invoice number
///   text    → search by customer name
///
/// The caller is expected to provide an [InvoiceSearchBloc] above this
/// widget and dispatch the initial `LoadAllInvoicesForCustomer` event so
/// the list isn't empty on first render.
class InvoicePickerScreen extends StatefulWidget {
  /// The customer id the form had selected when this screen was opened —
  /// used to refresh the "all" query when the search box is cleared.
  final int initialCustomerId;

  const InvoicePickerScreen({super.key, this.initialCustomerId = -1});

  @override
  State<InvoicePickerScreen> createState() => _InvoicePickerScreenState();
}

class _InvoicePickerScreenState extends State<InvoicePickerScreen> {
  final _searchCtrl = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      final bloc = context.read<InvoiceSearchBloc>();
      final trimmed = value.trim();
      if (trimmed.isEmpty) {
        bloc.add(LoadAllInvoicesForCustomer(widget.initialCustomerId));
        return;
      }
      final isNumeric = RegExp(r'^\d+$').hasMatch(trimmed);
      bloc.add(isNumeric
          ? SearchInvoicesByNumber(trimmed)
          : SearchInvoicesByName(trimmed));
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainAppColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          'invoice_collection.invoice_picker_title'.tr(),
          style: AppTextTheme.body2Bold.copyWith(color: AppColors.white),
        ),
      ),
      body: Column(
        children: [
          // ── Search bar ───────────────────────────────────────────
          Padding(
            padding: EdgeInsets.all(12.w),
            child: TextField(
              controller: _searchCtrl,
              onChanged: _onChanged,
              style: AppTextTheme.caption.copyWith(color: AppColors.black),
              decoration: InputDecoration(
                hintText: 'invoice_collection.search_invoices_hint'.tr(),
                hintStyle:
                    AppTextTheme.caption.copyWith(color: AppColors.grey),
                prefixIcon:
                    Icon(Icons.search, color: AppColors.grey, size: 22.sp),
                filled: true,
                fillColor: AppColors.whiteColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide:
                      BorderSide(color: AppColors.mainAppColor, width: 1.5),
                ),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w, vertical: 10.h),
              ),
            ),
          ),

          // ── Header row ───────────────────────────────────────────
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.mainAppColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.r)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text('invoice_collection.invoice_no'.tr(),
                      style: _headerStyle()),
                ),
                Expanded(
                  flex: 4,
                  child: Text('invoice_collection.account'.tr(),
                      style: _headerStyle()),
                ),
                Expanded(
                  flex: 2,
                  child: Text('invoice_collection.total'.tr(),
                      textAlign: TextAlign.center, style: _headerStyle()),
                ),
                Expanded(
                  flex: 2,
                  child: Text('invoice_collection.remaining'.tr(),
                      textAlign: TextAlign.center, style: _headerStyle()),
                ),
              ],
            ),
          ),

          // ── Rows / states ────────────────────────────────────────
          Expanded(
            child:
                BlocBuilder<InvoiceSearchBloc,
                    BaseState<CollectionInvoiceRowModel>>(
              builder: (context, state) {
                if (state.status == Status.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.status == Status.failure) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Text(
                        state.errorMessage ?? 'common.error'.tr(),
                        textAlign: TextAlign.center,
                        style: AppTextTheme.caption
                            .copyWith(color: AppColors.red),
                      ),
                    ),
                  );
                }
                if (state.items.isEmpty) {
                  return Center(
                    child: Text(
                      'no_products'.tr(),
                      style: AppTextTheme.caption
                          .copyWith(color: AppColors.grey),
                    ),
                  );
                }
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(10.r)),
                  ),
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: state.items.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: Colors.grey.shade200),
                    itemBuilder: (context, index) {
                      final row = state.items[index];
                      return InkWell(
                        onTap: () => Navigator.pop(context, row),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 12.h),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  '${row.invoiceNo}',
                                  style: AppTextTheme.captionBold,
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  row.displayName(isAr),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextTheme.captionBold.copyWith(
                                    color: AppColors.mainAppColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  row.totalValue.toStringAsFixed(2),
                                  textAlign: TextAlign.center,
                                  style: AppTextTheme.caption,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  row.remainder.toStringAsFixed(2),
                                  textAlign: TextAlign.center,
                                  style: AppTextTheme.caption,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _headerStyle() => AppTextTheme.caption.copyWith(
        color: AppColors.white,
        fontWeight: FontWeight.bold,
      );
}
