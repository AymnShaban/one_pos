part of '../../sales_imports.dart';

class MainCategoryDropdown extends StatelessWidget {
  const MainCategoryDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return BlocBuilder<MainCategoryBloc, BaseState<MainCategoryModel>>(
      builder: (context, state) {
        if (state.status == Status.loading) {
          return _DropdownShell(
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.mainAppColor,
              ),
            ),
          );
        }

        final categories = state.items;
        if (categories.isEmpty) {
          return _DropdownShell(
            child: Text(
              'no_categories'.tr(),
              style: AppTextTheme.caption.copyWith(color: AppColors.grey),
            ),
          );
        }

        final selectedId =
            state.metadata['selectedMainCategoryId'] as int? ??
                categories.first.categoryId;

        return Container(
          height: 44.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: selectedId,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.mainAppColor,
              ),
              borderRadius: BorderRadius.circular(10.r),
              style: AppTextTheme.caption.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
              items: categories
                  .map(
                    (c) => DropdownMenuItem<int>(
                      value: c.categoryId,
                      child: Text(
                        isAr ? c.categoryArName : c.categoryEnName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (id) {
                if (id == null || id == selectedId) return;
                context.read<MainCategoryBloc>().add(SelectMainCategory(id));
              },
            ),
          ),
        );
      },
    );
  }
}

class _DropdownShell extends StatelessWidget {
  final Widget child;

  const _DropdownShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}
