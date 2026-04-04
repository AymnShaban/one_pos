part of '../../sales_imports.dart';


class SalesTab extends StatefulWidget {
  const SalesTab({super.key});

  // Hardcoded until categories API is wired — replace with bloc later
  static const List<CategoryFilterModel> _mockCategories = [
    CategoryFilterModel(id: '1', arName: 'مشروبات', enName: 'Beverages'),
    CategoryFilterModel(id: '2', arName: 'وجبات خفيفة', enName: 'Snacks'),
    CategoryFilterModel(id: '3', arName: 'ألبان', enName: 'Dairy'),
  ];

  @override
  State<SalesTab> createState() => _SalesTabState();
}

class _SalesTabState extends State<SalesTab> {
  @override
  void initState() {
    super.initState();
    context.read<SalesBloc>().add(const FetchProducts());
  }
  @override
  Widget build(BuildContext context) {
    return ProductListWrapper(
      child: Scaffold(
        backgroundColor: const Color(0xffF0F2F8),
        body: BlocBuilder<SalesBloc, BaseState<ItemModel>>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                HomeAppBar(isOnline: context.read<HomeBloc>().isOnline),

                // Search bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                    child: SalesSearchBar(
                      onChanged: (query) => context
                          .read<SalesBloc>()
                          .add(SearchProducts(query)),
                    ),
                  ),
                ),

                // Category filter
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: CategoryFilterBar(
                      categories: SalesTab._mockCategories,
                    ),
                  ),
                ),

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
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            // Load more trigger
                            if (index == state.items.length - 1) {
                              context.read<SalesBloc>().add(const LoadMoreProducts());
                            }
                            return ProductItemSelector(product: state.items[index]);
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
    );
  }
}
