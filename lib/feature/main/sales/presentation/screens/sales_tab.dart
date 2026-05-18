part of '../../sales_imports.dart';


class SalesTab extends StatefulWidget {
  const SalesTab({super.key});

  @override
  State<SalesTab> createState() => _SalesTabState();
}

class _SalesTabState extends State<SalesTab> {
  @override
  void initState() {
    super.initState();
    context.read<MainCategoryBloc>().add(const FetchMainCategories());
    context.read<BasketBloc>().add(const FetchBasketItems());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InvoiceSetupBloc>(
      create: (_) => getIt<InvoiceSetupBloc>()
        ..add(const LoadInvoiceSetupData(branchId: 0)),
      child: ProductListWrapper(
        child: Scaffold(
        backgroundColor:  AppColors.white,
        bottomNavigationBar: const BasketBottomBar(),
        body: MultiBlocListener(
          listeners: [
            // Main category selection → fetch its sub-categories
            BlocListener<MainCategoryBloc, BaseState<MainCategoryModel>>(
              listenWhen: (prev, curr) =>
                  prev.metadata['selectedMainCategoryId'] !=
                  curr.metadata['selectedMainCategoryId'],
              listener: (context, state) {
                final id = state.metadata['selectedMainCategoryId'] as int?;
                if (id == null) {
                  context.read<SubCategoryBloc>().add(const ClearSubCategories());
                  context.read<SalesBloc>().add(const FilterByCategory(null));
                  return;
                }
                context
                    .read<SubCategoryBloc>()
                    .add(FetchSubCategories(parentCategoryId: id));
              },
            ),
            // Sub-category selection → filter products
            BlocListener<SubCategoryBloc, BaseState<SubCategoryModel>>(
              listenWhen: (prev, curr) =>
                  prev.metadata['selectedSubCategoryId'] !=
                  curr.metadata['selectedSubCategoryId'],
              listener: (context, state) {
                final id = state.metadata['selectedSubCategoryId'] as int?;
                context.read<SalesBloc>().add(FilterByCategory(id));
              },
            ),
          ],
          child: BlocBuilder<SalesBloc, BaseState<ItemModel>>(
            builder: (context, state) {
              return CustomScrollView(
                slivers: [
                  HomeAppBar(isOnline: context.read<HomeBloc>().isOnline),

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
      ),
    );
  }
}
