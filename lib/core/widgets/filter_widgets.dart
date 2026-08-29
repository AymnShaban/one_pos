

import '../helper/helper.dart';



class FilterSectionLabel extends StatelessWidget {
  final String title;
  final String? count;
  const FilterSectionLabel({super.key, required this.title, this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(2.w, 16.h, 2.w, 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Container(
              width: 6.w,
              height: 6.h,
              decoration: const BoxDecoration(color: AppColors.brand, shape: BoxShape.circle),
            ),
            SizedBox(width: 6.w),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.5.sp,
                color: AppColors.brandDark,
              ),
            ),
          ]),
          if (count != null)
            Text(
              count!,
              style: TextStyle(
                fontSize: 10.5.sp,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}

class FilterFieldTile extends StatelessWidget {
  final String? label;
  final String value;
  final String placeholder;
  final IconData trailingIcon;
  final VoidCallback onTap;

  const FilterFieldTile({
    super.key,
    this.label,
    required this.value,
    this.placeholder = "اختر…",
    this.trailingIcon = Icons.search,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: EdgeInsets.only(right: 2.w, bottom: 5.h),
            child: Text(label!, style: TextStyle(fontSize: 11.sp, color: AppColors.textMuted)),
          ),
        InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 11.h),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.line),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  hasValue ? value : placeholder,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: hasValue ? FontWeight.w600 : FontWeight.normal,
                    color: hasValue ? AppColors.textDark : AppColors.textMuted,
                  ),
                ),
                Icon(trailingIcon, size: 16.sp, color: AppColors.textMuted),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SegmentedFilter extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const SegmentedFilter({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFFE8ECF3),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: List.generate(options.length, (i) {
          final active = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 9.h),
                decoration: BoxDecoration(
                  color: active ? AppColors.card : Colors.transparent,
                  borderRadius: BorderRadius.circular(9.r),
                  boxShadow: active
                      ? [
                    BoxShadow(
                      color: AppColors.brandDark.withOpacity(0.15),
                      blurRadius: 6.r,
                      offset: Offset(0, 2.h),
                    ),
                  ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  options[i],
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: active ? AppColors.brandDark : AppColors.textMuted,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
class FilterDropdownField<T> extends StatelessWidget {
  final String? label;
  final T value;
  final List<T> items;
  final String Function(T item) itemText;
  final ValueChanged<T?> onChanged;

  const FilterDropdownField({
    super.key,
    this.label,
    required this.value,
    required this.items,
    required this.itemText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: EdgeInsets.only(right: 2.w, bottom: 5.h),
            child: Text(
              label!,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.textMuted,
              ),
            ),
          ),
        Container(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.line),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              isExpanded: true,
              value: value,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.textMuted,
              ),
              dropdownColor: AppColors.card,
              borderRadius: BorderRadius.circular(12.r),
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
              items: items.map((e) {
                return DropdownMenuItem<T>(
                  value: e,
                  child: Text(
                    itemText(e),
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
class DateFieldTile extends StatelessWidget {
  final String label;
  final DateTime value;
  final ValueChanged<DateTime> onChanged;

  const DateFieldTile({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  Future<void> _pick(BuildContext context) async {
    final picked = await AppDatePicker.show(
      context: context,
      initialDate: value,
    );

    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: () => _pick(context),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.line),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 10.sp, color: AppColors.textMuted)),
              SizedBox(height: 4.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}",
                    style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w600),
                  ),
                  Icon(Icons.calendar_today, size: 14.sp, color: AppColors.textMuted),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ToggleOption {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  ToggleOption({
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });
}


class ToggleCard extends StatelessWidget {
  final List<ToggleOption> options;
  const ToggleCard({super.key, required this.options});

  @override
  Widget build(BuildContext context) {

    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(18.r),
      child: Column(
        children: List.generate(options.length, (i) {
          final o = options[i];
          return Column(
            children: [
              SwitchListTile.adaptive(
                value: o.value,
                onChanged: o.onChanged,
                activeColor: AppColors.brand,
                dense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
                title: Text(
                  o.title,
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: o.subtitle != null
                    ? Text(
                  o.subtitle!,
                  style: TextStyle(
                    fontSize: 10.5.sp,
                    color: AppColors.textMuted,
                  ),
                )
                    : null,
              ),
              if (i != options.length - 1)
                Divider(
                  height: 1.h,
                  color: AppColors.line,
                ),
            ],
          );
        }),
      ),
    );
  }
}
/// شرائح (Chips) قابلة للحذف لعرض الحسابات المختارة في فلتر متعدد (مثل
/// شاشة تحليل المصروفات التي تسمح باختيار أكثر من حساب).
class RemovableChipsRow extends StatelessWidget {
  final List<String> items;
  final ValueChanged<int> onRemove;
  final VoidCallback onAdd;

  const RemovableChipsRow({
    super.key,
    required this.items,
    required this.onRemove,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6.w,
      runSpacing: 6.h,
      children: [
        for (var i = 0; i < items.length; i++)
          InputChip(
            label: Text(
              items[i],
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.brandDark),
            ),
            backgroundColor: AppColors.brandLight,
            onDeleted: () => onRemove(i),
          ),
        ActionChip(
          label: Text(
            "+ إضافة",
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.brandDark),
          ),
          backgroundColor: AppColors.brandLight,
          onPressed: onAdd,
        ),
      ],
    );
  }
}


class FilterBottomBar extends StatelessWidget {
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final bool isLoading;

  const FilterBottomBar({
    super.key,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
        decoration: const BoxDecoration(
          color: AppColors.card,
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: Row(
          children: [
            if (secondaryLabel != null) ...[
              Expanded(
                flex: 6,
                child: OutlinedButton(
                  onPressed: isLoading ? null : onSecondary,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFEEF1F7),
                    side: BorderSide.none,
                    padding: EdgeInsets.symmetric(vertical: 13.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: Text(
                    secondaryLabel!,
                    style: TextStyle(
                      color: isLoading ? AppColors.textMuted.withOpacity(0.5) : AppColors.textMuted,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
            ],
            Expanded(
              flex: 10,
              child: Container(
                decoration: BoxDecoration(
                  gradient: isLoading
                      ? const LinearGradient(colors: [Colors.grey, Colors.grey])
                      : const LinearGradient(colors: [AppColors.brand, AppColors.brandDark]),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: ElevatedButton(
                  onPressed: isLoading ? null : onPrimary,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 13.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: isLoading
                      ? SizedBox(
                    height: 20.h,
                    width: 20.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : Text(
                    primaryLabel,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}