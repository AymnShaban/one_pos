part of '../../new_invoice_imports.dart';

class CategoryListView extends StatelessWidget {
  const CategoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        // Loading
        if (state.mainCategories.status == Status.loading) {
          return SizedBox(
            height: 44.h,
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        final categories = state.mainCategories.items;
        if (categories.isEmpty) return const SizedBox();

        return Container(
          height: 44.h,
          color: AppColors.whiteColor,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            itemCount: categories.length,
            separatorBuilder: (_, __) => SizedBox(width: 8.w),
            itemBuilder: (context, index) {
              final cat        = categories[index];
              final isSelected = state.selectedMainIndex == index;
              return _CategoryChip(
                label:      isAr ? cat.categoryArName : cat.categoryEnName,
                isSelected: isSelected,
                onTap: () {
                  final branchId =
                      context.read<NewInvoiceBloc>().state.branchId;
                  context.read<CategoryBloc>().add(
                    SelectMainCategory(
                      index:      index,
                      categoryId: cat.categoryId,
                      branchId:   branchId,
                    ),
                  );
                  // Load products for this category
                  context.read<ProductBloc>().add(
                    LoadFirstPage(params: {
                      'categoryId': cat.categoryId,
                      'branchId':   branchId,
                      'customerId': -1,
                    }),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.mainAppColor
              : AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              blurRadius: 4,
            ),
          ],
        ),
        child: Text(
          label,
          style: AppTextTheme.caption.copyWith(
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.white : AppColors.black,
          ),
        ),
      ),
    );
  }
}