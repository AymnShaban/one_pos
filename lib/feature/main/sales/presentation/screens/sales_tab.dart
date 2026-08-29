part of '../../sales_imports.dart';


class SalesTab extends StatefulWidget  {
  const SalesTab({super.key});

  @override
  State<SalesTab> createState() => _SalesTabState();
}

class _SalesTabState extends State<SalesTab> {
  Future<void> _openBarcodeScanner(BuildContext context) async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      if (!context.mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BarcodeScannerView(
            onBarcodeScanned: _handleBarcodeScanned,
          ),
        ),
      );
    } else {
      if (!context.mounted) return;
      showCustomSnackBar(context, 'camera_permission_denied'.tr());
    }
  }

  Future<void> _handleBarcodeScanned(String barcode) async {
    final customer = getIt<IUserCache>().getUserModel();
    if (customer == null) {
      if (mounted) showCustomSnackBar(context, 'please_log_in_to_add_to_cart'.tr());
      return;
    }

    final result = await getIt<ProductSearchDataSource>().searchByBarcode(barcode);
    result.fold(
      (failure) {
        if (mounted) showCustomSnackBar(context, failure.message);
      },
      (items) {
        if (items.isEmpty) {
          if (mounted) showCustomSnackBar(context, 'product_not_found'.tr());
          return;
        }
        final item = items.first;
        getIt<AddToBasketBloc>().add(
          AddToBasket(AddToBasketRequest(
            customerID: customer.id,
            productID: item.productId,
            productBarcode: item.barCode,
            item: item,
            quantity: 1,
          )),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<BasketBloc>().add(const FetchBasketItems());
    context.read<BranchBloc>().add(const LoadBranches());
    context.read<InvoiceSetupBloc>().add(const LoadInvoiceSetupData(branchId: 0));
    context.read<SalesCategoryBloc>().add(const LoadSalesCategories());

  }

  @override
  Widget build(BuildContext context) {
    return ProductListWrapper(
      child: Scaffold(
      backgroundColor:  AppColors.white,

     bottomNavigationBar: const BasketBottomBar(),
      body: MultiBlocListener(
        listeners: [
          // Branches arrived → load patterns for the auto-selected branch
          BlocListener<BranchBloc, BaseState<BranchModel>>(
            listenWhen: (p, c) =>
                p.status != Status.success && c.status == Status.success,
            listener: (context, _) {
              final id = context.read<BranchBloc>().selectedId;
              if (id != 0) {
                context
                    .read<InvoiceSetupBloc>()
                    .add(LoadPatternsByBranch(branchId: id));
              }
            },
          ),
          // Selected leaf category changed → reload products. Covers both
          // the initial auto-selection on first fetch and any user tap on
          // a parent (which re-derives a fresh first-child).
          BlocListener<SalesCategoryBloc, BaseState<SalesCategoryModel>>(
            listenWhen: (prev, curr) =>
                prev.metadata['selectedCategoryId'] !=
                curr.metadata['selectedCategoryId'],
            listener: (context, state) {
              final id = state.metadata['selectedCategoryId'] as int?;
              context.read<SalesBloc>().add(FilterByCategory(id));
            },
          ),
          // Active sales pattern changed → push it into SalesBloc so the
          // next product fetch carries the right `patternId`. SalesBloc
          // only fires once BOTH ids are known.
          BlocListener<InvoiceSetupBloc, InvoiceSetupState>(
            listenWhen: (p, c) =>
                p.selectedPatternId != c.selectedPatternId,
            listener: (context, state) {
              final id = state.selectedPatternId == -1
                  ? null
                  : state.selectedPatternId;
              context.read<SalesBloc>().add(SetActivePattern(id));
            },
          ),
        ],
        child: BlocBuilder<SalesBloc, BaseState<ItemModel>>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                HomeAppBar(
                  isOnline: context.read<HomeBloc>().isOnline,
                  showBasket: true,
                  onSearchTap: () {
                    final setupBloc = context.read<InvoiceSetupBloc>();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductSearchScreen(
                          patternId: setupBloc.state.selectedPatternId,
                          invoiceSetupBloc: setupBloc,
                        ),
                      ),
                    );
                  },
                  onScanTap: () => _openBarcodeScanner(context),
                ),

                // Pattern / Currency / Branch selectors
                const SliverToBoxAdapter(child: SalesSetupBar()),

                // Main category chip list
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.h, bottom: 4.h),
                    child: const MainCategoryDropdown(),
                  ),
                ),

                // Sub-category strip
                const SliverToBoxAdapter(child: SubCategoryListView()),

                // Loading state
                if (state.status == Status.loading)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )

                // Error state
                else if (state.status == Status.failure)
                  SliverFillRemaining(
                    child: Center(
                      child: Text(
                        state.errorMessage ?? 'error'.tr(),
                        style: TextStyle(color: Colors.red, fontSize: 14.sp),
                      ),
                    ),
                  )

                // Empty state
                else if (state.items.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'no_products'.tr(),
                        style: TextStyle(
                          color: const Color(0xff8A8F99),
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  )

                // Product grid
                else
                  SliverPadding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          // Load more trigger
                          if (index == state.items.length - 1) {
                            context
                                .read<SalesBloc>()
                                .add(const LoadMoreProducts());
                          }
                          return ProductItemSelector(
                              product: state.items[index]);
                        },
                        childCount: state.items.length,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                        childAspectRatio: 0.72,
                      ),
                    ),
                  ),

                // Load more indicator
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
      ),
      ),
    );
  }
}
