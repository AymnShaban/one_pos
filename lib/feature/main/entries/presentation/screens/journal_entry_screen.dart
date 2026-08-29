//
// import '../../entries_imports.dart';
//
//
// class JournalEntryScreen extends StatefulWidget {
//   const JournalEntryScreen({super.key});
//
//   @override
//   State<JournalEntryScreen> createState() => _JournalEntryScreenState();
// }
//
// class _JournalEntryScreenState extends State<JournalEntryScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _dateController = TextEditingController();
//   final _numberController = TextEditingController();
//   final _amountController = TextEditingController();
//   final _currencyController = TextEditingController();
//   final _rateController = TextEditingController();
//   final _branchController = TextEditingController();
//   final _employeeController = TextEditingController();
//   final _statusController = TextEditingController();
//   final _notesController = TextEditingController();
//   final List<JournalLineModel> _lines = [];
//   int _lineCounter = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _addLine();
//     _addLine(); // سطرين افتراضيين
//   }
//
//   void _addLine() {
//     setState(() {
//       _lines.add(JournalLineModel(
//         rowNumber: ++_lineCounter,
//       ));
//     });
//     _recalculateTotals();
//   }
//
//   void _removeLine(int index) {
//     setState(() {
//       _lines.removeAt(index);
//     });
//     _recalculateTotals();
//   }
//
//   void _recalculateTotals() {
//     double totalDebit = 0;
//     double totalCredit = 0;
//     for (var line in _lines) {
//       totalDebit += line.debit ?? 0;
//       totalCredit += line.credit ?? 0;
//     }
//     _amountController.text = totalDebit.toStringAsFixed(3);
//     // يمكن تخزين الفرق في متغير لعرضه
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('سند قيد يومية'),
//
//       ),
//       body: BlocListener<JournalEntryBloc, BaseState<SaveJournalEntryResponseModel>>(
//         listener: (context, state) {
//           if (state.status == Status.success) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('تم حفظ القيد بنجاح')),
//             );
//             Navigator.pop(context, true);
//           } else if (state.status == Status.failure) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('خطأ: ${state.errorMessage}')),
//             );
//           }
//         },
//         child: BlocBuilder<JournalEntryBloc, BaseState<SaveJournalEntryResponseModel>>(
//           builder: (context, state) {
//             return Padding(
//               padding: const EdgeInsets.all(16),
//               child: Form(
//                 key: _formKey,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text('بيانات القيد', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 12),
//                       _buildDateAndNumberFields(),
//                       const SizedBox(height: 16),
//                       _buildAmountAndCurrencyFields(),
//                       const SizedBox(height: 16),
//                       _buildBranchEmployeeStatusFields(),
//                       const SizedBox(height: 16),
//                       _buildNotesField(),
//                       const SizedBox(height: 24),
//                       const Text('بنود القيد', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 12),
//                       _buildLinesTable(),
//                       const SizedBox(height: 12),
//                       ElevatedButton.icon(
//                         onPressed: _addLine,
//                         icon: const Icon(Icons.add),
//                         label: const Text('إضافة سطر'),
//                       ),
//                       const SizedBox(height: 24),
//                       _buildTotalsBar(),
//                       const SizedBox(height: 24),
//                       _buildActionButtons(state.status == Status.loading),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDateAndNumberFields() {
//     return Row(
//       children: [
//         Expanded(
//           child: TextFormField(
//             controller: _dateController,
//             decoration: const InputDecoration(
//               labelText: 'تاريخ القيد',
//               border: OutlineInputBorder(),
//               suffixIcon: Icon(Icons.calendar_today),
//             ),
//             readOnly: true,
//             onTap: () async {
//               final date = await showDatePicker(
//                 context: context,
//                 initialDate: DateTime.now(),
//                 firstDate: DateTime(2000),
//                 lastDate: DateTime.now(),
//               );
//               if (date != null) {
//                 _dateController.text = date.toIso8601String().split('T').first;
//               }
//             },
//             validator: (value) => value?.isEmpty ?? true ? 'التاريخ مطلوب' : null,
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: TextFormField(
//             controller: _numberController,
//             decoration: const InputDecoration(
//               labelText: 'رقم القيد',
//               border: OutlineInputBorder(),
//             ),
//             readOnly: true,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildAmountAndCurrencyFields() {
//     return Row(
//       children: [
//         Expanded(
//           child: TextFormField(
//             controller: _amountController,
//             decoration: const InputDecoration(
//               labelText: 'قيمة القيد',
//               border: OutlineInputBorder(),
//             ),
//             readOnly: true,
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: DropdownButtonFormField<String>(
//             value: _currencyController.text.isNotEmpty ? _currencyController.text : 'KWD',
//             decoration: const InputDecoration(
//               labelText: 'العملة',
//               border: OutlineInputBorder(),
//             ),
//             items: const [
//               DropdownMenuItem(value: 'KWD', child: Text('KWD')),
//               DropdownMenuItem(value: 'USD', child: Text('USD')),
//             ],
//             onChanged: (value) => _currencyController.text = value ?? 'KWD',
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: TextFormField(
//             controller: _rateController,
//             decoration: const InputDecoration(
//               labelText: 'سعر العملة',
//               border: OutlineInputBorder(),
//             ),
//             keyboardType: TextInputType.number,
//             initialValue: '1.000',
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildBranchEmployeeStatusFields() {
//     return Row(
//       children: [
//         Expanded(
//           child: DropdownButtonFormField<String>(
//             value: _branchController.text.isNotEmpty ? _branchController.text : null,
//             decoration: const InputDecoration(
//               labelText: 'الفرع',
//               border: OutlineInputBorder(),
//             ),
//             items: const [
//               DropdownMenuItem(value: '1', child: Text('الفرع الرئيسي')),
//               DropdownMenuItem(value: '2', child: Text('فرع حولي')),
//             ],
//             onChanged: (value) => _branchController.text = value ?? '',
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: DropdownButtonFormField<String>(
//             value: _employeeController.text.isNotEmpty ? _employeeController.text : null,
//             decoration: const InputDecoration(
//               labelText: 'الموظف',
//               border: OutlineInputBorder(),
//             ),
//             items: const [
//               DropdownMenuItem(value: '1', child: Text('أحمد المطيري')),
//               DropdownMenuItem(value: '2', child: Text('سارة العتيبي')),
//             ],
//             onChanged: (value) => _employeeController.text = value ?? '',
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: DropdownButtonFormField<String>(
//             value: _statusController.text.isNotEmpty ? _statusController.text : null,
//             decoration: const InputDecoration(
//               labelText: 'حالة الترحيل',
//               border: OutlineInputBorder(),
//             ),
//             items: const [
//               DropdownMenuItem(value: 'غير مرحل', child: Text('غير مرحل')),
//               DropdownMenuItem(value: 'مرحل', child: Text('مرحل')),
//             ],
//             onChanged: (value) => _statusController.text = value ?? '',
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildNotesField() {
//     return TextFormField(
//       controller: _notesController,
//       decoration: const InputDecoration(
//         labelText: 'الملاحظات',
//         border: OutlineInputBorder(),
//       ),
//     );
//   }
//
//   Widget _buildLinesTable() {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: DataTable(
//           columns: const [
//             DataColumn(label: Text('م', style: TextStyle(fontWeight: FontWeight.bold))),
//             DataColumn(label: Text('رقم الحساب', style: TextStyle(fontWeight: FontWeight.bold))),
//             DataColumn(label: Text('اسم الحساب', style: TextStyle(fontWeight: FontWeight.bold))),
//             DataColumn(label: Text('مدين', style: TextStyle(fontWeight: FontWeight.bold))),
//             DataColumn(label: Text('دائن', style: TextStyle(fontWeight: FontWeight.bold))),
//             DataColumn(label: Text('مركز التكلفة', style: TextStyle(fontWeight: FontWeight.bold))),
//             DataColumn(label: Text('البيان', style: TextStyle(fontWeight: FontWeight.bold))),
//             DataColumn(label: Text('', style: TextStyle(fontWeight: FontWeight.bold))),
//           ],
//           rows: _lines.asMap().entries.map((entry) {
//             final index = entry.key;
//             final line = entry.value;
//             return DataRow(
//               cells: [
//                 DataCell(Text(line.rowNumber.toString())),
//                 DataCell(
//                   TextFormField(
//                     initialValue: line.account,
//                     onChanged: (value) => line.account = value,
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       hintText: 'رقم الحساب',
//                     ),
//                   ),
//                 ),
//                 DataCell(
//                   TextFormField(
//                     initialValue: line.accountName,
//                     onChanged: (value) => line.accountName = value,
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       hintText: 'اسم الحساب',
//                     ),
//                   ),
//                 ),
//                 DataCell(
//                   TextFormField(
//                     initialValue: line.debit?.toString(),
//                     onChanged: (value) {
//                       line.debit = double.tryParse(value) ?? 0;
//                       _recalculateTotals();
//                     },
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       hintText: '0.000',
//                     ),
//                   ),
//                 ),
//                 DataCell(
//                   TextFormField(
//                     initialValue: line.credit?.toString(),
//                     onChanged: (value) {
//                       line.credit = double.tryParse(value) ?? 0;
//                       _recalculateTotals();
//                     },
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       hintText: '0.000',
//                     ),
//                   ),
//                 ),
//                 DataCell(
//                   TextFormField(
//                     initialValue: line.costCenter,
//                     onChanged: (value) => line.costCenter = value,
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       hintText: 'مركز التكلفة',
//                     ),
//                   ),
//                 ),
//                 DataCell(
//                   TextFormField(
//                     initialValue: line.notes,
//                     onChanged: (value) => line.notes = value,
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       hintText: 'البيان',
//                     ),
//                   ),
//                 ),
//                 DataCell(
//                   IconButton(
//                     icon: const Icon(Icons.close, color: Colors.red, size: 18),
//                     onPressed: _lines.length > 1 ? () => _removeLine(index) : null,
//                   ),
//                 ),
//               ],
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTotalsBar() {
//     double totalDebit = 0;
//     double totalCredit = 0;
//     for (var line in _lines) {
//       totalDebit += line.debit ?? 0;
//       totalCredit += line.credit ?? 0;
//     }
//     final diff = totalDebit - totalCredit;
//     final isBalanced = diff.abs() < 0.001;
//
//     return Row(
//       children: [
//         _buildTotalBox('إجمالي المدين', totalDebit, Colors.green.shade50),
//         const SizedBox(width: 16),
//         _buildTotalBox('إجمالي الدائن', totalCredit, Colors.blue.shade50),
//         const SizedBox(width: 16),
//         _buildTotalBox(
//           'الفرق',
//           diff.abs(),
//           isBalanced ? Colors.green.shade50 : Colors.red.shade50,
//           textColor: isBalanced ? Colors.green : Colors.red,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTotalBox(String label, double value, Color bgColor, {Color? textColor}) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: bgColor,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Column(
//           children: [
//             Text(
//               label,
//               style: const TextStyle(fontSize: 11.5, color: Colors.grey),
//             ),
//             Text(
//               value.toStringAsFixed(3),
//               style: TextStyle(
//                 fontSize: 17,
//                 fontWeight: FontWeight.bold,
//                 color: textColor ?? Colors.black,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildActionButtons(bool isLoading) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('إلغاء'),
//         ),
//         const SizedBox(width: 8),
//
//       ],
//     );
//   }
//
//   void _saveJournal(bool post) {
//     if (!_formKey.currentState!.validate()) return;
//
//     // التحقق من توازن القيد
//     double totalDebit = 0;
//     double totalCredit = 0;
//     for (var line in _lines) {
//       totalDebit += line.debit ?? 0;
//       totalCredit += line.credit ?? 0;
//     }
//
//     if ((totalDebit - totalCredit).abs() > 0.001) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('القيد غير متوازن!')),
//       );
//       return;
//     }
//
//     final accounts = _lines.map((line) {
//       return VoucherAccountModel(
//         acId: int.tryParse(line.account ?? '') ?? 0,
//         number: line.rowNumber,
//         debit: line.debit ?? 0,
//         credit: line.credit ?? 0,
//         currencyId: 1,
//         currencyRate: double.tryParse(_rateController.text) ?? 1,
//         costCenterId: int.tryParse(line.costCenter ?? ''),
//         notes: line.notes,
//         equivalent: line.debit ?? 0,
//         itemRowNumber: line.rowNumber,
//         acNameAr: line.accountName,
//         costCenterNameAr: line.costCenter,
//       );
//     }).toList();
//
//
//
//     //context.read<JournalEntryBloc>().add(SaveJournalEntry(request: request));
//   }
// }
//
// // نموذج بسيط لسطر القيد
// class JournalLineModel {
//   int rowNumber;
//   String? account;
//   String? accountName;
//   double? debit;
//   double? credit;
//   String? costCenter;
//   String? notes;
//
//   JournalLineModel({
//     required this.rowNumber,
//     this.account,
//     this.accountName,
//     this.debit,
//     this.credit,
//     this.costCenter,
//     this.notes,
//   });
// }