part of '../../home_imports.dart';

class TopSellingWidget extends StatefulWidget {
  final int top;

  const TopSellingWidget({
    super.key,
    this.top = 5,
  });

  @override
  State<TopSellingWidget> createState() => _TopSellingWidgetState();
}

class _TopSellingWidgetState extends State<TopSellingWidget> {
  bool _isExpanded = false;
  bool _showItems = true;
  static const int _initialDisplayCount = 5;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopSellingBloc, BaseState<List<TopSellingItemModel>>>(
      builder: (context, state) {
        if (state.status == Status.loading) {
          return const SizedBox.shrink();
        }

        if (state.status == Status.failure) {
          return _buildErrorState(
            message: state.errorMessage ?? 'error_loading'.tr(),
            onRetry: () => context.read<TopSellingBloc>().add(
              LoadTopSellingItems(top: widget.top),
            ),
          );
        }

        final items = state.data;
        return _buildContent(items ?? []);
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
        // الخط الأزرق
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
            'top_selling'.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xff1A1A1A),
            ),
          ),
        ),
        // Retry Icon
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

  Widget _buildContent(List<TopSellingItemModel> items) {
    final totalItems = items.length;
    final hasMoreItems = totalItems > _initialDisplayCount;

    List<TopSellingItemModel> displayItems;
    if (!_showItems) {
      displayItems = [];
    } else if (_isExpanded) {
      displayItems = items;
    } else {
      displayItems = items.take(_initialDisplayCount).toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        _buildHeader(totalItems, hasMoreItems),
        SizedBox(height: 8.h),

        // List
        if (_showItems && displayItems.isNotEmpty)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayItems.length,
            padding: EdgeInsets.zero,
            separatorBuilder: (_, __) => Divider(
              height: 4.h,
              color: AppColors.line.withOpacity(0.3),
            ),
            itemBuilder: (context, index) {
              final item = displayItems[index];
              return _buildItem(item, index);
            },
          ),
      ],
    );
  }

  Widget _buildHeader(int totalItems, bool hasMoreItems) {
    return Row(
      children: [
        // الخط الأزرق
        Container(
          width: 4.w,
          height: 18.h,
          decoration: BoxDecoration(
            color: const Color(0xff3B5BDB),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 8.w),

        // Title
        Expanded(
          child: Text(
            'top_selling'.tr(),
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
            SizedBox(width: 6.w),

            // السهم - يظهر فقط لو فيه عناصر
            if (totalItems > 0)
              InkWell(
                borderRadius: BorderRadius.circular(12.r),
                onTap: () {
                  setState(() {
                    if (_showItems) {
                      _showItems = false;
                      _isExpanded = false;
                    } else {
                      _showItems = true;
                      _isExpanded = false;
                    }
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

  Widget _buildItem(TopSellingItemModel item, int index) {
    final isTopThree = index < 3;
    final isRTL = context.locale.languageCode == 'ar';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          // Rank Badge
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              color: isTopThree
                  ? _getRankColor(index)
                  : AppColors.line.withOpacity(0.3),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: isTopThree ? Colors.white : AppColors.textMuted,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),

          // Item Name
          Expanded(
            child: Text(
              isRTL
                  ? (item.arName?.isNotEmpty == true
                  ? item.arName!
                  : item.enName ?? 'item_name'.tr())
                  : (item.enName?.isNotEmpty == true
                  ? item.enName!
                  : item.arName ?? 'item_name'.tr()),
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xff1A1A1A),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Revenue & Quantity
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.getFormattedRevenue() ?? '0',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blue,
                ),
              ),
              Text(
                '${item.totalQty?.toStringAsFixed(0) ?? '0'} ${'units'.tr()}',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFFFD700); // Gold
      case 1:
        return const Color(0xFFC0C0C0); // Silver
      case 2:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return AppColors.line.withOpacity(0.3);
    }
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