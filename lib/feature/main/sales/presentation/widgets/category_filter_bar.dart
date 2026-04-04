part of '../../sales_imports.dart';

class CategoryFilterBar extends StatefulWidget {
  final List<CategoryFilterModel> categories;

  const CategoryFilterBar({super.key, required this.categories});

  @override
  State<CategoryFilterBar> createState() => _CategoryFilterBarState();
}

class _CategoryFilterBarState extends State<CategoryFilterBar> {
  String? _selectedId; // null = "All"

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return SizedBox(
      height: 42.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,

        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: widget.categories.length + 1, // +1 for "All"
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          // First item = "All"
          if (index == 0) {
            final isSelected = _selectedId == null;
            return _FilterChip(
              label: 'sales.all'.tr(),
              isSelected: isSelected,
              onTap: () {
                setState(() => _selectedId = null);
                context.read<SalesBloc>().add(const FilterByCategory(null));
              },
            );
          }

          final category = widget.categories[index - 1];
          final isSelected = _selectedId == category.id;

          return _FilterChip(
            label: isAr ? category.arName : category.enName,
            isSelected: isSelected,
            onTap: () {
              setState(() => _selectedId = category.id);
              context.read<SalesBloc>().add(FilterByCategory(category.id));
            },
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
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
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff3B5BDB) : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xff1A1A1A),
          ),
        ),
      ),
    );
  }
}