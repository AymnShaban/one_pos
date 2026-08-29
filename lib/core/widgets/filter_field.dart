// core/widgets/filter_field.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/app_colors.dart';

class FilterField extends StatelessWidget {
  final String label;
  final String? value;
  final String placeholder;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onClear;
  final IconData? icon;
  final bool isCompact;
  final List<String>? options;
  final bool enableSearch;
  final Function(String?)? onChanged;
  final String? searchHint;

  const FilterField({
    super.key,
    required this.label,
    this.value,
    required this.placeholder,
    this.isSelected = false,
    this.onTap,
    this.onClear,
    this.icon,
    this.isCompact = false,
    this.options,
    this.enableSearch = false,
    this.onChanged,
    this.searchHint,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!();
        } else if (options != null && options!.isNotEmpty) {
          _showSelectionDialog(context);
        }
      },
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isCompact ? 12.w : 16.w,
          vertical: isCompact ? 10.h : 12.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? AppColors.line : AppColors.line,
            width: isSelected ? 1 : 1,
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppColors.blueBg,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Icon(
                  icon,
                  color: AppColors.blue,
                  size: isCompact ? 14.sp : 16.sp,
                ),
              ),
              SizedBox(width: isCompact ? 8.w : 12.w),
            ],
            Expanded(
              child: Text(
                value ?? placeholder,
                style: TextStyle(
                  fontSize: isCompact ? 12.sp : 14.sp,
                  color: isSelected ? AppColors.textDark : AppColors.textMuted,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected && onClear != null)
              InkWell(
                onTap: onClear,
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  child: Icon(
                    Icons.close,
                    color: AppColors.textMuted,
                    size: isCompact ? 16.sp : 18.sp,
                  ),
                ),
              ),
            if (!isSelected)
              Icon(
                Icons.arrow_drop_down,
                color: AppColors.textMuted,
                size: isCompact ? 20.sp : 24.sp,
              ),
          ],
        ),
      ),
    );
  }

  void _showSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => FilterDialog(
        title: label,
        options: options!,
        enableSearch: enableSearch,
        searchHint: searchHint ?? 'Search...',
        onSelected: (selected) {
          if (onChanged != null) {
            onChanged!(selected);
          }
          Navigator.pop(dialogContext);
        },
      ),
    );
  }
}

class FilterDialog extends StatefulWidget {
  final String title;
  final List<String> options;
  final bool enableSearch;
  final String searchHint;
  final Function(String) onSelected;

  const FilterDialog({
    super.key,
    required this.title,
    required this.options,
    this.enableSearch = false,
    this.searchHint = 'Search...',
    required this.onSelected,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String searchQuery = '';

  List<String> get filteredOptions {
    if (searchQuery.isEmpty) return widget.options;
    return widget.options.where((option) =>
        option.toLowerCase().contains(searchQuery.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      titlePadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 12.h),
      contentPadding: EdgeInsets.zero,
      title: Text(
        widget.title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 400.h,
        child: Column(
          children: [
            if (widget.enableSearch) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Container(
                  height: 44.h,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.mainAppColor),
                  ),
                  child: TextField(
                    autofocus: true,
                    onChanged: (value) => setState(() => searchQuery = value),
                    style: TextStyle(fontSize: 14.sp),
                    decoration: InputDecoration(
                      hintText: widget.searchHint,
                      hintStyle: TextStyle(color: AppColors.textMuted),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.textMuted,
                        size: 20.sp,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
            Expanded(
              child: filteredOptions.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 48.sp,
                      color: AppColors.textMuted,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'no_results_found'.tr(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                itemCount: filteredOptions.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1.h,
                  color: AppColors.line,
                ),
                itemBuilder: (context, index) {
                  final option = filteredOptions[index];
                  return Material(
                    color: Colors.transparent,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 4.h,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: AppColors.backgroundColor,
                        radius: 16.r,
                        child: Text(
                          option.isNotEmpty ? option[0].toUpperCase() : '?',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        option,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.normal,
                          color: AppColors.textDark,
                        ),
                      ),
                      onTap: () => widget.onSelected(option),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
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
    );
  }
}