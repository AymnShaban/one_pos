import 'package:easy_localization/easy_localization.dart';

import '../../branch_profit_import.dart';

class DateRangeSection extends StatefulWidget {
  final DateTime fromDate;
  final DateTime toDate;
  final ValueChanged<DateTime> onFromDateChanged;
  final ValueChanged<DateTime> onToDateChanged;

  const DateRangeSection({
    super.key,
    required this.fromDate,
    required this.toDate,
    required this.onFromDateChanged,
    required this.onToDateChanged,
  });

  @override
  State<DateRangeSection> createState() => _DateRangeSectionState();
}

class _DateRangeSectionState extends State<DateRangeSection> {
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
                  'period'.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              // عرض الفترة بشكل مختصر
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '${DateFormat('dd/MM/yyyy').format(widget.fromDate)} - ${DateFormat('dd/MM/yyyy').format(widget.toDate)}',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              // زر الفتح/الإغلاق
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
            Row(
              children: [
                _buildDateField(
                  context: context,
                  label: 'from'.tr(),
                  date: widget.fromDate,
                  onChanged: widget.onFromDateChanged,
                ),
                SizedBox(width: 10.w),
                _buildDateField(
                  context: context,
                  label: 'to'.tr(),
                  date: widget.toDate,
                  onChanged: widget.onToDateChanged,
                ),
              ],
            )

        ],
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required ValueChanged<DateTime> onChanged,
    required BuildContext context,
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