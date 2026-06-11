part of '../../invoice_collection_imports.dart';
class CollectionMobileLayout extends StatefulWidget {
  final Map<String, dynamic>? editCollection;

  const CollectionMobileLayout({super.key, this.editCollection});

  @override
  State<CollectionMobileLayout> createState() => _CollectionMobileLayoutState();
}

class _CollectionMobileLayoutState extends State<CollectionMobileLayout> {
  final _formKey           = GlobalKey<FormState>();
  final _creditController  = TextEditingController();
  final _localValueCtrl    = TextEditingController();
  final _localValue2Ctrl   = TextEditingController();
  final _keyNetCtrl        = TextEditingController();
  final _agreementNoCtrl   = TextEditingController();
  final _checkNumberCtrl   = TextEditingController();
  final _noteCtrl          = TextEditingController();

  String _creationDate = _today();
  String _checkDueDate = _today();

  /// Server expects yyyy/MM/dd (matches the old project's
  /// `DateFormat('yyyy/MM/dd', 'en_US')` on both `CreationDateTime` and
  /// `CheckDueDate`). Sending dd/MM/yyyy gets the request rejected with 400.
  static String _today() {
    final now = DateTime.now();
    return '${now.year}/'
        '${now.month.toString().padLeft(2, '0')}/'
        '${now.day.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _prefillEdit();
  }

