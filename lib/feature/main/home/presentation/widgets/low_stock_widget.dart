part of '../../home_imports.dart';

class LowStockWidget extends StatefulWidget {
  final int top;

  const LowStockWidget({
    super.key,
    this.top = 5,
  });

  @override
  State<LowStockWidget> createState() => _LowStockWidgetState();
}

class _LowStockWidgetState extends State<LowStockWidget> {
  bool _showItems = true;
  static const int _initialDisplayCount = 5;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LowStockBloc, BaseState<List<LowStockItemModel>>>(
      builder: (context, state) {
        if (state.status == Status.loading) {
          return const SizedBox.shrink();
        }

        if (state.status == Status.failure) {
          return _buildErrorState(
            message: state.errorMessage ?? 'error_loading'.tr(),
            onRetry: () => context.read<LowStockBloc>().add(
              LoadLowStockItems(top: widget.top),
            ),
          );
        }

        final items = state.data;
        if (items == null || items.isEmpty) {
          return _buildEmptyState();
        }

        return _buildContent(items);
      },
    );
  }

  Widget _buildErrorState({
    required String message,
    required VoidCallback onRetry,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildErrorHeader(onRetry),
          SizedBox(height: 10.h),
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.error_outline,
                  color: AppColors.red,
                  size: 32.sp,
                ),
                SizedBox(height: 8.h),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorHeader(VoidCallback onRetry) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 18.h,
          decoration: BoxDecoration(
            color: const Color(0xff3B5BDB),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            'low_stock'.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xff1A1A1A),
            ),
          ),
        ),
        InkWell(
          onTap: onRetry,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.refresh_rounded,
              color: const Color(0xff3B5BDB),
              size: 20.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(0, false),
          SizedBox(height: 10.h),
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.inventory,
                  color: AppColors.textMuted,
                  size: 32.sp,
                ),
                SizedBox(height: 8.h),
                Text(
                  'no_low_stock'.tr(),
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(List<LowStockItemModel> items) {
    final totalItems = items.length;
    final hasMoreItems = totalItems > _initialDisplayCount;

    final displayItems = _showItems
        ? items.take(_initialDisplayCount).toList()
        : [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        _buildHeader(totalItems, hasMoreItems),
        SizedBox(height: 8.h), // ✅ مسافة بين الهيدر والقائمة

        // List
        if (_showItems && displayItems.isNotEmpty)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayItems.length,
            padding: EdgeInsets.zero, // ✅ إزالة padding الداخلي
            separatorBuilder: (_, __) => Divider(
              height: 4.h,
              color: AppColors.line.withOpacity(0.3),
            ),
            itemBuilder: (context, index) {
              final item = displayItems[index];
              return _buildItem(item);
            },
          ),
      ],
    );
  }

  Widget _buildHeader(int totalItems, bool hasMoreItems) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 18.h,
          decoration: BoxDecoration(
            color: const Color(0xff3B5BDB),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 8.w),

        Expanded(
          child: Text(
            'low_stock'.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xff1A1A1A),
            ),
          ),
        ),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$totalItems ${'items'.tr()}',
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.textMuted,
              ),
            ),
            SizedBox(width: 6.w), // ✅ مسافة بين النص والسهم

            // ✅ السهم يظهر فقط لو فيه عناصر
            if (totalItems > 0)
              InkWell(
                borderRadius: BorderRadius.circular(12.r),
                onTap: () {
                  setState(() {
                    _showItems = !_showItems;
                  });
                },
                child: Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: AnimatedRotation(
                    turns: _showItems ? 0 : 0.5,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xff8A8F99),
                      size: 24,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildItem(LowStockItemModel item) {
    final isCritical = item.totalQty < -100;
    final isWarning = item.totalQty < -10;
    final isRTL = context.locale.languageCode == 'ar';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h), // ✅ مسافة داخلية
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 20.h,
            decoration: BoxDecoration(
              color: isCritical
                  ? AppColors.red
                  : isWarning
                  ? AppColors.orange
                  : const Color(0xFFFFD700),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(width: 10.w),

          Expanded(
            child: Text(
              !isRTL
                  ? (item.mteName?.isNotEmpty == true
                  ? item.mteName!
                  : item.mtName ?? 'item_name'.tr())
                  : (item.mtName?.isNotEmpty == true
                  ? item.mtName!
                  : item.mteName ?? 'item_name'.tr()),
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xff1A1A1A),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: isCritical
                  ? AppColors.red.withOpacity(0.12)
                  : isWarning
                  ? AppColors.orange.withOpacity(0.12)
                  : const Color(0xFFFFD700).withOpacity(0.15),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              item.totalQty.toStringAsFixed(0),
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: isCritical
                    ? AppColors.red
                    : isWarning
                    ? AppColors.orange
                    : const Color(0xFFD4A800),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.r),
      border: Border.all(
        color: AppColors.line.withOpacity(0.3),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 12.r,
          offset: Offset(0, 4.h),
        ),
      ],
    );
  }
}