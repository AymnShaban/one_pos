part of '../../../basket_imports.dart';

extension AccountSearchExt on _BasketPosSummaryState {
  Widget _buildAccountSearch() {
    final isAr = context.locale.languageCode == 'ar';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'new_invoice.to_account'.tr(),
          style: AppTextTheme.labelSmall9Bold,
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _openCustomerSearch,
                child: Container(
                  height: 30.h,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.mainAppColor),
                  ),
                  child: Text(
                    _selectedAccount != null
                        ? _selectedAccount!.displayName(isAr)
                        : 'new_invoice.search_account'.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _selectedAccount != null
                        ? AppTextTheme.captionBold
                        : AppTextTheme.caption,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            ElevatedButton(
              onPressed: _openCustomerSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tealAccentColor,
                minimumSize: Size(80.w, 30.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'common.search'.tr(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
