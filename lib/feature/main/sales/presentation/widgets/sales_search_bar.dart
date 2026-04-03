part of '../../sales_imports.dart';

class SalesSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const SalesSearchBar({super.key, required this.onChanged});

  @override
  State<SalesSearchBar> createState() => _SalesSearchBarState();
}

class _SalesSearchBarState extends State<SalesSearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        textAlign: TextAlign.right,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: 'search_product'.tr(),
          hintStyle: TextStyle(
            color: const Color(0xff8A8F99),
            fontSize: 14.sp,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: const Color(0xff8A8F99),
            size: 22.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
        ),
      ),
    );
  }
}