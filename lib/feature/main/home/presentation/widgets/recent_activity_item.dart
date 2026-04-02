import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecentActivityItem extends StatelessWidget {
  final String name;
  final String invoiceId;
  final String timeAgo;
  final double amount;
  final String status;

  const RecentActivityItem({
    super.key,
    required this.name,
    required this.invoiceId,
    required this.timeAgo,
    required this.amount,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          // Left: amount + status
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${amount.toInt()} ر.س',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff1A1A1A),
                ),
              ),
              SizedBox(height: 4.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          // Right: name + invoice + time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff1A1A1A),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '$invoiceId • $timeAgo',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: const Color(0xff8A8F99),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}