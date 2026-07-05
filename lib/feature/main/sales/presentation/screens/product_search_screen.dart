part of '../../sales_imports.dart';

/// Full-screen product search (search-as-you-type) over
/// `/api/Product/SearchProducts`, scoped to the active sales pattern.
class ProductSearchScreen extends StatelessWidget {
  const ProductSearchScreen({
    required this.patternId,
    required this.invoiceSetupBloc,
    super.key,
  });

  final int patternId;

  /// The Sales tab's `InvoiceSetupBloc` instance, captured from the caller's
  /// context — `EnhancedProductItem` (via `ProductItemSelector`) reads it for
  /// the selected currency label. It's a `getIt.registerFactory`, so it must
  /// be forwarded from the existing instance rather than re-resolved here.
  final InvoiceSetupBloc invoiceSetupBloc;

  @override
  Widget build(BuildContext context) {
    return ProductListWrapper(
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: invoiceSetupBloc),
          BlocProvider(
            create: (_) => ProductSearchBloc(
              dataSource: getIt<ProductSearchDataSource>(),
              patternId: patternId,
            ),
          ),
        ],
        child: const _ProductSearchView(),
      ),
    );
  }
}

class _ProductSearchView extends StatefulWidget {
  const _ProductSearchView();

  @override
  State<_ProductSearchView> createState() => _ProductSearchViewState();
}

class _ProductSearchViewState extends State<_ProductSearchView> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      context.read<ProductSearchBloc>().add(SearchProducts(value));
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: CustomTextFormField(
          controller: _controller,
          hintText: 'new_invoice.search_product'.tr(),
          prefixIcon: Icons.search,
          fillColor: Colors.transparent,
          onChanged: _onChanged,
        ),
      ),
      body: BlocBuilder<ProductSearchBloc, BaseState<ItemModel>>(
        builder: (context, state) {
          if (_controller.text.trim().isEmpty &&
              state.status == Status.initial) {
            return Center(
              child: Text(
                'new_invoice.search_product'.tr(),
                style: TextStyle(
                  color: const Color(0xff8A8F99),
                  fontSize: 14.sp,
                ),
              ),
            );
          }

          if (state.status == Status.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == Status.failure) {
            return Center(
              child: Text(
                state.errorMessage ?? 'error'.tr(),
                style: TextStyle(color: Colors.red, fontSize: 14.sp),
              ),
            );
          }

          if (state.items.isEmpty) {
            return Center(
              child: Text(
                'no_products'.tr(),
                style: TextStyle(
                  color: const Color(0xff8A8F99),
                  fontSize: 14.sp,
                ),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (index == state.items.length - 1) {
                      context.read<ProductSearchBloc>().add(
                        const LoadMoreSearchResults(),
                      );
                    }
                    return ProductItemSelector(product: state.items[index]);
                  }, childCount: state.items.length),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: 0.72,
                  ),
                ),
              ),
              if (state.status == Status.isLoadingMore)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.h),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
              SliverToBoxAdapter(child: SizedBox(height: 20.h)),
            ],
          );
        },
      ),
    );
  }
}
