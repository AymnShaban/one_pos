import 'package:easy_localization/easy_localization.dart';

import '../../../../../../core/helper/helper.dart';
import '../../../../../../core/widgets/filter_widgets.dart';

class PeriodTypeSection extends StatelessWidget {
  final PeriodType selectedType;
  final ValueChanged<PeriodType> onChanged;

  const PeriodTypeSection({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterSectionLabel(title: "period_type".tr()),
        Container(
          width: MediaQuery.sizeOf(context).width,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(

            color: AppColors.card,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.line),
          ),
          child: Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: PeriodType.values.map((type) {
              return _PeriodRadio(
                label: type.name.tr(),
                value: type,
                groupValue: selectedType,
                onChanged: onChanged,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _PeriodRadio extends StatelessWidget {
  final String label;
  final PeriodType value;
  final PeriodType groupValue;
  final ValueChanged<PeriodType> onChanged;

  const _PeriodRadio({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<PeriodType>(
          value: value,
          groupValue: groupValue,
          onChanged: (val) => onChanged(val!),
          activeColor: AppColors.brand,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Text(label, style: TextStyle(fontSize: 12.sp)),
      ],
    );
  }
}
