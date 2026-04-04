part of '../../new_invoice_imports.dart';

class SubCategoryListView extends StatelessWidget {
  const SubCategoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        // Loading
        if (state.subCategories.status == Status.loading) {
          return SizedBox(
            height: 36.h,
            child: const Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        final subs = state.subCategories.items;
        if (subs.isEmpty) return const SizedBox();

        return Container(
          height: 38.h,
          color: AppColors.backgroundColor,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            itemCount: subs.length,
            separatorBuilder: (_, __) => SizedBox(width: 6.w),
            itemBuilder: (context, index) {
              final sub        = subs[index];
              final isSelected = state.selectedSubIndex == index;

              return GestureDetector(
                onTap: () {
                  context.read<CategoryBloc>().add(
                    SelectSubCategory(
                      index:      index,
                      categoryId: sub.categoryId,
                    ),
                  );
                  // Load products for this sub-category
                  context.read<ProductBloc>().add(
                    LoadFirstPage(params: {
                      'categoryId': sub.categoryId,
                      'branchId':
                      context.read<NewInvoiceBloc>().state.branchId,
                      'customerId': -1,
                    }),
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                  EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.mainAppColor.withValues(alpha: 0.12)
                        : AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.mainAppColor
                          : Colors.transparent,
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    isAr ? sub.categoryArName : sub.categoryEnName,
                    style: AppTextTheme.labelMedium11.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.mainAppColor
                          : AppColors.black,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}