  void _prefillEdit() {
    final e = widget.editCollection;
    if (e == null) return;
    _creditController.text  = e['BankAcName']?.toString()    ?? '';
    _localValueCtrl.text    = e['VoucherValue']?.toString()  ?? '';
    _localValue2Ctrl.text   = e['VoucherValue']?.toString()  ?? '';
    _noteCtrl.text          = e['Notes']?.toString()         ?? '';
    if (e['VoucherAccounts'] != null &&
        (e['VoucherAccounts'] as List).isNotEmpty) {
      _keyNetCtrl.text       = e['VoucherAccounts'][0]['KeyNet']?.toString()      ?? '';
      _agreementNoCtrl.text  = e['VoucherAccounts'][0]['AgreementNo']?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _creditController.dispose();
    _localValueCtrl.dispose();
    _localValue2Ctrl.dispose();
    _keyNetCtrl.dispose();
    _agreementNoCtrl.dispose();
    _checkNumberCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  void _submit(BuildContext context, InvoiceCollectionState state) {
    final isEdit = widget.editCollection != null;

    final request = CollectionRequestModel(
      branchId:         state.selectedBranchId,
      creationDateTime: _creationDate,
      codePw:           state.selectedCodePw,
      currencyId:       state.selectedCurrencyId,
      currencyRate:     state.selectedCurrencyRate,
      voucherValue:     _localValue2Ctrl.text,
      checkNumber:      _checkNumberCtrl.text.isEmpty ? '0' : _checkNumberCtrl.text,
      checkDueDate:     _checkDueDate,
      notes:            _noteCtrl.text,
      voucherType:      state.selectedVoucherType,
      invoiceId:        state.invoiceId,
      invoiceNo:        state.invoiceNo,
      acId:             state.acId,
      agreementNo:      num.tryParse(_agreementNoCtrl.text) ?? 0,
      keyNet:           num.tryParse(_keyNetCtrl.text)      ?? 0,
      voucherNumber:    isEdit ? widget.editCollection!['VoucherNumber'] : null,
    );

    context.read<InvoiceCollectionBloc>().add(
      isEdit ? EditCollection(request) : SubmitCollection(request),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return BlocBuilder<InvoiceCollectionBloc, InvoiceCollectionState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header box ──────────────────────────────────────────────
              Container(
                padding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: const Color(0xff006296),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    // Branch + Date
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: _buildLabel(
                            'invoice_collection.branch'.tr(),
                            color: Colors.white,
                            child: state.branchesStatus == Status.loading
                                ? _loadingField()
                                : _buildDropdown<Map<String, dynamic>>(
                              value: state.selectedBranch,
                              hint:  'invoice_collection.select_branch'.tr(),
                              items: state.branches
                                  .map(
                                    (b) => DropdownMenuItem(
                                  value: b,
                                  child: Text(
                                    isAr
                                        ? b['BraName'] ?? ''
                                        : b['BraEName'] ?? '',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                                  .toList(),
                              onChanged: (v) {
                                if (v != null) {
                                  context
                                      .read<InvoiceCollectionBloc>()
                                      .add(CollectionBranchChanged(
                                      v['ID'] as int));
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          flex: 2,
                          child: _buildLabel(
                            'invoice_collection.date'.tr(),
                            color: Colors.white,
                            child: _DateButton(
                              value:    _creationDate,
                              onPicked: (d) =>
                                  setState(() => _creationDate = d),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    // Credit account
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 3,
                          child: _buildLabel(
                            'invoice_collection.credit_account'.tr(),
                            color: Colors.white,
                            child: _textField(
                              controller: _creditController,
                              readOnly:   true,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        ElevatedButton.icon(
                          onPressed: () async {
                            // Reuse the basket's CustomerSearchDialog — it
                            // already wraps itself in BlocProvider<
                            // AccountSearchBloc> and returns the picked
                            // CustomerAccountModel via Navigator.pop.
                            final picked = await showDialog<CustomerAccountModel>(
                              context: context,
                              builder: (_) => const CustomerSearchDialog(),
                            );
                            if (picked == null || !context.mounted) return;
                            final name = picked.displayName(isAr);
                            context
                                .read<InvoiceCollectionBloc>()
                                .add(CollectionCustomerSearched(
                                  acId: picked.accountId,
                                  acName: name,
                                ));
                            _creditController.text = name;
                          },
                          icon: const Icon(Icons.search, color: Colors.white),
                          label: Text(
                            'common.search'.tr(),
                            style: AppTextTheme.caption
                                .copyWith(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff186FDC),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 12.h),
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    // Collection method + Currency
                    Row(
                      children: [
                        Expanded(
                          child: _buildLabel(
                            'invoice_collection.collection_method'.tr(),
                            color: Colors.white,
                            child: state.payWaysStatus == Status.loading
                                ? _loadingField()
                                : _buildDropdown<Map<String, dynamic>>(
                              value: state.payWays
                                  .where((p) =>
                              (p['Code_PW'] as num).toInt() ==
                                  state.selectedCodePw)
                                  .isNotEmpty
                                  ? state.payWays.firstWhere((p) =>
                              (p['Code_PW'] as num).toInt() ==
                                  state.selectedCodePw)
                                  : null,
                              hint: 'invoice_collection.payment_method'.tr(),
                              items: state.payWays
                                  .map(
                                    (p) => DropdownMenuItem(
                                  value: p,
                                  child: Text(
                                    isAr
                                        ? p['Name_PW'] ?? ''
                                        : p['EName_PW'] ?? '',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                                  .toList(),
                              onChanged: (v) {
                                if (v != null) {
                                  context
                                      .read<InvoiceCollectionBloc>()
                                      .add(CollectionPayWayChanged(
                                      (v['Code_PW'] as num)
                                          .toInt()));
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildLabel(
                            'invoice_collection.currency'.tr(),
                            color: Colors.white,
                            child: state.currenciesStatus == Status.loading
                                ? _loadingField()
                                : _buildDropdown<Map<String, dynamic>>(
                              value: state.selectedCurrency,
                              hint: 'invoice_collection.currency'.tr(),
                              items: state.currencies
                                  .map(
                                    (c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(
                                    isAr
                                        ? c['CurrencyName'] ?? ''
                                        : c['CurrencyEName'] ?? '',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                                  .toList(),
                              onChanged: (v) {
                                if (v != null) {
                                  context
                                      .read<InvoiceCollectionBloc>()
                                      .add(CollectionCurrencyChanged(
                                    currencyId:
                                    v['CurrencyID'] as int,
                                    rate: (v['Rate'] as num)
                                        .toDouble(),
                                  ));
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    // Disbursement + Equivalent (read-only)
                    Row(
                      children: [
                        Expanded(
                          child: _buildLabel(
                            'invoice_collection.disbursement'.tr(),
                            color: Colors.white,
                            child: _textField(
                              readOnly: true,
                              hint: state.selectedCurrencyRate.toString(),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildLabel(
                            'invoice_collection.equivalent'.tr(),
                            color: Colors.white,
                            child: _textField(
                              readOnly: true,
                              hint: state.equivalentRate,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    // Local value + Invoice button
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildLabel(
                            'invoice_collection.local_value'.tr(),
                            color: Colors.white,
                            child: _textField(
                              controller: _localValueCtrl,
                              readOnly:   true,
                              hint:       state.voucherValue.toString(),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              // Spin up a fresh InvoiceSearchBloc for the
                              // picker route and seed it with an "all for
                              // customer" load so the list isn't empty on
                              // first render. -1 = no customer filter (the
                              // old InvoiceSearchCubit convention).
                              final initialCustomerId = state.acId == 0
                                  ? -1
                                  : state.acId.toInt();
                              final searchBloc =
                                  GetIt.instance<InvoiceSearchBloc>();
                              final row = await Navigator.push<
                                  CollectionInvoiceRowModel?>(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: searchBloc
                                      ..add(LoadAllInvoicesForCustomer(
                                          initialCustomerId)),
                                    child: InvoicePickerScreen(
                                      initialCustomerId: initialCustomerId,
                                    ),
                                  ),
                                ),
                              );
                              if (row == null || !context.mounted) return;
                              final customerLabel = isAr
                                  ? row.customerArName
                                  : row.customerEnName;
                              context
                                  .read<InvoiceCollectionBloc>()
                                  .add(CollectionInvoiceLinked(
                                    invoiceId: row.invoiceId,
                                    invoiceNo: row.invoiceNo,
                                    voucherValue: row.totalValue,
                                    customerName: customerLabel,
                                    acId: row.customerId,
                                  ));
                              _localValueCtrl.text =
                                  row.totalValue.toStringAsFixed(2);
                              _localValue2Ctrl.text =
                                  row.totalValue.toStringAsFixed(2);
                              _creditController.text = customerLabel;
                            },
                            icon: const Icon(Icons.receipt_long,
                                color: Colors.white),
                            label: Text(
                              'invoice_collection.in_voice'.tr(),
                              style: AppTextTheme.caption
                                  .copyWith(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff186FDC),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 12.h),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // ── Details box ──────────────────────────────────────────────
              Container(
                padding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: const Color(0xffEDF3FB),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Bond type
                    _buildLabel(
                      'invoice_collection.type_of_receipt'.tr(),
                      child: state.bondTypesStatus == Status.loading
                          ? _loadingField()
                          : _buildDropdown<BondTypeModel>(
                        value: state.bondTypes
                            .where((b) =>
                        b.voucherType ==
                            state.selectedVoucherType)
                            .isNotEmpty
                            ? state.bondTypes.firstWhere((b) =>
                        b.voucherType ==
                            state.selectedVoucherType)
                            : null,
                        hint: 'invoice_collection.type_of_receipt'.tr(),
                        items: state.bondTypes
                            .map(
                              (b) => DropdownMenuItem(
                            value: b,
                            child: Text(
                              isAr ? b.arabicName : b.englishName,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                            .toList(),
                        onChanged: (v) {
                          if (v != null) {
                            context
                                .read<InvoiceCollectionBloc>()
                                .add(CollectionBondTypeChanged(
                              voucherType: v.voucherType,
                              bankName:
                              v.customerName ?? v.arabicName,
                            ));
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Bank name (read-only)
                    _textField(
                      readOnly: true,
                      hint: state.selectedBankName,
                    ),
                    SizedBox(height: 8.h),

                    // Local value 2
                    _buildLabel(
                      'invoice_collection.local_value'.tr(),
                      child: _textField(
                        controller:   _localValue2Ctrl,
                        keyboardType: TextInputType.number,
                        validator:    (v) => (v == null || v.isEmpty)
                            ? 'common.required'.tr()
                            : null,
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // KNet + Approval
                    Row(
                      children: [
                        Expanded(
                          child: _buildLabel(
                            'invoice_collection.knet_number'.tr(),
                            child: _textField(
                              controller:   _keyNetCtrl,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildLabel(
                            'invoice_collection.approval_number'.tr(),
                            child: _textField(
                              controller:   _agreementNoCtrl,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),

                    // Check number + Due date
                    Row(
                      children: [
                        Expanded(
                          child: _buildLabel(
                            'invoice_collection.check_number'.tr(),
                            child: _textField(
                              controller:   _checkNumberCtrl,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildLabel(
                            'invoice_collection.due_date'.tr(),
                            child: _DateButton(
                              value:    _checkDueDate,
                              onPicked: (d) =>
                                  setState(() => _checkDueDate = d),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),

                    // Notes
                    _buildLabel(
                      'invoice_collection.description'.tr(),
                      child: TextField(
                        controller: _noteCtrl,
                        maxLines:   3,
                        style: AppTextTheme.caption
                            .copyWith(color: AppColors.black),
                        decoration: InputDecoration(
                          hintText:  'invoice_collection.enter_description'.tr(),
                          hintStyle: AppTextTheme.caption
                              .copyWith(color: AppColors.grey),
                          filled:    true,
                          fillColor: AppColors.whiteColor,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(
                                color: AppColors.mainAppColor, width: 1.5),
                          ),
                          isDense:        true,
                          contentPadding: EdgeInsets.all(10.w),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r)),
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              elevation: 0,
                            ),
                            child: Text(
                              'common.cancel'.tr(),
                              style: AppTextTheme.body2Bold
                                  .copyWith(color: AppColors.white),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: BlocBuilder<InvoiceCollectionBloc,
                              InvoiceCollectionState>(
                            buildWhen: (p, c) =>
                            p.submitStatus != c.submitStatus,
                            builder: (context, state) {
                              if (state.submitStatus == Status.loading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    // The enclosing BlocBuilder uses
                                    // buildWhen on submitStatus, so the
                                    // `state` it captured was the initial
                                    // all-zeros snapshot from before
                                    // LoadCollectionSetupData populated
                                    // branches / currencies / voucher type
                                    // and before the customer + invoice
                                    // were picked. Reading the live state
                                    // here guarantees the request body
                                    // carries the user's actual choices
                                    // (BranchId, CurrencyId, VoucherType,
                                    // AcId, InvoiceID, InvoiceNo).
                                    final live = context
                                        .read<InvoiceCollectionBloc>()
                                        .state;
                                    _submit(context, live);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                  widget.editCollection != null
                                      ? Colors.orange
                                      : const Color(0xff1E40AF),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(12.r)),
                                  padding:
                                  EdgeInsets.symmetric(vertical: 14.h),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'invoice_collection.save'.tr(),
                                  style: AppTextTheme.body2Bold
                                      .copyWith(color: AppColors.white),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  Widget _buildLabel(
      String label, {
        required Widget child,
        Color? color,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextTheme.caption.copyWith(
            color: color ?? AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4.h),
        child,
      ],
    );
  }

  Widget _textField({
    TextEditingController? controller,
    bool readOnly = false,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller:   controller,
      readOnly:     readOnly,
      keyboardType: keyboardType,
      validator:    validator,
      style: AppTextTheme.caption.copyWith(color: AppColors.black),
      decoration: InputDecoration(
        hintText:  hint,
        hintStyle: AppTextTheme.caption.copyWith(color: AppColors.grey),
        filled:    true,
        fillColor: readOnly ? AppColors.backgroundColor : AppColors.whiteColor,
        isDense:   true,
        contentPadding:
        EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide:
          BorderSide(color: AppColors.mainAppColor, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      initialValue:      value,
      isExpanded: true,
      decoration: InputDecoration(
        hintText:  hint,
        hintStyle: AppTextTheme.caption.copyWith(color: AppColors.grey),
        filled:    true,
        fillColor: AppColors.whiteColor,
        isDense:   true,
        contentPadding:
        EdgeInsets.symmetric(horizontal: 12.w, vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide:
          BorderSide(color: AppColors.mainAppColor, width: 1.5),
        ),
      ),
      items:     items,
      onChanged: onChanged,
      style:     AppTextTheme.caption.copyWith(color: AppColors.black),
    );
  }

  Widget _loadingField() {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color:        AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
        border:       Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: SizedBox(
          width: 16.w, height: 16.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.mainAppColor,
          ),
        ),
      ),
    );
  }
}

// ── Date Button ───────────────────────────────────────────────────────────────
class _DateButton extends StatelessWidget {
  final String value;
  final ValueChanged<String> onPicked;

  const _DateButton({required this.value, required this.onPicked});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context:      context,
          initialDate:  DateTime.now(),
          firstDate:    DateTime(2000),
          lastDate:     DateTime(2100),
        );
        if (picked != null) {
          // yyyy/MM/dd — see `_today()` in CollectionMobileLayout.
          onPicked(
            '${picked.year}/'
                '${picked.month.toString().padLeft(2, '0')}/'
                '${picked.day.toString().padLeft(2, '0')}',
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color:        AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(8.r),
          border:       Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_outlined,
                color: AppColors.mainAppColor, size: 14.sp),
            SizedBox(width: 6.w),
            Text(value,
                style: AppTextTheme.caption.copyWith(color: AppColors.black)),
          ],
        ),
      ),
    );
  }
}