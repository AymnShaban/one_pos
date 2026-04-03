part of '../../reports_imports.dart';

class TopProductsList extends StatelessWidget {
  final List<TopProductModel> products;

  const TopProductsList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              'أكثر المنتجات مبيعاً',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xff1A1A1A),
              ),
            ),
          ),
          const Divider(height: 1),
          ...products.asMap().entries.map((entry) {
            final isLast = entry.key == products.length - 1;
            return Column(
              children: [
                _TopProductItem(product: entry.value),
                if (!isLast) const Divider(height: 1, indent: 16, endIndent: 16),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _TopProductItem extends StatelessWidget {
  final TopProductModel product;

  const _TopProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          // Amount — left
          Text(
            '${product.totalAmount.toStringAsFixed(2)} ر.س',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xff40C057),
            ),
          ),
          const Spacer(),

          // Name + units — right
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                product.name,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff1A1A1A),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                '${product.unitsSold} وحدة',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: const Color(0xff8A8F99),
                ),
              ),
            ],
          ),
          SizedBox(width: 12.w),

          // Rank badge
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: const Color(0xffEEF2FF),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: Text(
                '${product.rank}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff3B5BDB),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}