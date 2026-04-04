part of '../../new_invoice_imports.dart';

class NewInvoiceScreen extends StatefulWidget {
  final Map<String, dynamic>? editInvoice;
  final bool isPriceQuote;

  const NewInvoiceScreen({
    super.key,
    this.editInvoice,
    this.isPriceQuote = false,
  });

  @override
  State<NewInvoiceScreen> createState() => _NewInvoiceScreenState();
}

class _NewInvoiceScreenState extends State<NewInvoiceScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(const LoadMainCategories());
    context.read<NewInvoiceBloc>().add(const LoadPayWays());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── AppBar ──
            _buildAppBar(),

            // ── Header Fields (seller, branch, pattern, currency) ──
            InvoiceHeaderFields(
              editInvoice:  widget.editInvoice,
              isPriceQuote: widget.isPriceQuote,
            ),

            // ── Main Category Chips ──
            const CategoryListView(),

            // ── Sub Category Chips ──
            const SubCategoryListView(),

            // ── Product Grid (expands to fill remaining space) ──
            const ProductGridView(),

            // ── Bottom Bar (date + previous + next) ──
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return Container(
      color: AppColors.mainAppColor,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Row(
        children: [
          // Back
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20.r),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Icon(
                Icons.arrow_back_ios_rounded,
                color: AppColors.white,
                size: 20.sp,
              ),
            ),
          ),
          SizedBox(width: 8.w),

          // Search
          InkWell(
            onTap: () {
              // TODO: Navigate to product search screen
            },
            borderRadius: BorderRadius.circular(20.r),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Icon(
                Icons.search_rounded,
                color: AppColors.white,
                size: 24.sp,
              ),
            ),
          ),
          const Spacer(),
          Text(
            widget.isPriceQuote
                ? 'new_invoice.price_quote_title'.tr()
                : 'new_invoice.title'.tr(),
            style: AppTextTheme.body2Bold.copyWith(color: AppColors.white),
          ),

          const Spacer(),

          // Title

          // Cart badge
          BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              final count = cartState.activeItems.length;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    Icons.shopping_cart_rounded,
                    color: AppColors.white,
                    size: 26.sp,
                  ),
                  if (count > 0)
                    Positioned(
                      top: -6.h,
                      right: -6.w,
                      child: Container(
                        width: 18.w,
                        height: 18.w,
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$count',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // ── Bottom Bar ─────────────────────────────────────────────────────────────
  Widget _buildBottomBar() {
    return Container(
      color: AppColors.whiteColor,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Row(
        children: [
          // Date display
          Expanded(
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppColors.mainAppColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    color: AppColors.mainAppColor,
                    size: 14.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    DateFormat('yyyy/MM/dd', 'en_US').format(DateTime.now()),
                    style: AppTextTheme.caption
                        .copyWith(color: AppColors.black),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),

          // Previous
          _BottomButton(
            label: 'new_invoice.previous'.tr(),
            color: AppColors.secondaryColor,
            onTap: () => Navigator.pop(context),
          ),
          SizedBox(width: 8.w),

          // Next
          BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              return BlocBuilder<NewInvoiceBloc, NewInvoiceState>(
                builder: (context, invoiceState) {
                  return _BottomButton(
                    label: 'new_invoice.next'.tr(),
                    color: AppColors.mainAppColor,
                    onTap: () => _onNextTapped(
                      context,
                      cartState:    cartState,
                      invoiceState: invoiceState,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // ── Next logic ─────────────────────────────────────────────────────────────
  void _onNextTapped(
      BuildContext context, {
        required CartState cartState,
        required NewInvoiceState invoiceState,
      }) {
    if (invoiceState.patternId == -1) {
      _showSnackBar(context, 'new_invoice.select_branch_and_pattern'.tr());
      return;
    }
    if (cartState.activeItems.isEmpty) {
      _showSnackBar(context, 'new_invoice.select_items'.tr());
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<CartBloc>()),
            BlocProvider.value(value: context.read<NewInvoiceBloc>()),
          ],
          child: InvoiceSummaryScreen(
            editInvoice:   widget.editInvoice,
            invoiceNumber: invoiceState.lastInvoiceNumber,
            isPriceQuote:  widget.isPriceQuote,
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextTheme.caption.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }
}

// ── Reusable Bottom Button ────────────────────────────────────────────────────
class _BottomButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _BottomButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        elevation: 0,
      ),
      child: Text(
        label,
        style: AppTextTheme.caption.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}