import 'package:easy_localization/easy_localization.dart';
import '../../branch_profit_import.dart';


class DisplayLevelSection extends StatefulWidget {
  final bool byAccount;
  final ValueChanged<bool> onChanged;

  const DisplayLevelSection({
    super.key,
    required this.byAccount,
    required this.onChanged,
  });

  @override
  State<DisplayLevelSection> createState() => _DisplayLevelSectionState();
}

class _DisplayLevelSectionState extends State<DisplayLevelSection> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== الهيدر =====
          Row(
            children: [

              Expanded(
                child: Text(
                  'display_level'.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  widget.byAccount ? 'by_account'.tr() : 'by_cost_center'.tr(),
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 8.w),

              InkWell(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: AppColors.line.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.textMuted,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),


          if (_isExpanded)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRadioOption(
                  value: true,
                  label: 'by_account'.tr(),

                  isSelected: widget.byAccount == true,
                  onTap: () => widget.onChanged(true),
                ),
                _buildRadioOption(
                  value: false,
                  label: 'by_cost_center'.tr(),

                  isSelected: widget.byAccount == false,
                  onTap: () => widget.onChanged(false),
                ),
              ],
            )

        ],
      ),
    );
  }

  Widget _buildRadioOption({
    required bool value,
    required String label,


    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final color = AppColors.blue;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Row(
          children: [
            // Radio Button
            Container(
              width: 16.w,
              height: 16.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? color : AppColors.line,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                child: Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                ),
              )
                  : null,
            ),
            SizedBox(width: 12.w),


            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? color : AppColors.textDark,
                    ),
                  ),

                ],
              ),
            ),

            if (isSelected)
              Icon(
                Icons.check_circle,
                color: color,
                size: 18.sp,
              ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16.r),
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
class OrderBySection extends StatefulWidget {
  final bool orderByBranch;
  final ValueChanged<bool> onChanged;

  const OrderBySection({
    super.key,
    required this.orderByBranch,
    required this.onChanged,
  });

  @override
  State<OrderBySection> createState() => _OrderBySectionState();
}

class _OrderBySectionState extends State<OrderBySection> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              Expanded(
                child: Text(
                  'order_by'.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  widget.orderByBranch ? 'order_by_branch'.tr() : 'order_by_month'.tr(),
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 8.w),

              InkWell(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: AppColors.line.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.textMuted,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),


          if (_isExpanded)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRadioOption(
                  value: true,
                  label: 'order_by_branch'.tr(),


                  isSelected: widget.orderByBranch == true,
                  onTap: () => widget.onChanged(true),
                ),
                _buildRadioOption(
                  value: false,
                  label: 'order_by_month'.tr(),

                  isSelected: widget.orderByBranch == false,
                  onTap: () => widget.onChanged(false),
                ),
              ],
            )

        ],
      ),
    );
  }

  Widget _buildRadioOption({
    required bool value,
    required String label,


    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final color = AppColors.blue;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            // Radio Button
            Container(
              width: 16.w,
              height: 16.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? color : AppColors.line,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                child: Container(
                  width: 8.w,
                  height:8.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                ),
              )
                  : null,
            ),
            SizedBox(width: 12.w),

            // النص
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? color : AppColors.textDark,
                    ),
                  ),

                ],
              ),
            ),

            if (isSelected)
              Icon(
                Icons.check_circle,
                color: color,
                size: 18.sp,
              ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16.r),
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