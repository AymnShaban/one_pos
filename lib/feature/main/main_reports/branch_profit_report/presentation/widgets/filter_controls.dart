// import 'package:flutter/material.dart';
// import '../theme/app_colors.dart';
//
// /// One label + radio/checkbox row inside a filter accordion,
// /// e.g. "على مستوى الحسابات" ○  /  "تحليلي" ☐
// class OptionRow extends StatelessWidget {
//   final String label;
//   final Widget control;
//   final bool showDivider;
//
//   const OptionRow({
//     super.key,
//     required this.label,
//     required this.control,
//     this.showDivider = true,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 9),
//       decoration: showDivider
//           ? const BoxDecoration(
//               border: Border(bottom: BorderSide(color: AppColors.lineColor)),
//             )
//           : null,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF374151))),
//           control,
//         ],
//       ),
//     );
//   }
// }
//
// /// A tappable box that displays a date/month value and opens a picker,
// /// used for "من" / "إلى" pairs.
// class DateFieldBox extends StatelessWidget {
//   final String label;
//   final String value;
//   final VoidCallback onTap;
//   final Color borderColor;
//
//   const DateFieldBox({
//     super.key,
//     required this.label,
//     required this.value,
//     required this.onTap,
//     this.borderColor = const Color(0xFFD7DBE3),
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
//           const SizedBox(height: 4),
//           InkWell(
//             onTap: onTap,
//             borderRadius: BorderRadius.circular(8),
//             child: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: borderColor),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Flexible(
//                     child: Text(
//                       value,
//                       style: const TextStyle(fontSize: 12.5, color: AppColors.ink),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.muted),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
