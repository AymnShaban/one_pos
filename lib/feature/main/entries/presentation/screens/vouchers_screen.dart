// screens/voucher_creation_screen.dart

import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/widgets/filter_field.dart';
import '../../../main_reports/branch_profit_report/branch_profit_import.dart';
import '../../entries_imports.dart';


// screens/voucher_creation_screen.dart

import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/widgets/filter_field.dart';
import '../../../main_reports/branch_profit_report/branch_profit_import.dart';
import '../../entries_imports.dart';

class VoucherCreationScreen extends StatefulWidget {
  const VoucherCreationScreen({super.key});

  @override
  State<VoucherCreationScreen> createState() => _VoucherCreationScreenState();
}

class _VoucherCreationScreenState extends State<VoucherCreationScreen> {
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final _receivedFromController = TextEditingController();
  final _checkNumberController = TextEditingController();
  final _discountValueController = TextEditingController();

  int _selectedVoucherTypeId = 1;
  VoucherTypeModel? _selectedPattern;

  // حساب الشخص (الاختيار اليدوي) - من MainAccountsBloc
  AccountModel? _selectedPersonAccount;
  // الحساب الرئيسي (من النمط) - من FillAccountsBloc
  AccountModel? _selectedMainAccount;

  DateTime _selectedDate = DateTime.now();
  DateTime? _checkDueDate;
  int? _selectedBranchId;

  AccountBalanceModel? _personAccountBalance;  // رصيد حساب الشخص
  bool _isLoadingPersonBalance = false;

  bool _validateAmount = false;
  bool _validatePersonAccount = false;
  bool _validateMainAccount = false;
  bool _validateCurrency = false;
  bool _validatePattern = false;
  bool _validateBranch = false;

  final List<Map<String, dynamic>> _voucherTypes = [
    {'id': 1, 'name': 'سندات القبض', 'nameEn': 'Receipt Vouchers'},
    {'id': 2, 'name': 'سندات الصرف', 'nameEn': 'Payment Vouchers'},
  ];

  List<String> _voucherTypeNames = [];
  Map<String, int> _voucherTypeMap = {};

  List<VoucherTypeModel> _patterns = [];
  bool _isLoadingPatterns = false;

  List<Map<String, dynamic>> _tableRows = [];

