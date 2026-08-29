import 'package:easy_localization/easy_localization.dart';

import '../../../../../../core/helper/helper.dart';

class SelectedIcon extends StatelessWidget {
  const SelectedIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: const BoxDecoration(
        color: AppColors.brand,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.check,
        color: Colors.white,
        size: 14.sp,
      ),
    );
  }
}
void showLookupPicker<T>({
  required BuildContext context,
  required String title,
  required List<T> items,
  required bool Function(T item) isSelected,
  required String Function(T item) titleBuilder,
  String Function(T item)? subtitleBuilder,
  required void Function(T item) onSelected,
}) {
  if (items.isEmpty) {
    showNoDataSnackBar(context);
    return;
  }

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      titlePadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 12.h),
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 300.h,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          itemCount: items.length,
          separatorBuilder: (context, index) => Divider(
            height: 1.h,
            color: const Color(0xFFEEF1F7),
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            final selected = isSelected(item);
            return ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 4.h,
              ),
              title: Text(
                titleBuilder(item),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  color: selected ? AppColors.brand : AppColors.textDark,
                ),
              ),
              subtitle: subtitleBuilder != null
                  ? Text(
                subtitleBuilder(item),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textMuted,
                ),
              )
                  : null,
              trailing: selected ? const SelectedIcon() : null,
              onTap: () {
                onSelected(item);
                Navigator.of(dialogContext).pop();
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(
            'cancel'.tr(),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textMuted,
            ),
          ),
        ),
      ],
      actionsPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    ),
  );
}

void showNoDataSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('no_data_available'.tr()),
      backgroundColor: AppColors.red,
    ),
  );
}