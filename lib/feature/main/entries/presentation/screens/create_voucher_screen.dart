// // في ملف create_voucher_screen.dart
//
//
// import '../../entries_imports.dart';
//
//
// class CreateVoucherScreen extends StatefulWidget {
//   final VoucherModel? voucher; // إذا كان موجوداً، نكون في وضع التعديل
//
//   const CreateVoucherScreen({super.key, this.voucher});
//
//   @override
//   State<CreateVoucherScreen> createState() => _CreateVoucherScreenState();
// }
//
// class _CreateVoucherScreenState extends State<CreateVoucherScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late int _voucherType;
//   final _dateController = TextEditingController();
//   final _amountController = TextEditingController();
//   final _currencyController = TextEditingController();
//   final _rateController = TextEditingController();
//   final _accountController = TextEditingController();
//   final _checkNumberController = TextEditingController();
//   final _checkDueController = TextEditingController();
//   final _personController = TextEditingController();
//   final _referenceController = TextEditingController();
//   final _branchController = TextEditingController();
//   final _employeeController = TextEditingController();
//   final _counterpartController = TextEditingController();
//   final _debitController = TextEditingController();
//   final _creditController = TextEditingController();
//   final _notesController = TextEditingController();
//
//   bool _isCheck = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _voucherType = 11; // افتراضي: سند قبض نقدي
//     if (widget.voucher != null) {
//       _fillData(widget.voucher!);
//     }
//   }
//
//   void _fillData(VoucherModel voucher) {
//     _voucherType = voucher.voucherType ?? 11;
//     _dateController.text = voucher.creationDateTime.toString() ?? '';
//     _amountController.text = voucher.voucherValue?.toString() ?? '';
//     _currencyController.text = voucher.currencyId?.toString() ?? '';
//     _rateController.text = voucher.currencyRate?.toString() ?? '1.000';
//     _accountController.text = voucher.cashAcId?.toString() ?? '';
//     _checkNumberController.text = voucher.checkNumber ?? '';
//     _checkDueController.text = voucher.checkDueDate.toString() ?? '';
//     _personController.text = voucher.receivedFrom ?? '';
//     _referenceController.text = voucher.referenceNO ?? '';
//     _branchController.text = voucher.branchId?.toString() ?? '';
//     _employeeController.text = voucher.employeeId?.toString() ?? '';
//     _notesController.text = voucher.notes ?? '';
//     _isCheck = _voucherType == 12 || _voucherType == 22;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.voucher == null ? 'إنشاء سند جديد' : 'تعديل السند'),
//         actions: [
//           if (widget.voucher != null)
//             Text(
//               widget.voucher!.voucherNumber?.toString() ?? '',
//               style: const TextStyle(fontSize: 12, color: Colors.grey),
//             ),
//         ],
//       ),
//       body: BlocListener<VoucherCreationBloc, BaseState<PostEntryResponseModel>>(
//         listener: (context, state) {
//           if (state.status == Status.success) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('تم حفظ السند بنجاح')),
//             );
//             Navigator.pop(context, true);
//           } else if (state.status == Status.failure) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('خطأ: ${state.errorMessage}')),
//             );
//           }
//         },
//         child: BlocBuilder<VoucherCreationBloc, BaseState<PostEntryResponseModel>>(
//           builder: (context, state) {
//             return Padding(
//               padding: const EdgeInsets.all(16),
//               child: Form(
//                 key: _formKey,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       _buildVoucherTypeField(),
//                       const SizedBox(height: 16),
//                       _buildDateField(),
//                       const SizedBox(height: 16),
//                       _buildAmountField(),
//                       const SizedBox(height: 16),
//                       _buildCurrencyAndRateFields(),
//                       const SizedBox(height: 16),
//                       _buildAccountField(),
//                       const SizedBox(height: 16),
//                       if (_isCheck) _buildCheckFields(),
//                       const SizedBox(height: 16),
//                       _buildPersonField(),
//                       const SizedBox(height: 16),
//                       _buildReferenceAndBranchFields(),
//                       const SizedBox(height: 16),
//                       _buildEmployeeAndCounterpartFields(),
//                       const SizedBox(height: 16),
//                       _buildDebitCreditFields(),
//                       const SizedBox(height: 16),
//                       _buildNotesField(),
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
//   Widget _buildVoucherTypeField() {
//     return DropdownButtonFormField<int>(
//       value: _voucherType,
//       decoration: const InputDecoration(
//         labelText: 'نوع السند',
//         border: OutlineInputBorder(),
//       ),
//       items: const [
//         DropdownMenuItem(value: 11, child: Text('سند قبض نقدي')),
//         DropdownMenuItem(value: 12, child: Text('سند قبض شيك')),
//         DropdownMenuItem(value: 21, child: Text('سند صرف نقدي')),
//         DropdownMenuItem(value: 22, child: Text('سند صرف شيك')),
//       ],
//       onChanged: (value) {
//         if (value != null) {
//           setState(() {
//             _voucherType = value;
//             _isCheck = value == 12 || value == 22;
//           });
//         }
//       },
//     );
//   }
//
//   Widget _buildDateField() {
//     return TextFormField(
//       controller: _dateController,
//       decoration: const InputDecoration(
//         labelText: 'تاريخ السند',
//         border: OutlineInputBorder(),
//         suffixIcon: Icon(Icons.calendar_today),
//       ),
//       readOnly: true,
//       onTap: () async {
//         final date = await showDatePicker(
//           context: context,
//           initialDate: DateTime.now(),
//           firstDate: DateTime(2000),
//           lastDate: DateTime.now(),
//         );
//         if (date != null) {
//           _dateController.text = date.toIso8601String().split('T').first;
//         }
//       },
//       validator: (value) => value?.isEmpty ?? true ? 'التاريخ مطلوب' : null,
//     );
//   }
//
//   Widget _buildAmountField() {
//     return TextFormField(
//       controller: _amountController,
//       decoration: const InputDecoration(
//         labelText: 'قيمة السند',
//         border: OutlineInputBorder(),
//       ),
//       keyboardType: TextInputType.number,
//       validator: (value) => value?.isEmpty ?? true ? 'القيمة مطلوبة' : null,
//     );
//   }
//
//   Widget _buildCurrencyAndRateFields() {
//     return Row(
//       children: [
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
//               DropdownMenuItem(value: 'SAR', child: Text('SAR')),
//               DropdownMenuItem(value: 'EGP', child: Text('EGP')),
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
//   Widget _buildAccountField() {
//     return BlocBuilder<AccountsBloc, BaseState<List<AccountModel>>>(
//       builder: (context, state) {
//         final accounts = state.data ?? [];
//         return DropdownButtonFormField<int>(
//           value: _accountController.text.isNotEmpty
//               ? int.tryParse(_accountController.text)
//               : null,
//           decoration: const InputDecoration(
//             labelText: 'الحساب النقدي / البنكي',
//             border: OutlineInputBorder(),
//           ),
//           items: accounts.map((account) {
//             return DropdownMenuItem(
//               value: account.acID,
//               child: Text(account.acName ?? ''),
//             );
//           }).toList(),
//           onChanged: (value) => _accountController.text = value?.toString() ?? '',
//           validator: (value) => value == null ? 'الحساب مطلوب' : null,
//         );
//       },
//     );
//   }
//
//   Widget _buildCheckFields() {
//     return Column(
//       children: [
//         TextFormField(
//           controller: _checkNumberController,
//           decoration: const InputDecoration(
//             labelText: 'رقم الشيك',
//             border: OutlineInputBorder(),
//           ),
//         ),
//         const SizedBox(height: 16),
//         TextFormField(
//           controller: _checkDueController,
//           decoration: const InputDecoration(
//             labelText: 'تاريخ استحقاق الشيك',
//             border: OutlineInputBorder(),
//             suffixIcon: Icon(Icons.calendar_today),
//           ),
//           readOnly: true,
//           onTap: () async {
//             final date = await showDatePicker(
//               context: context,
//               initialDate: DateTime.now(),
//               firstDate: DateTime(2000),
//               lastDate: DateTime.now().add(const Duration(days: 365)),
//             );
//             if (date != null) {
//               _checkDueController.text = date.toIso8601String().split('T').first;
//             }
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPersonField() {
//     return TextFormField(
//       controller: _personController,
//       decoration: InputDecoration(
//         labelText: _voucherType == 11 || _voucherType == 12 ? 'مستلم من' : 'مدفوع إلى',
//         border: const OutlineInputBorder(),
//       ),
//     );
//   }
//
//   Widget _buildReferenceAndBranchFields() {
//     return Row(
//       children: [
//         Expanded(
//           child: TextFormField(
//             controller: _referenceController,
//             decoration: const InputDecoration(
//               labelText: 'رقم المرجع',
//               border: OutlineInputBorder(),
//             ),
//           ),
//         ),
//         const SizedBox(width: 16),
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
//               DropdownMenuItem(value: '3', child: Text('فرع الفروانية')),
//             ],
//             onChanged: (value) => _branchController.text = value ?? '',
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildEmployeeAndCounterpartFields() {
//     return Row(
//       children: [
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
//             value: _counterpartController.text.isNotEmpty ? _counterpartController.text : null,
//             decoration: const InputDecoration(
//               labelText: 'الحساب المقابل',
//               border: OutlineInputBorder(),
//             ),
//             items: const [
//               DropdownMenuItem(value: '1', child: Text('إيرادات المبيعات')),
//               DropdownMenuItem(value: '2', child: Text('ذمم عملاء')),
//               DropdownMenuItem(value: '3', child: Text('مصروفات عمومية')),
//             ],
//             onChanged: (value) => _counterpartController.text = value ?? '',
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDebitCreditFields() {
//     return Row(
//       children: [
//         Expanded(
//           child: TextFormField(
//             controller: _debitController,
//             decoration: const InputDecoration(
//               labelText: 'مدين',
//               border: OutlineInputBorder(),
//             ),
//             keyboardType: TextInputType.number,
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: TextFormField(
//             controller: _creditController,
//             decoration: const InputDecoration(
//               labelText: 'دائن',
//               border: OutlineInputBorder(),
//             ),
//             keyboardType: TextInputType.number,
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
//       maxLines: 3,
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
//         ElevatedButton(
//           onPressed: isLoading ? null :null,
//           child: isLoading
//               ? const SizedBox(
//             width: 20,
//             height: 20,
//             child: CircularProgressIndicator(strokeWidth: 2),
//           )
//               : const Text('حفظ السند'),
//         ),
//       ],
//     );
//   }
//
//
// }