  @override
  void initState() {
    super.initState();
    _addEmptyRow();
    _buildVoucherTypeLists();
    _loadPatterns(1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BranchesBloc>().add(LoadBranches());
      _loadCurrencies();
      _loadPersonAccounts();   // MainAccountsBloc - حساب الشخص
      _loadMainAccounts();     // FillAccountsBloc - الحساب الرئيسي
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    _receivedFromController.dispose();
    _checkNumberController.dispose();
    _discountValueController.dispose();
    super.dispose();
  }

  void _buildVoucherTypeLists() {
    _voucherTypeNames = _voucherTypes.map((type) => type['name'] as String).toList();
    _voucherTypeMap = {
      for (var type in _voucherTypes) type['name'] as String: type['id'] as int
    };
  }

  // ============= دوال تحميل البيانات =============

  void _loadCurrencies() {
    context.read<CurrenciesBloc>().add(LoadCurrencies());
  }

  // تحميل حسابات الأشخاص - من MainAccountsBloc (getAllAccounts)
  void _loadPersonAccounts() {
    context.read<MainAccountsBloc>().add(LoadMainAccounts());
  }

  // تحميل الحسابات الرئيسية - من FillAccountsBloc (حسب النمط والفرع)
  void _loadMainAccounts() {
    final entryType = _selectedPattern?.arName?.toString() ?? 'سند قبض نقدي';
    final branchId = _selectedBranchId ?? 0;

    context.read<FillAccountsBloc>().add(
      LoadFillAccounts(
        entryType: entryType,
        branchId: branchId,
      ),
    );
  }

  void _addEmptyRow() {
    setState(() {
      _tableRows.add({
        'acId': null,
        'account': '',
        'accountObj': null,
        'debit': 0.0,
        'credit': 0.0,
        'notes': '',
      });
    });
  }

  void _removeRow(int index) {
    setState(() {
      _tableRows.removeAt(index);
      if (_tableRows.isEmpty) {
        _addEmptyRow();
      }
    });
  }

  void _updateRow(int index, String field, dynamic value) {
    setState(() {
      _tableRows[index][field] = value;
    });
  }

  double _getAmount() {
    return double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0;
  }

  bool _isCheckPattern() {
    if (_selectedPattern == null) return false;
    final name = _selectedPattern!.arName?.toLowerCase() ?? '';
    final enName = _selectedPattern!.enName?.toLowerCase() ?? '';
    return name.contains('شيك') || enName.contains('check');
  }

  bool _showCheckFields() => _isCheckPattern();

  bool _isCreditVoucher() => _selectedVoucherTypeId == 1;

  void _loadPatterns(int vouchTypeId) {
    setState(() => _isLoadingPatterns = true);
    context.read<EntriesBloc>().add(LoadVouchers(vouchTypeId: vouchTypeId));
  }

  // تحميل رصيد حساب الشخص - من MainAccountsBloc
  void _loadPersonAccountBalance(int acId) async {
    setState(() => _isLoadingPersonBalance = true);
    context.read<MainAccountsBloc>().add(LoadMainAccountBalance(acId: acId));
    final balance = context.read<MainAccountsBloc>().accountBalance;
    setState(() {
      _personAccountBalance = balance;
      _isLoadingPersonBalance = false;
      if (_personAccountBalance != null) {
        final isCredit = _isCreditVoucher();
        final value = isCredit ? _personAccountBalance!.credit : _personAccountBalance!.debit;
        _amountController.text = value.toStringAsFixed(3);
        _validateAmount = false;
      }
    });
  }

  bool _validateForm() {
    bool isValid = true;

    // التحقق من النمط
    if (_selectedPattern == null) {
      setState(() => _validatePattern = true);
      isValid = false;
    }

    // ❌ إزالة التحقق من الفرع (يبقى اختياري)

    // التحقق من العملة
    final currencyState = context.read<CurrenciesBloc>().state;
    if (currencyState.selectedCurrencyId == null) {
      setState(() => _validateCurrency = true);
      isValid = false;
    }

    // التحقق من حساب الشخص (الاختيار اليدوي) - من MainAccountsBloc
    if (_selectedPersonAccount == null) {
      setState(() => _validatePersonAccount = true);
      isValid = false;
    }

    // التحقق من الحساب الرئيسي (من النمط) - من FillAccountsBloc
    if (_selectedMainAccount == null) {
      setState(() => _validateMainAccount = true);
      isValid = false;
    }

    // التحقق من المبلغ
    final amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
    if (amount == null || amount <= 0) {
      setState(() => _validateAmount = true);
      isValid = false;
    }

    if (!isValid) {
      context.showErrorMessage('please_fill_required_fields'.tr());
    }

    return isValid;
  }

  void _createVoucher() {
    if (!_validateForm()) return;

    final amount = _getAmount();
    final currencyState = context.read<CurrenciesBloc>().state;
    final isCredit = _isCreditVoucher();

    final request = _buildVoucherRequest(amount, currencyState, isCredit);
    context.read<VoucherCreationBloc>().add(CreateVoucher(request: request));
  }

  PostEntryRequestModel _buildVoucherRequest(
      double amount,
      CurrenciesState currencyState,
      bool isCredit,
      ) {
    final currencyId = currencyState.selectedCurrencyId ?? 0;
    final currencyRate = currencyState.selectedExchangeRate ?? 1.0;

    final discountValue = double.tryParse(_discountValueController.text.replaceAll(',', '.')) ?? 0;

    // جلب أسماء الحسابات
    final personAccountName = _selectedPersonAccount?.acName ?? '';
    final mainAccountName = _selectedMainAccount?.acName ?? '';

    final voucherAccounts = [
      // حساب الشخص (من MainAccountsBloc)
      VoucherAccountRequestModel(
        acId: _selectedPersonAccount?.acID ?? 0,
        debit: isCredit ? 0 : amount,
        credit: isCredit ? amount : 0,
        currencyId: currencyId,
        currencyRate: currencyRate,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        acNameAr: personAccountName,
        acNameEn: personAccountName,
      ),
      // // الحساب الرئيسي (من FillAccountsBloc - حسب النمط)
      // VoucherAccountRequestModel(
      //   acId: _selectedMainAccount?.acID ?? 0,
      //   debit: isCredit ? amount : 0,
      //   credit: isCredit ? 0 : amount,
      //   currencyId: currencyId,
      //   currencyRate: currencyRate,
      //   notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      //   acNameAr: mainAccountName,
      //   acNameEn: mainAccountName,
      // ),
    ];

    return PostEntryRequestModel(
      voucherType: _selectedPattern?.frmNum ?? 0,
      voucherNumber: 0,
      creationDateTime: _selectedDate.toIso8601String(),
      cashAcId: _selectedMainAccount?.acID ?? 0,
      voucherValue: amount,
      currencyId: currencyId,
      currencyRate: currencyRate,
      cvNumber: '',
      isPosted: true,
      checkNumber: _checkNumberController.text.isNotEmpty ? _checkNumberController.text : null,
      checkDueDate: _checkDueDate?.toIso8601String(),
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      employeeId: 0,
      createdBy: '',
      postedBy: '',
      postNumber: 0,
      receivedFrom: _receivedFromController.text.isNotEmpty ? _receivedFromController.text : null,
      isCanceled: false,
      branchId: _selectedBranchId ?? 0,
      entryLevel: 0,
      isFromPaying: false,
      bankAcId: 0,
      discountAcId: 0,
      discountValue: discountValue,
      referenceNO: '',
      entryNature: _selectedPattern?.arName ?? '',
      voucherAccounts: voucherAccounts,
    );
  }

  void _resetForm() {
    setState(() {
      _selectedVoucherTypeId = 1;
      _selectedPattern = null;
      _selectedPersonAccount = null;
      _selectedMainAccount = null;
      _selectedDate = DateTime.now();
      _checkDueDate = null;
      _personAccountBalance = null;
      _patterns = [];
      _tableRows = [];
      _selectedBranchId = null;
      _amountController.clear();
      _notesController.clear();
      _receivedFromController.clear();
      _checkNumberController.clear();
      _discountValueController.clear();
      _validateAmount = false;
      _validatePersonAccount = false;
      _validateMainAccount = false;
      _validateCurrency = false;
      _validatePattern = false;
      _validateBranch = false;
    });
    _addEmptyRow();
    context.read<VoucherCreationBloc>().add(ResetVoucherCreation());
    context.read<FillAccountsBloc>().add(ClearFillAccounts());  // الحساب الرئيسي
    context.read<MainAccountsBloc>().add(ClearMainAccounts());  // حساب الشخص
    _loadPatterns(1);
    _loadCurrencies();
    _loadPersonAccounts();
    _loadMainAccounts();
  }

  void _showSuccessDialog(PostEntryResponseModel response) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        titlePadding: EdgeInsets.only(top: 24.h, left: 24.w, right: 24.w),
        contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        actionsPadding: EdgeInsets.only(bottom: 16.h, left: 24.w, right: 24.w),
        title: _buildSuccessTitle(),
        content: _buildSuccessContent(response),
        actions: [_buildSuccessAction()],
      ),
    );
  }

  Widget _buildSuccessTitle() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 48.sp,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'تم تسجيل السند بنجاح',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessContent(PostEntryResponseModel response) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (response.entryNumber != null) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.blue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: AppColors.blue.withOpacity(0.2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'رقم السند: ',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                    ),
                  ),
                  Text(
                    response.entryNumber.toString(),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSuccessAction() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
          _resetForm();
          context.read<MainAccountsBloc>().add(LoadMainAccounts());
          context.read<FillAccountsBloc>().add(LoadFillAccounts(
            entryType: _selectedPattern?.arName?.toString() ?? 'سند قبض نقدي',
            branchId: _selectedBranchId ?? 0,
          ));
          context.read<CurrenciesBloc>().add(LoadCurrencies());
          _loadPatterns(1);
          _loadCurrencies();
          _loadPersonAccounts();
          _loadMainAccounts();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          foregroundColor: AppColors.white,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          elevation: 0,
        ),
        child: Text(
          'تم',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<DateTime?> _pickDate(DateTime initialDate) {
    return AppDatePicker.show(
      context: context,
      initialDate: initialDate,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // VoucherCreationBloc
        BlocListener<VoucherCreationBloc, BaseState<PostEntryResponseModel>>(
          listenWhen: (prev, curr) => prev.status != curr.status,
          listener: (context, state) {
            if (state.status == Status.failure) {
              context.showErrorMessage(state.errorMessage ?? 'error_creating_voucher'.tr());
            }
            if (state.status == Status.success && state.data != null) {
              _showSuccessDialog(state.data!);
            }
          },
        ),
        // EntriesBloc - جلب الأنماط
        BlocListener<EntriesBloc, BaseState<List<VoucherTypeModel>>>(
          listenWhen: (prev, curr) => prev.status != curr.status,
          listener: (context, state) {
            if (state.status == Status.failure) {
              context.showErrorMessage(state.errorMessage ?? 'error_loading_patterns'.tr());
              setState(() => _isLoadingPatterns = false);
            }
            if (state.status == Status.success && state.data != null) {
              setState(() {
                _patterns = state.data ?? [];
                _isLoadingPatterns = false;
                if (_patterns.isNotEmpty) {
                  _selectedPattern = _patterns.first;
                  _validatePattern = false;
                  _loadMainAccounts(); // تحديث الحساب الرئيسي من FillAccountsBloc
                }
              });
            }
          },
        ),
        // FillAccountsBloc - الحساب الرئيسي (من النمط)
        BlocListener<FillAccountsBloc, BaseState<List<AccountModel>>>(
          listenWhen: (prev, curr) => prev.status != curr.status,
          listener: (context, state) {
            if (state.status == Status.failure) {
              context.showErrorMessage(state.errorMessage ?? 'error_loading_main_accounts'.tr());
            }
            if (state.status == Status.success && state.data != null) {
              if (state.data!.isNotEmpty && _selectedMainAccount == null) {
                setState(() {
                  _selectedMainAccount = state.data!.first;
                  _validateMainAccount = false;
                });
              }
            }
          },
        ),
        // MainAccountsBloc - حساب الشخص
        BlocListener<MainAccountsBloc, BaseState<List<AccountModel>>>(
          listenWhen: (prev, curr) => prev.status != curr.status,
          listener: (context, state) {
            if (state.status == Status.failure) {
              context.showErrorMessage(state.errorMessage ?? 'error_loading_person_accounts'.tr());
            }
          },
        ),
        // CurrenciesBloc
        BlocListener<CurrenciesBloc, CurrenciesState>(
          listenWhen: (prev, curr) => prev.status != curr.status,
          listener: (context, state) {
            if (state.status == Status.failure) {
              context.showErrorMessage(state.errorMessage ?? 'error_loading_currencies'.tr());
            }
            if (state.status == Status.success) {
              if (state.currencies.isNotEmpty && state.selectedCurrency == null) {
                final firstCurrency = state.currencies.first;
                context.read<CurrenciesBloc>().add(
                  SelectCurrency(
                    currencyId: firstCurrency.currencyID,
                    exchangeRate: firstCurrency.rate,
                  ),
                );
              }
            }
          },
        ),
        // BranchesBloc
        BlocListener<BranchesBloc, BranchesState>(
          listenWhen: (prev, curr) => prev.status != curr.status,
          listener: (context, state) {
            if (state.status == Status.failure) {
              context.showErrorMessage(state.errorMessage ?? 'error_loading_branches'.tr());
            }
            if (state.status == Status.success && state.branches.isNotEmpty) {
              final firstBranch = state.branches.first;
              setState(() {
                _selectedBranchId = firstBranch.id;
                _validateBranch = false;
              });
              _loadMainAccounts();  // تحديث الحساب الرئيسي من FillAccountsBloc
              _loadPersonAccounts(); // تحديث حساب الشخص من MainAccountsBloc
            }
          },
        ),
      ],
      child: BlocBuilder<VoucherCreationBloc, BaseState<PostEntryResponseModel>>(
        builder: (context, creationState) {
          final isLoading = creationState.status == Status.loading;

          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: _buildAppBar(),
            body: Stack(
              children: [
                _buildBody(context),
                if (isLoading) _buildLoadingOverlay(),
              ],
            ),
            floatingActionButton: _buildFloatingActionButton(isLoading),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
        },
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: const Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return GradientAppBar(
      title: 'create_voucher'.tr(),
      subtitle: 'enter_voucher_details'.tr(),
      accentIcon: Container(
        width: 34.w,
        height: 34.h,
        decoration: BoxDecoration(
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(Icons.receipt_long, color: AppColors.white, size: 16.sp),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          // 1. نوع السند والتاريخ
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 5, child: _buildVoucherTypeField()),
              SizedBox(width: 12.w),
              Expanded(flex: 5, child: _buildDateField()),
            ],
          ),
          SizedBox(height: 12.h),

          // 2. النمط
          _buildPatternField(),
          SizedBox(height: 12.h),

          // 3. الفرع (اختياري)
          _buildBranchField(),
          SizedBox(height: 12.h),

          // 4. حساب الشخص + قيمة السند في نفس الصف
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 6, child: _buildPersonAccountField(context)),
              SizedBox(width: 12.w),
              Expanded(flex: 4, child: _buildAmountField()),
            ],
          ),
          SizedBox(height: 12.h),

          // 5. بطاقة رصيد حساب الشخص
          _buildPersonAccountBalanceCard(),
          SizedBox(height: 12.h),

          // 6. الحساب الرئيسي (من النمط) - من FillAccountsBloc
          _buildMainAccountField(context),
          SizedBox(height: 12.h),

          // 7. حقول الشيك (إذا كانت مطلوبة)
          if (_showCheckFields()) ...[
            _buildCheckFields(),
            SizedBox(height: 12.h),
          ],

          // 8. العملة وسعر الصرف
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 6, child: _buildCurrencyField(context)),
              SizedBox(width: 12.w),
              Expanded(flex: 4, child: _buildExchangeRateField()),
            ],
          ),
          SizedBox(height: 12.h),

          // 9. الخصم
          _buildDiscountField(),
          SizedBox(height: 12.h),

          // 10. الملاحظات
          _buildNotesField(),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label, {bool isRequired = false}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13.sp, color: AppColors.textDark, fontWeight: FontWeight.w600),
        ),
        if (isRequired)
          Text(
            ' *',
            style: TextStyle(fontSize: 13.sp, color: Colors.red, fontWeight: FontWeight.bold),
          ),
      ],
    );
  }

  Widget _buildVoucherTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('voucher_type'.tr(), isRequired: true),
        SizedBox(height: 6.h),
        FilterField(
          label: 'voucher_type'.tr(),
          value: _voucherTypes.firstWhere(
                (type) => type['id'] == _selectedVoucherTypeId,
            orElse: () => _voucherTypes.first,
          )['name'],
          placeholder: 'select_voucher_type'.tr(),
          isSelected: true,
          icon: Icons.receipt,
          options: _voucherTypeNames,
          enableSearch: false,
          onChanged: (selectedName) {
            if (selectedName != null && _voucherTypeMap.containsKey(selectedName)) {
              final typeId = _voucherTypeMap[selectedName];
              setState(() {
                _selectedVoucherTypeId = typeId!;
                _selectedPattern = null;
                _patterns = [];
                _tableRows = [];
                _selectedPersonAccount = null;
                _selectedMainAccount = null;
                _personAccountBalance = null;
                _addEmptyRow();
              });
              _loadPatterns(typeId!);
              _loadCurrencies();
              _loadPersonAccounts();
              _loadMainAccounts();
            }
          },
          onClear: () {},
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('date'.tr(), isRequired: true),
        SizedBox(height: 6.h),
        InkWell(
          onTap: () async {
            final picked = await _pickDate(_selectedDate);
            if (picked != null) setState(() => _selectedDate = picked);
          },
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: _buildFieldDecoration(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(_selectedDate),
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.textDark),
                ),
                Icon(Icons.calendar_today, size: 20.sp, color: AppColors.brand),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPatternField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('pattern'.tr(), isRequired: true),
        SizedBox(height: 6.h),
        if (_isLoadingPatterns)
          const Center(child: CircularProgressIndicator())
        else if (_patterns.isEmpty)
          _buildEmptyMessage('no_patterns_available'.tr())
        else
          FilterField(
            label: 'pattern'.tr(),
            value: _selectedPattern?.arName ?? _selectedPattern?.enName,
            placeholder: 'select_pattern'.tr(),
            isSelected: _selectedPattern != null,
            icon: Icons.pattern,
            options: _patterns.map((p) => p.arName ?? p.enName ?? '').toList(),
            enableSearch: true,
            searchHint: 'search_pattern'.tr(),
            onChanged: (selectedName) {
              final pattern = _patterns.firstWhere(
                    (p) => (p.arName ?? p.enName ?? '') == selectedName,
                orElse: () => _patterns.first,
              );
              setState(() {
                _selectedPattern = pattern;
                _validatePattern = false;
                _selectedPersonAccount = null;
                _selectedMainAccount = null;
                _personAccountBalance = null;
                _tableRows = [];
                _addEmptyRow();
              });
              _loadMainAccounts(); // تحديث الحساب الرئيسي من FillAccountsBloc
            },
            onClear: () {
              setState(() {
                _selectedPattern = null;
                _selectedPersonAccount = null;
                _selectedMainAccount = null;
                _personAccountBalance = null;
                _tableRows = [];
                _addEmptyRow();
              });
              context.read<FillAccountsBloc>().add(ClearFillAccounts());
            },
          ),
        if (_validatePattern && _selectedPattern == null)
          _buildValidationMessage('please_select_pattern'.tr()),
      ],
    );
  }

  Widget _buildBranchField() {
    return BlocBuilder<BranchesBloc, BranchesState>(
      builder: (context, state) {
        final isLoading = state.status == Status.loading;
        final branches = state.branches;
        final selectedBranch = state.selectedBranch;

        final branchNames = branches.map((branch) =>
        '${branch.braCode} - ${branch.braName}'
        ).toList();

        final branchMap = {
          for (var branch in branches)
            '${branch.braCode} - ${branch.braName}': branch
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldLabel('branch'.tr()), // مش required
            SizedBox(height: 6.h),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (branches.isEmpty)
              _buildEmptyMessage('no_branches_available'.tr())
            else
              FilterField(
                label: 'branch'.tr(),
                value: selectedBranch != null
                    ? '${selectedBranch.braCode} - ${selectedBranch.braName}'
                    : null,
                placeholder: 'select_branch'.tr(),
                isSelected: selectedBranch != null,
                icon: Icons.business,
                options: branchNames,
                enableSearch: true,
                searchHint: 'search_branch'.tr(),
                onChanged: (selectedName) {
                  if (selectedName != null && branchMap.containsKey(selectedName)) {
                    final branch = branchMap[selectedName];
                    if (branch != null) {
                      context.read<BranchesBloc>().add(
                        UpdateBranchesSelection.single(branch.id),
                      );
                      setState(() {
                        _selectedBranchId = branch.id;
                        _validateBranch = false;
                      });
                      _loadMainAccounts(); // تحديث الحساب الرئيسي من FillAccountsBloc
                    }
                  }
                },
                onClear: () {
                  context.read<BranchesBloc>().add(
                    UpdateBranchesSelection.clear(),
                  );
                  setState(() {
                    _selectedBranchId = null;
                  });
                  context.read<FillAccountsBloc>().add(ClearFillAccounts());
                },
              ),
            // إزالة التحقق من الفرع
          ],
        );
      },
    );
  }

  // ==================== حساب الشخص (الاختيار اليدوي) ====================
  // يستخدم MainAccountsBloc
  Widget _buildPersonAccountField(BuildContext context) {
    return BlocBuilder<MainAccountsBloc, BaseState<List<AccountModel>>>(
      builder: (context, state) {
        final isLoading = state.status == Status.loading;
        final accounts = state.data ?? [];

        final accountNames = accounts.map((account) =>
        '${account.acCode ?? ''} - ${account.acName ?? ''}'
        ).toList();

        final accountMap = {
          for (var account in accounts)
            '${account.acCode ?? ''} - ${account.acName ?? ''}': account
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldLabel('person_account'.tr(), isRequired: true),
            SizedBox(height: 6.h),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (accounts.isEmpty)
              _buildEmptyMessage('no_person_accounts_available'.tr())
            else
              FilterField(
                label: 'person_account'.tr(),
                value: _selectedPersonAccount != null
                    ? '${_selectedPersonAccount!.acName ?? ''} - ${_selectedPersonAccount!.acCode ?? ''}'
                    : null,
                placeholder: 'select_person_account'.tr(),
                isSelected: _selectedPersonAccount != null,
                icon: Icons.person,
                options: accountNames,
                enableSearch: true,
                searchHint: 'search_person_account'.tr(),
                onChanged: (selectedName) {
                  if (selectedName != null && accountMap.containsKey(selectedName)) {
                    setState(() {
                      _selectedPersonAccount = accountMap[selectedName];
                      _validatePersonAccount = false;
                      _personAccountBalance = null;
                      _amountController.clear();
                    });
                    if (_selectedPersonAccount != null) {
                      _loadPersonAccountBalance(_selectedPersonAccount!.acID ?? 0);
                    }
                  }
                },
                onClear: () {
                  setState(() {
                    _selectedPersonAccount = null;
                    _personAccountBalance = null;
                    _amountController.clear();
                  });
                },
              ),
            if (_validatePersonAccount && _selectedPersonAccount == null)
              _buildValidationMessage('please_select_person_account'.tr()),
          ],
        );
      },
    );
  }

  // ==================== بطاقة رصيد حساب الشخص ====================
  Widget _buildPersonAccountBalanceCard() {
    if (_isLoadingPersonBalance) {
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.line),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_personAccountBalance == null || _selectedPersonAccount == null) {
      return const SizedBox.shrink();
    }

    final isCredit = _isCreditVoucher();
    final value = isCredit ? _personAccountBalance!.credit : _personAccountBalance!.debit;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 4.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: AppColors.brand.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.account_balance,
                  size: 16.sp,
                  color: AppColors.brand,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  '${_selectedPersonAccount?.acName ?? ''} (${_selectedPersonAccount?.acCode ?? ''})',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(color: AppColors.line),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الرصيد',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                _personAccountBalance!.balance.toStringAsFixed(3),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: _personAccountBalance!.balance < 0 ? Colors.red : AppColors.brandDark,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.red.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'مدين',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _personAccountBalance!.debit.toStringAsFixed(3),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.green.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'دائن',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _personAccountBalance!.credit.toStringAsFixed(3),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Divider(color: AppColors.line),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.brand.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'قيمة السند: ',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  value.toStringAsFixed(3),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.brand,
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isCredit ? Colors.green.withOpacity(0.15) : Colors.red.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    isCredit ? 'دائن' : 'مدين',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: isCredit ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== الحساب الرئيسي (من النمط) ====================
  // يستخدم FillAccountsBloc
  Widget _buildMainAccountField(BuildContext context) {
    return BlocBuilder<FillAccountsBloc, BaseState<List<AccountModel>>>(
      builder: (context, state) {
        final isLoading = state.status == Status.loading;
        final accounts = state.data ?? [];

        final accountNames = accounts.map((account) =>
        '${account.acCode ?? ''} - ${account.acName ?? ''}'
        ).toList();

        final accountMap = {
          for (var account in accounts)
            '${account.acCode ?? ''} - ${account.acName ?? ''}': account
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldLabel('main_account'.tr(), isRequired: true),
            SizedBox(height: 6.h),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (accounts.isEmpty)
              _buildEmptyMessage('no_main_accounts_available'.tr())
            else
              FilterField(
                label: 'main_account'.tr(),
                value: _selectedMainAccount != null
                    ? '${_selectedMainAccount!.acCode ?? ''} - ${_selectedMainAccount!.acName ?? ''}'
                    : null,
                placeholder: 'select_main_account'.tr(),
                isSelected: _selectedMainAccount != null,
                icon: Icons.account_balance,
                options: accountNames,
                enableSearch: true,
                searchHint: 'search_main_account'.tr(),
                onChanged: (selectedName) {
                  if (selectedName != null && accountMap.containsKey(selectedName)) {
                    setState(() {
                      _selectedMainAccount = accountMap[selectedName];
                      _validateMainAccount = false;
                    });
                  }
                },
                onClear: () {
                  setState(() {
                    _selectedMainAccount = null;
                  });
                },
              ),
            if (_validateMainAccount && _selectedMainAccount == null)
              _buildValidationMessage('please_select_main_account'.tr()),
          ],
        );
      },
    );
  }

  Widget _buildAmountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('voucher_value'.tr(), isRequired: true),
        SizedBox(height: 6.h),
        Container(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: _buildFieldDecoration(
            borderColor: _validateAmount ? Colors.red : null,
            borderWidth: _validateAmount ? 2 : null,
          ),
          child: Center(
            child: TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(fontSize: 14.sp, color: AppColors.textDark),
              decoration: _buildTextFieldDecoration('0.000'),
              onChanged: (_) => setState(() => _validateAmount = false),
            ),
          ),
        ),
        if (_validateAmount)
          _buildValidationMessage('please_enter_valid_amount'.tr()),
      ],
    );
  }

  Widget _buildCurrencyField(BuildContext context) {
    return BlocBuilder<CurrenciesBloc, CurrenciesState>(
      builder: (context, state) {
        final isLoading = state.status == Status.loading;
        final currencies = state.currencies;
        final selectedCurrency = state.selectedCurrency;

        final currencyNames = currencies.map((currency) =>
        currency.currencyName ?? currency.currencyName ?? ''
        ).toList();

        final currencyMap = {
          for (var currency in currencies)
            (currency.currencyName ?? currency.currencyName ?? ''): currency
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldLabel('currency'.tr(), isRequired: true),
            SizedBox(height: 6.h),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (currencies.isEmpty)
              _buildEmptyField('no_currencies_available'.tr())
            else
              FilterField(
                label: 'currency'.tr(),
                value: selectedCurrency != null
                    ? (selectedCurrency.currencyName ?? selectedCurrency.currencyName ?? '')
                    : null,
                placeholder: 'select_currency'.tr(),
                isSelected: selectedCurrency != null,
                icon: Icons.currency_exchange,
                options: currencyNames,
                enableSearch: true,
                searchHint: 'search_currency'.tr(),
                onChanged: (selectedName) {
                  if (selectedName != null && currencyMap.containsKey(selectedName)) {
                    final currency = currencyMap[selectedName];
                    if (currency != null) {
                      context.read<CurrenciesBloc>().add(
                        SelectCurrency(currencyId: currency.currencyID, exchangeRate: currency.rate),
                      );
                      setState(() => _validateCurrency = false);
                    }
                  }
                },
                onClear: () {},
              ),
            if (_validateCurrency && selectedCurrency == null)
              _buildValidationMessage('please_select_currency'.tr()),
          ],
        );
      },
    );
  }

  Widget _buildExchangeRateField() {
    final currencyState = context.watch<CurrenciesBloc>().state;
    final exchangeRate = currencyState.selectedExchangeRate ?? 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('exchange_rate'.tr()),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: _buildFieldDecoration(),
          child: Row(
            children: [
              Icon(Icons.currency_exchange, size: 18.sp, color: AppColors.brand),
              SizedBox(width: 8.w),
              Text(
                exchangeRate.toStringAsFixed(3),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCheckFields() {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldLabel('check_number'.tr()),
            SizedBox(height: 6.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: _buildFieldDecoration(),
              child: TextField(
                controller: _checkNumberController,
                style: TextStyle(fontSize: 14.sp, color: AppColors.textDark),
                decoration: _buildTextFieldDecoration('enter_check_number'.tr()),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldLabel('check_due_date'.tr()),
            SizedBox(height: 6.h),
            InkWell(
              onTap: () async {
                final picked = await _pickDate(_checkDueDate ?? DateTime.now());
                if (picked != null) {
                  setState(() => _checkDueDate = picked);
                }
              },
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: _buildFieldDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _checkDueDate != null
                          ? _formatDate(_checkDueDate!)
                          : 'select_due_date'.tr(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: _checkDueDate != null ? AppColors.textDark : AppColors.textMuted,
                      ),
                    ),
                    Icon(Icons.calendar_today, size: 20.sp, color: AppColors.brand),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDiscountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('discount_value'.tr()),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: _buildFieldDecoration(),
          child: TextField(
            controller: _discountValueController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(fontSize: 14.sp, color: AppColors.textDark),
            decoration: _buildTextFieldDecoration('0.000'),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('notes'.tr()),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: _buildFieldDecoration(),
          child: TextField(
            controller: _notesController,
            maxLines: 3,
            style: TextStyle(fontSize: 14.sp, color: AppColors.textDark),
            decoration: _buildTextFieldDecoration('optional_notes'.tr()),
          ),
        ),
      ],
    );
  }

  BoxDecoration _buildFieldDecoration({Color? borderColor, double? borderWidth}) {
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(
        color: borderColor ?? AppColors.line,
        width: borderWidth ?? 1,
      ),
    );
  }

  InputDecoration _buildTextFieldDecoration(String hint) {
    return InputDecoration(
      border: InputBorder.none,
      hintText: hint,
      hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 13.sp),
    );
  }

  Widget _buildEmptyMessage(String message) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Text(
        message,
        style: TextStyle(color: AppColors.textMuted),
      ),
    );
  }

  Widget _buildEmptyField(String message) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: _buildFieldDecoration(),
      child: Text(
        message,
        style: TextStyle(color: AppColors.textMuted),
      ),
    );
  }

  Widget _buildValidationMessage(String message) {
    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: Text(
        message,
        style: TextStyle(color: Colors.red, fontSize: 12.sp),
      ),
    );
  }

  Widget _buildFloatingActionButton(bool isLoading) {
    return FloatingActionButton.extended(
      onPressed: isLoading ? null : _createVoucher,
      backgroundColor: isLoading ? AppColors.textMuted : AppColors.brand,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      icon: isLoading
          ? SizedBox(
        height: 20.h,
        width: 20.w,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      )
          : Icon(Icons.save, size: 20.sp),
      label: Text(
        isLoading ? 'loading'.tr() : 'save_voucher'.tr(),
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}