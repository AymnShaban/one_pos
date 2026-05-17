part of '../../sales_imports.dart';

class MainCategoryDropdown extends StatelessWidget {
  const MainCategoryDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return BlocBuilder<MainCategoryBloc, BaseState<MainCategoryModel>>(
      builder: (context, state) {
        if (state.status == Status.loading) {
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

        final categories = state.items;
        if (categories.isEmpty) {
          return SizedBox(
            height: 36.h,
            child: Center(
              child: Text(
                'no_categories'.tr(),
                style: AppTextTheme.caption.copyWith(color: AppColors.grey),
              ),
            ),
          );
        }

        final selectedId =
            state.metadata['selectedMainCategoryId'] as int? ??
                categories.first.categoryId;

        return SizedBox(
          height: 36.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: categories.length,
            separatorBuilder: (_, __) => SizedBox(width: 10.w),
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedId == category.categoryId;

              return GestureDetector(
                onTap: () {
                  if (isSelected) return;
                  context
                      .read<MainCategoryBloc>()
                      .add(SelectMainCategory(category.categoryId));
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.mainAppColor
                        : AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.mainAppColor
                          : Colors.grey.shade300,
                      width: 1.2,
                    ),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: AppColors.mainAppColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      isAr ? category.categoryArName : category.categoryEnName,
                      style: AppTextTheme.body2.copyWith(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isSelected
                            ? AppColors.whiteColor
                            : AppColors.black,
                      ),
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
