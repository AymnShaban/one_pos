import 'package:easy_localization/easy_localization.dart';
import '../../branch_profit_import.dart';



class DailySalesSection extends StatefulWidget {
  final bool isEnabled;
  final DateTime dailyFrom;
  final DateTime dailyTo;
  final ValueChanged<bool> onEnabledChanged;
  final ValueChanged<DateTime> onDailyFromChanged;
  final ValueChanged<DateTime> onDailyToChanged;

  const DailySalesSection({
    super.key,
    required this.isEnabled,
    required this.dailyFrom,
    required this.dailyTo,
    required this.onEnabledChanged,
    required this.onDailyFromChanged,
    required this.onDailyToChanged,
  });

  @override
  State<DailySalesSection> createState() => _DailySalesSectionState();
}

class _DailySalesSectionState extends State<DailySalesSection> {
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
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.blue, AppColors.blue.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.today,
                  color: AppColors.white,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'daily_sales'.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
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
              children: [
                // Toggle Button
                _buildToggleButton(),


                if (widget.isEnabled) _buildDateFields(),
              ],
            )

        ],
      ),
    );
  }

  Widget _buildToggleButton() {
    final color = AppColors.blue;

    return InkWell(
      onTap: () => widget.onEnabledChanged(!widget.isEnabled),
      borderRadius: BorderRadius.circular(8.r),
      child: Container(

        child: Row(
          children: [

            Container(
              padding: EdgeInsets.all(8.w),

              child: Icon(
                widget.isEnabled ? Icons.check_circle : Icons.circle_outlined,
                color: widget.isEnabled ? color : AppColors.textMuted,
                size: 16.sp,
              ),
            ),
            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    !widget.isEnabled ? 'daily_sales_enabled'.tr() : 'daily_sales_disabled'.tr(),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: widget.isEnabled ? FontWeight.w600 : FontWeight.w400,
                      color: widget.isEnabled ? color : AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    widget.isEnabled
                        ? 'daily_sales_enabled_hint'.tr()
                        : 'daily_sales_disabled_hint'.tr(),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            // Toggle Switch
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 44.w,
              height: 24.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: widget.isEnabled ? color : AppColors.line.withOpacity(0.5),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: widget.isEnabled ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.all(2.w),
                  width: 20.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4.r,
                        offset: Offset(0, 1.h),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateFields() {
    return Row(
      children: [
        // من
        _buildDateField(
          label: 'from'.tr(),
          date: widget.dailyFrom,
          onChanged: widget.onDailyFromChanged,
        ),
        SizedBox(width: 10.w),
        // إلى
        _buildDateField(
          label: 'to'.tr(),
          date: widget.dailyTo,
          onChanged: widget.onDailyToChanged,
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required ValueChanged<DateTime> onChanged,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          InkWell(
            onTap: () async {
              final picked = await AppDatePicker.show(
                context: context,
                initialDate: date,
              );
              if (picked != null) onChanged(picked);
            },
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(
                  color: AppColors.blue.withOpacity(0.2),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 4.r,
                    offset: Offset(0, 1.h),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: AppColors.blue,
                    size: 16.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      DateFormat('dd/MM/yyyy').format(date),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.textMuted,
                    size: 20.sp,
                  ),
                ],
              ),
            ),
          ),
        ],
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