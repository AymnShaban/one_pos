part of '../../sales_imports.dart';

/// Horizontal child-category chip strip. Reads `SalesCategoryBloc` and
/// filters items by the currently selected parent.
class SubCategoryListView extends StatelessWidget {
  const SubCategoryListView({super.key});

  static const double _stripHeight = 36.0;

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return BlocBuilder<SalesCategoryBloc, BaseState<SalesCategoryModel>>(
      builder: (context, state) {
        return Container(
          height: _stripHeight.h,
          color: Colors.transparent,
          child: _buildContent(context, state, isAr),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    BaseState<SalesCategoryModel> state,
    bool isAr,
  ) {
    if (state.status == Status.loading) {
      return const Center(
        child: SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (state.status == Status.failure) {
      return Center(
        child: Text(
          state.errorMessage ?? 'error'.tr(),
          style: AppTextTheme.labelSmall.copyWith(color: Colors.red),
        ),
      );
    }

    final bloc = context.read<SalesCategoryBloc>();
    final children = bloc.currentChildren;
    if (children.isEmpty) {
      return Center(
        child: Text(
          'sales.no_sub_categories'.tr(),
          style: AppTextTheme.labelSmall.copyWith(color: AppColors.grey),
        ),
      );
    }

    final selectedId = state.metadata['selectedCategoryId'] as int?;

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
      itemCount: children.length,
      separatorBuilder: (_, __) => SizedBox(width: 8.w),
      itemBuilder: (context, index) {
        final sub = children[index];
        final isSelected = selectedId == sub.categoryId;

        return GestureDetector(
          onTap: () {
            if (isSelected) return;
            bloc.add(SelectSalesChild(sub.categoryId));
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.mainAppColor
                  : AppColors.whiteColor,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: isSelected
                    ? AppColors.mainAppColor
                    : Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                isAr ? sub.categoryArName : sub.categoryEnName,
                style: AppTextTheme.labelSmall.copyWith(
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
    );
  }
}
