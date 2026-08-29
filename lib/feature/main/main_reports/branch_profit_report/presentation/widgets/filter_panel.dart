// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../theme/app_colors.dart';
// import 'accordion_section.dart';
// import 'filter_controls.dart';
//
// enum ViewLevel { accounts, costCenter }
// enum SortBy { branch, month }
//
// class FilterPanel extends StatefulWidget {
//   const FilterPanel({super.key});
//
//   @override
//   State<FilterPanel> createState() => _FilterPanelState();
// }
//
// class _FilterPanelState extends State<FilterPanel> {
//   ViewLevel _viewLevel = ViewLevel.accounts;
//   SortBy _sortBy = SortBy.branch;
//
//   final List<bool> _options = List.filled(6, false);
//   static const _optionLabels = [
//     'عرض الإيرادات والمصروفات',
//     'تحليلي',
//     'عدم عرض الفواتير غير المرحّلة',
//     'الأرباح من آخر تكلفة',
//     'تجميعي',
//     'تجميعي حسب الفرع',
//   ];
//
//   DateTime _monthFrom = DateTime(2026, 1);
//   DateTime _monthTo = DateTime(2026, 8);
//
//   bool _dailyEnabled = false;
//   bool _emptyDaysEnabled = false;
//   DateTime _dailyFrom = DateTime(2026, 8, 24);
//   DateTime _dailyTo = DateTime(2026, 8, 24);
//
//   bool _branchSelected = true;
//
//   Future<void> _pickMonth({required bool isFrom}) async {
//     final initial = isFrom ? _monthFrom : _monthTo;
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: initial,
//       firstDate: DateTime(2015),
//       lastDate: DateTime(2035),
//       initialDatePickerMode: DatePickerMode.year,
//       helpText: isFrom ? 'اختر شهر البداية' : 'اختر شهر النهاية',
//     );
//     if (picked != null) {
//       setState(() {
//         final monthOnly = DateTime(picked.year, picked.month);
//         if (isFrom) {
//           _monthFrom = monthOnly;
//         } else {
//           _monthTo = monthOnly;
//         }
//       });
//     }
//   }
//
//   Future<void> _pickDay({required bool isFrom}) async {
//     final initial = isFrom ? _dailyFrom : _dailyTo;
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: initial,
//       firstDate: DateTime(2015),
//       lastDate: DateTime(2035),
//       helpText: isFrom ? 'من تاريخ' : 'إلى تاريخ',
//     );
//     if (picked != null) {
//       setState(() {
//         if (isFrom) {
//           _dailyFrom = picked;
//         } else {
//           _dailyTo = picked;
//         }
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.only(bottom: 20),
//       children: [
//         // خيارات العرض
//         AccordionSection(
//           title: 'خيارات العرض',
//           initiallyExpanded: true,
//           child: Column(
//             children: [
//               OptionRow(
//                 label: 'على مستوى الحسابات',
//                 control: Radio<ViewLevel>(
//                   value: ViewLevel.accounts,
//                   groupValue: _viewLevel,
//                   activeColor: AppColors.gold,
//                   onChanged: (v) => setState(() => _viewLevel = v!),
//                 ),
//               ),
//               OptionRow(
//                 showDivider: false,
//                 label: 'على مستوى مركز التكلفة',
//                 control: Radio<ViewLevel>(
//                   value: ViewLevel.costCenter,
//                   groupValue: _viewLevel,
//                   activeColor: AppColors.gold,
//                   onChanged: (v) => setState(() => _viewLevel = v!),
//                 ),
//               ),
//             ],
//           ),
//         ),
//
//         // الترتيب
//         AccordionSection(
//           title: 'الترتيب',
//           child: Column(
//             children: [
//               OptionRow(
//                 label: 'حسب الفرع',
//                 control: Radio<SortBy>(
//                   value: SortBy.branch,
//                   groupValue: _sortBy,
//                   activeColor: AppColors.gold,
//                   onChanged: (v) => setState(() => _sortBy = v!),
//                 ),
//               ),
//               OptionRow(
//                 showDivider: false,
//                 label: 'حسب الشهور',
//                 control: Radio<SortBy>(
//                   value: SortBy.month,
//                   groupValue: _sortBy,
//                   activeColor: AppColors.gold,
//                   onChanged: (v) => setState(() => _sortBy = v!),
//                 ),
//               ),
//             ],
//           ),
//         ),
//
//         // الخيارات
//         AccordionSection(
//           title: 'الخيارات',
//           child: Column(
//             children: List.generate(_optionLabels.length, (i) {
//               return OptionRow(
//                 showDivider: i != _optionLabels.length - 1,
//                 label: _optionLabels[i],
//                 control: Checkbox(
//                   value: _options[i],
//                   activeColor: AppColors.green,
//                   onChanged: (v) => setState(() => _options[i] = v!),
//                 ),
//               );
//             }),
//           ),
//         ),
//
//         // الفترة الشهرية
//         AccordionSection(
//           title: 'الفترة الشهرية',
//           child: Row(
//             children: [
//               DateFieldBox(
//                 label: 'من',
//                 value: DateFormat('MMMM yyyy').format(_monthFrom),
//                 onTap: () => _pickMonth(isFrom: true),
//               ),
//               const SizedBox(width: 8),
//               DateFieldBox(
//                 label: 'إلى',
//                 value: DateFormat('MMMM yyyy').format(_monthTo),
//                 onTap: () => _pickMonth(isFrom: false),
//               ),
//             ],
//           ),
//         ),
//
//         // مبيعات يومية (sand)
//         AccordionSection(
//           title: 'مبيعات يومية',
//           sand: true,
//           child: Column(
//             children: [
//               OptionRow(
//                 label: 'يومي',
//                 control: Checkbox(
//                   value: _dailyEnabled,
//                   activeColor: AppColors.green,
//                   onChanged: (v) => setState(() => _dailyEnabled = v!),
//                 ),
//               ),
//               OptionRow(
//                 showDivider: false,
//                 label: 'الأيام الفارغة',
//                 control: Checkbox(
//                   value: _emptyDaysEnabled,
//                   activeColor: AppColors.green,
//                   onChanged: (v) => setState(() => _emptyDaysEnabled = v!),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   DateFieldBox(
//                     label: 'من',
//                     value: DateFormat('MM/dd/yyyy').format(_dailyFrom),
//                     borderColor: AppColors.sandLine,
//                     onTap: () => _pickDay(isFrom: true),
//                   ),
//                   const SizedBox(width: 8),
//                   DateFieldBox(
//                     label: 'إلى',
//                     value: DateFormat('MM/dd/yyyy').format(_dailyTo),
//                     borderColor: AppColors.sandLine,
//                     onTap: () => _pickDay(isFrom: false),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//
//         // الفروع
//         AccordionSection(
//           title: 'الفروع',
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   InkWell(
//                     onTap: () => setState(() => _branchSelected = false),
//                     child: const Row(
//                       children: [
//                         Text('إلغاء', style: TextStyle(color: AppColors.red, fontSize: 12.5)),
//                         SizedBox(width: 4),
//                         Icon(Icons.close_rounded, size: 14, color: AppColors.red),
//                       ],
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () => setState(() => _branchSelected = true),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFEEF1F6),
//                         borderRadius: BorderRadius.circular(7),
//                       ),
//                       child: const Row(
//                         children: [
//                           Text('الكل', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
//                           SizedBox(width: 6),
//                           Icon(Icons.check_rounded, size: 13, color: AppColors.green),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 6),
//               OptionRow(
//                 showDivider: false,
//                 label: 'شركة ذا ون سيستم',
//                 control: Checkbox(
//                   value: _branchSelected,
//                   activeColor: AppColors.green,
//                   onChanged: (v) => setState(() => _branchSelected = v!),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
