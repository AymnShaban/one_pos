part of '../../invoices_imports.dart';

class InvoiceCard extends StatelessWidget {
  final InvoiceModel invoice;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onPrint;
  final VoidCallback onView;

  const InvoiceCard({
    super.key,
    required this.invoice,
    required this.onDelete,
    required this.onEdit,
    required this.onPrint,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
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
          // Top row: invoice number + status badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatusBadge(status: invoice.status),
              Text(
                invoice.invoiceNumber,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff1A1A1A),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),

          // Customer name
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              invoice.customerName,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xff1A1A1A),
              ),
            ),
          ),
          SizedBox(height: 4.h),

          // Date
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              DateFormat('yyyy/MM/dd • hh:mm a', 'ar').format(invoice.dateTime),
              style: TextStyle(
                fontSize: 11.sp,
                color: const Color(0xff8A8F99),
              ),
            ),
          ),

          const Divider(height: 20),

          // Bottom row: actions left | product count right
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Product count
              Text(
                'invoices.products_count'.tr(namedArgs: {'count': '${invoice.productCount}'}),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xff8A8F99),
                ),
              ),

              // Action icons
              Row(
                children: [
                  _ActionIcon(
                    icon: Icons.visibility_outlined,
                    color: const Color(0xff3B5BDB),
                    onTap: onView,
                  ),
                  SizedBox(width: 12.w),
                  _ActionIcon(
                    icon: Icons.print_outlined,
                    color: const Color(0xff40C057),
                    onTap: onPrint,
                  ),
                  SizedBox(width: 12.w),
                  _ActionIcon(
                    icon: Icons.edit_outlined,
                    color: const Color(0xffF59F00),
                    onTap: onEdit,
                  ),
                  SizedBox(width: 12.w),
                  _ActionIcon(
                    icon: Icons.cancel_outlined,
                    color: const Color(0xffFA5252),
                    onTap: onDelete,
                  ),
                ],
              ),
            ],
          ),

          // Remaining amount (only for pending)
          if (invoice.status == InvoiceStatus.pending &&
              invoice.remainingAmount != null) ...[
            SizedBox(height: 6.h),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${'invoices.remaining'.tr()}: ${invoice.remainingAmount!.toStringAsFixed(2)} ${'sales.SAR'.tr()}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xffFA5252),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],

          SizedBox(height: 6.h),

          // Amount
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${invoice.totalAmount.toStringAsFixed(2)} ${'sales.SAR'.tr()}',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xff1A1A1A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final InvoiceStatus status;

  const _StatusBadge({required this.status});

  Color get _bgColor {
    switch (status) {
      case InvoiceStatus.completed: return const Color(0xffD3F9D8);
      case InvoiceStatus.pending:   return const Color(0xffFFF3BF);
      case InvoiceStatus.cancelled: return const Color(0xffFFE3E3);
      default:                       return const Color(0xffE9ECEF);
    }
  }

  Color get _textColor {
    switch (status) {
      case InvoiceStatus.completed: return const Color(0xff2F9E44);
      case InvoiceStatus.pending:   return const Color(0xffE67700);
      case InvoiceStatus.cancelled: return const Color(0xffFA5252);
      default:                       return const Color(0xff495057);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status.name,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: _textColor,
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionIcon({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: color, size: 22.sp),
    );
  }
}