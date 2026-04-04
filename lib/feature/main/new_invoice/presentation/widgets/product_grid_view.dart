part of '../../new_invoice_imports.dart';

class ProductGridView extends StatelessWidget {
  const ProductGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, BaseState<ItemModel>>(
      builder: (context, state) {
        // ── Loading ──
        if (state.status == Status.loading) {
          return const Expanded(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        // ── Failure ──
        if (state.status == Status.failure) {
          return Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline,
                      color: AppColors.red, size: 40.sp),
                  SizedBox(height: 8.h),
                  Text(
                    state.errorMessage ?? 'common.error'.tr(),
                    style: AppTextTheme.body2.copyWith(color: AppColors.red),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12.h),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<ProductBloc>().add(LoadFirstPage()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainAppColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r)),
                      elevation: 0,
                    ),
                    child: Text(
                      'common.retry'.tr(),
                      style: AppTextTheme.caption
                          .copyWith(color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // ── Empty ──
        if (state.items.isEmpty && state.status == Status.success) {
          return Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.inventory_2_outlined,
                      color: AppColors.grey, size: 48.sp),
                  SizedBox(height: 12.h),
                  Text(
                    'sales.no_products'.tr(),
                    style: AppTextTheme.body2.copyWith(color: AppColors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        // ── Data ──
        return Expanded(
          child: ProductListWrapper(
            child: PullToRefresh(
              enableRefresh: true,
              enableLoadMore: true,
              onRefresh: () async {
                context.read<ProductBloc>().add(LoadFirstPage());
              },
              onLoadMore: () async {
                context.read<ProductBloc>().add(LoadNextPage());
              },
              builder: (scrollController) {
                return GridView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 100.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:   2,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing:  10.h,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: state.items.length +
                      (state.status == Status.isLoadingMore ? 2 : 0),
                  itemBuilder: (context, index) {
                    // Load more placeholder cells
                    if (index >= state.items.length) {
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }

                    return ProductItemSelector(
                      product: state.items[index],
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}