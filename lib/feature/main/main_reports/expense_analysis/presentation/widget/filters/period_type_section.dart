// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
//
// import '../../../../../../../core/helper/enums/period_type.dart';
// import '../../../../../../../core/widgets/filter_widgets.dart';
// import '../mixins/expense_analysis_helper.dart';
//
//
// class PeriodTypeSection extends StatelessWidget with RevenueAnalysisHelper {
//   final PeriodType selectedType;
//   final Function(PeriodType) onChanged;
//
//   const PeriodTypeSection({
//     super.key,
//     required this.selectedType,
//     required this.onChanged,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         buildSectionHeader("period_type".tr()),
//         SegmentedFilter(
//           options: [
//             "monthly".tr(),
//             "quarterly".tr(),
//             "yearly".tr(),
//           ],
//           selectedIndex: selectedType.index,
//           onChanged: (index) {
//             final types = PeriodType.values;
//             if (index >= 0 && index < types.length) {
//               onChanged(types[index]);
//             }
//           },
//         ),
//       ],
//     );
//   }
// }