part of '../../sales_imports.dart';

class SubCategoryListView extends StatelessWidget {
  const SubCategoryListView({super.key});

  static const double _stripHeight = 44.0;

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return BlocBuilder<SubCategoryBloc, BaseState<SubCategoryModel>>(
      builder: (context, state) {
        return Container(
          height: _stripHeight.h,
          color: AppColors.backgroundColor,
          child: _buildContent(context, state, isAr),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    BaseState<SubCategoryModel> state,
    bool isAr,
  ) {
    if (state.status == Status.loading) {
      return const Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (state.status == Status.failure) {
      return Center(
        child: Text(
          state.errorMessage ?? 'error'.tr(),
          style: AppTextTheme.labelMedium11.copyWith(color: Colors.red),
        ),
      );
    }

    final subs = state.items;
    if (subs.isEmpty) {
      return Center(
        child: Text(
          'sales.no_sub_categories'.tr(),
          style: AppTextTheme.labelMedium11.copyWith(color: AppColors.grey),
        ),
      );
    }

    final selectedId = state.metadata['selectedSubCategoryId'] as int?;

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      itemCount: subs.length,
      separatorBuilder: (_, __) => SizedBox(width: 6.w),
      itemBuilder: (context, index) {
        final sub = subs[index];
        final isSelected = selectedId == sub.categoryId;

        return GestureDetector(
          onTap: () {
            if (isSelected) return;
            context
                .read<SubCategoryBloc>()
                .add(SelectSubCategory(sub.categoryId));
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
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
            child: Center(
              child: Text(
                isAr ? sub.categoryArName : (sub.categoryEnName ?? ''),
                style: AppTextTheme.labelMedium11.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? AppColors.mainAppColor
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
