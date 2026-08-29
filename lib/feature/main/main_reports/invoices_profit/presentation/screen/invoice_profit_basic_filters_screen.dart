import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import '../widget/lookup_picker_dialog.dart';
import '../../invoice_profit_imports.dart';

import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import '../widget/lookup_picker_dialog.dart';
import '../../invoice_profit_imports.dart';

class InvoiceProfitBasicFiltersScreen extends StatefulWidget {
  const InvoiceProfitBasicFiltersScreen({super.key});

  @override
  State<InvoiceProfitBasicFiltersScreen> createState() =>
      _InvoiceProfitBasicFiltersScreenState();
}

class _InvoiceProfitBasicFiltersScreenState
    extends State<InvoiceProfitBasicFiltersScreen> {
  DateTime fromDate = DateTime(2026, 7, 28);
  DateTime toDate = DateTime(2026, 7, 29);

  // ✅ كل الفلاتر فاضية
  int? selectedParentAccountId;
  int? selectedCustomerId;
  int? selectedBranchId;
  int? selectedPayWayId;
  int? selectedBillSourceId;
  List<int> selectedBsrCodes = [];

  // ✅ القيم من الـ UI
  String viewMode = 'analytical';
  String sortBy = 'date';
  String groupBy = 'pattern';
  bool report_showRemaining = false;
  bool report_zeroInvoices = false;
  bool report_costFromLastPurchase = false;
  bool report_freeCost = false;
  bool report_showPaid = true;
  bool report_showClientBranch = false;
  bool report_totalWeight = false;
  bool report_hideDiscount = false;
  bool report_totalReps = false;
  double discountPercent = 0.0;

  final TextEditingController _searchController = TextEditingController();

  String tr(String key) => key.tr();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAllLookups();
    });
  }

  void _loadAllLookups() {
    context.read<ParentAccountsBloc>().add(LoadParentAccounts());
    context.read<CustomersBloc>().add(const LoadCustomers());
    context.read<EmployeesBloc>().add(const LoadEmployees());
    context.read<CostCentersBloc>().add(LoadCostCenters());
    context.read<CurrenciesBloc>().add(LoadCurrencies());
    context.read<UsersBloc>().add(LoadUsers());
    context.read<BranchesBloc>().add(LoadBranches());
    context.read<PayWaysBloc>().add(LoadPayWays());
    context.read<BillSourcesBloc>().add(LoadBillSources());
  }

  // ============================================================
  // 1. Default Selection Logic
  // ============================================================
  void _setDefaultSelections() {
    // ✅ كل الفلاتر فاضية - مفيش حاجة مختارة افتراضياً

    // ✅ مصدر التقرير بس اللي لسه محتاج تحديد
    final billSourcesState = context.read<BillSourcesBloc>().state;
    if (billSourcesState.status == Status.success &&
        billSourcesState.billSources.isNotEmpty &&
        selectedBillSourceId == null) {
      final first = billSourcesState.billSources.first;
      setState(() {
        selectedBillSourceId = first.code == 0 ? 0 : first.code;
      });
      context.read<BillSourcesBloc>()
          .add(SelectBillSource(billSourceId: selectedBillSourceId!));
    }
  }

  // ============================================================
  // 2. Validation Logic
  // ============================================================
  bool _validateSelections() {
    if (selectedParentAccountId != null &&
        selectedParentAccountId != 0 &&
        selectedCustomerId != null &&
        selectedCustomerId != 0) {
      _showConflictDialog(
        context,
        title: tr("warning"),
        message: tr("cannot_select_account_and_client"),
        onConfirm: () {
          setState(() {
            selectedParentAccountId = null;
            selectedCustomerId = null;
            context.read<ParentAccountsBloc>().add(SelectParentAccount(parentAccountId: 0));
            context.read<CustomersBloc>().add(SelectCustomer(customerId: 0));
          });
          Navigator.of(context).pop();
        },
      );
      return false;
    }
    return true;
  }

  // ============================================================
  // 3. Apply Filters
  // ============================================================
  void _applyFilters() {
    if (!_validateSelections()) return;

    // ============================================================
    // 1. mode - من viewMode
    // ============================================================
    int apiMode = 1;
    switch (viewMode) {
      case 'analytical':
        apiMode = 1;
        break;
      case 'monthly':
        apiMode = 2;
        break;
      case 'daily':
        apiMode = 3;
        break;
      case 'weekly':
        apiMode = 4;
        break;
    }

    // ============================================================
    // 2. groupBy - من groupBy
    // ============================================================
    int apiGroupBy = 0;
    switch (groupBy) {
      case 'none':
        apiGroupBy = 0;
        break;
      case 'customer':
        apiGroupBy = 1;
        break;
      case 'date':
        apiGroupBy = 2;
        break;
      case 'pattern':
        apiGroupBy = 3;
        break;
    }

    // ============================================================
    // 3. orderBy - من sortBy
    // ============================================================
    int apiOrderBy = 0;
    switch (sortBy) {
      case 'date':
        apiOrderBy = 0;
        break;
      case 'invoice_number':
        apiOrderBy = 1;
        break;
    }

    // ============================================================
    // 4. bsrCodes - من BillSourcesBloc أو selectedBsrCodes
    // ============================================================
    List<int> finalBsrCodes = selectedBsrCodes;
    final billSourcesState = context.read<BillSourcesBloc>().state;
    if (billSourcesState.isAllSelected) {
      finalBsrCodes = billSourcesState.billSources
          .where((element) => element.code != 0)
          .map((e) => e.code)
          .toList();
    }

    // ============================================================
    // 5. empId - من EmployeesBloc (null لو مفيش اختيار)
    // ============================================================
    final employeesState = context.read<EmployeesBloc>().state;
    final int? finalEmployeeId = employeesState.selectedEmployeeId != null
        ? int.tryParse(employeesState.selectedEmployeeId!)
        : null;

    // ============================================================
    // 6. costCenterId - من CostCentersBloc (null لو مفيش اختيار)
    // ============================================================
    final costCentersState = context.read<CostCentersBloc>().state;
    final int? finalCostCenterId = costCentersState.selectedCostCenterId;

    // ============================================================
    // 7. currencyId و exchangeRate - من CurrenciesBloc (null لو مفيش اختيار)
    // ============================================================
    final currenciesState = context.read<CurrenciesBloc>().state;
    final int? finalCurrencyId = currenciesState.selectedCurrencyId;
    final double finalExchangeRate = currenciesState.selectedExchangeRate ?? 1.0;

    // ============================================================
    // 8. userName - من UsersBloc (null لو مفيش اختيار)
    // ============================================================
    final usersState = context.read<UsersBloc>().state;
    final String? finalUserName = usersState.selectedUserName;

    // ============================================================
    // 9. payTypes - من PayWaysBloc ([] لو مفيش اختيار = الكل)
    // ============================================================
    final payWaysState = context.read<PayWaysBloc>().state;
    final List<String> finalPayTypes = payWaysState.selectedPayWay != null
        ? [payWaysState.selectedPayWay!.name_PW]
        : [];

    // ============================================================
    // 10. branchId - من BranchesBloc (null لو مفيش اختيار)
    // ============================================================
    final branchesState = context.read<BranchesBloc>().state;
    final int? finalBranchId = branchesState.selectedBranch?.id;

    // ============================================================

    final request = BillRevenueRequestModel(
      // ✅ التواريخ - من الـ UI
      startDate: DateFormat('yyyy-MM-dd').format(fromDate),
      endDate: DateFormat('yyyy-MM-dd').format(toDate),

      // ✅ mode, groupBy, orderBy - من الـ UI
      mode: apiMode,
      groupBy: apiGroupBy,
      orderBy: apiOrderBy,

      // ✅ العملة - من CurrenciesBloc (null لو مفيش اختيار)
      currencyID: finalCurrencyId,

      // ✅ سعر الصرف - من CurrenciesBloc (1.0 لو مفيش اختيار)
      exchangeRate: finalExchangeRate,

      // ✅ العميل - من CustomerPicker (null لو مفيش اختيار)
      custId: selectedCustomerId,

      // ✅ الحساب - من ParentAccountPicker (null لو مفيش اختيار)
      parentAcId: selectedParentAccountId,

      // ✅ المندوب - من EmployeesBloc (null لو مفيش اختيار)
      empId: finalEmployeeId,

      // ✅ مركز التكلفة - من CostCentersBloc (null لو مفيش اختيار)
      costCenterId: finalCostCenterId,

      // ✅ الفرع - من BranchesBloc (null لو مفيش اختيار)
      branchId: finalBranchId,

      // ✅ الصندوق - null
      storeId: null,

      // ✅ مصادر الفواتير - من BillSourcesBloc
      bsrCodes: finalBsrCodes,

      // ✅ طرق الدفع - من PayWaysBloc ([] = الكل)
      payTypes: finalPayTypes,

      // ✅ المستخدم - من UsersBloc (null لو مفيش اختيار)
      userName: finalUserName,

      // ✅ الخيارات - من الـ UI
      showZeroBillsOnly: report_zeroInvoices,
      filterByDiscount: report_hideDiscount,
      minDiscountPercentage: discountPercent == 0.0 ? null : discountPercent,
      costFromLastBuy: report_costFromLastPurchase,
      showDisc: !report_hideDiscount,
      showFreeCost: report_freeCost,
      showFreeType: report_freeCost,
      showPrepaid: report_showPaid,
      showRemainder: report_showRemaining,
      showTotalSalesmen: report_totalReps,
      showCustomerBranch: report_showClientBranch,
      showClientBranch: report_showClientBranch,
      showTotalWeight: report_totalWeight,
      language: context.locale.languageCode,
    );

    logger(const JsonEncoder.withIndent('  ').convert(request.toJson()));

    context.read<InvoiceProfitBloc>().add(LoadInvoiceProfitReport(request: request));
  }

  void _resetFilters() {
    setState(() {
      // ✅ كل الفلاتر ترجع فاضية
      selectedParentAccountId = null;
      selectedCustomerId = null;
      selectedBranchId = null;
      selectedPayWayId = null;
      selectedBillSourceId = null;
      selectedBsrCodes = [];
      viewMode = 'analytical';
      sortBy = 'date';
      groupBy = 'pattern';
      report_showRemaining = false;
      report_zeroInvoices = false;
      report_costFromLastPurchase = false;
      report_freeCost = false;
      report_showPaid = true;
      report_showClientBranch = false;
      report_totalWeight = false;
      report_hideDiscount = false;
      report_totalReps = false;
      discountPercent = 0.0;
      final now = DateTime.now();
      fromDate = DateTime(now.year, 1, 1);
      toDate = now;
    });

    // ✅ إعادة تحميل الـ Blocs
    context.read<EmployeesBloc>().add(const LoadEmployees());
    context.read<CostCentersBloc>().add(LoadCostCenters());
    context.read<CurrenciesBloc>().add(LoadCurrencies());
    context.read<UsersBloc>().add(LoadUsers());
    context.read<BranchesBloc>().add(LoadBranches());
    context.read<PayWaysBloc>().add(LoadPayWays());
  }

  @override
  Widget build(BuildContext context) {
    _setDefaultSelections();

    return BlocConsumer<InvoiceProfitBloc, BaseState<InvoiceProfitResponseModel>>(
      listener: (context, state) {
        if (state.status == Status.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? tr("error_occurred")),
              backgroundColor: AppColors.red,
            ),
          );
        } else if (state.status == Status.success) {
          if (state.data != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => InvoiceProfitResultsScreen(
                  reportData: state.data!,
                ),
              ),
            );
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.slateBg,
          appBar: GradientAppBar(
            title: "invoice_profits".tr(),
            subtitle: "basic_filters".tr(),
            onBack: () => Navigator.of(context).maybePop(),
            accentIcon: Container(
              width: 34.w,
              height: 34.h,
              decoration: BoxDecoration(
                color: AppColors.orange,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.receipt_long,
                color: Colors.white,
                size: 16.sp,
              ),
            ),
          ),
          body: Stack(
            children: [
              ListView(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 10.h),
                children: [
                  // ============================================================
                  // 📅 الفترة
                  // ============================================================
                  FilterSectionLabel(title: "period".tr()),
                  Row(
                    children: [
                      DateFieldTile(
                        label: tr("from_date"),
                        value: fromDate,
                        onChanged: (d) => setState(() => fromDate = d),
                      ),
                      SizedBox(width: 10.w),
                      DateFieldTile(
                        label: tr("to_date"),
                        value: toDate,
                        onChanged: (d) => setState(() => toDate = d),
                      ),
                    ],
                  ),

                  // ============================================================
                  // 📋 بيانات الفاتورة
                  // ============================================================
                  FilterSectionLabel(title: tr("invoice_data")),

                  // الحساب
                  BlocBuilder<ParentAccountsBloc, ParentAccountsState>(
                    builder: (context, state) {
                      String displayValue = "";
                      if (state.status == Status.success &&
                          state.selectedParentAccount != null) {
                        displayValue = context.locale.languageCode == 'ar'
                            ? state.selectedParentAccount!.acName
                            : state.selectedParentAccount!.acEName;
                      }
                      return FilterFieldTile(
                        label: tr("account"),
                        value: displayValue,
                        placeholder: tr("select_parent_account"),
                        onTap: () => showParentAccountPicker(context),
                      );
                    },
                  ),
                  SizedBox(height: 10.h),

                  // العميل
                  BlocBuilder<CustomersBloc, CustomersState>(
                    builder: (context, state) {
                      String displayValue = "";
                      if (state.status == Status.success &&
                          state.selectedCustomer != null) {
                        displayValue = context.locale.languageCode == 'ar'
                            ? state.selectedCustomer!.acName
                            : state.selectedCustomer!.acEName;
                      }
                      return FilterFieldTile(
                        label: tr("client"),
                        value: displayValue,
                        placeholder: tr("select_client"),
                        onTap: () => showCustomerPicker(context),
                      );
                    },
                  ),
                  SizedBox(height: 10.h),

                  // المندوب & مركز التكلفة
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: BlocBuilder<EmployeesBloc, EmployeesState>(
                            builder: (context, state) {
                              String displayValue = "";
                              if (state.status == Status.success &&
                                  state.selectedEmployee != null) {
                                displayValue = state.selectedEmployee!.empName;
                              } else if (state.status == Status.loading) {
                                displayValue = tr("loading");
                              }
                              return FilterFieldTile(
                                label: tr("rep"),
                                value: displayValue,
                                placeholder: tr("select_rep"),
                                onTap: () => showEmployeePicker(context),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 5.w),
                          child: BlocBuilder<CostCentersBloc, CostCentersState>(
                            builder: (context, state) {
                              String displayValue = "";
                              if (state.status == Status.success &&
                                  state.selectedCostCenter != null) {
                                displayValue = context.locale.languageCode == 'ar'
                                    ? state.selectedCostCenter!.codeAndArabicName
                                    : state.selectedCostCenter!.codeAndEnglishName;
                              } else if (state.status == Status.loading) {
                                displayValue = tr("loading");
                              }
                              return FilterFieldTile(
                                label: tr("cost_center"),
                                value: displayValue,
                                placeholder: tr("select_cost_center"),
                                onTap: () => showCostCenterPicker(context),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ============================================================
                  // 📋 فلاتر إضافية
                  // ============================================================
                  FilterSectionLabel(title: tr("additional_filters")),

                  // العملة & المستخدم
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: BlocBuilder<CurrenciesBloc, CurrenciesState>(
                            builder: (context, state) {
                              String displayValue = "";
                              if (state.status == Status.success &&
                                  state.selectedCurrency != null) {
                                displayValue = context.locale.languageCode == 'ar'
                                    ? state.selectedCurrency!.currencyName
                                    : state.selectedCurrency!.currencyEName;
                              } else if (state.status == Status.loading) {
                                displayValue = tr("loading");
                              }
                              return FilterFieldTile(
                                label: tr("currency"),
                                value: displayValue,
                                placeholder: tr("select_currency"),
                                onTap: () => showCurrencyPicker(context),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 5.w),
                          child: BlocBuilder<UsersBloc, UsersState>(
                            builder: (context, state) {
                              String displayValue = "";
                              if (state.status == Status.success && state.selectedUser != null) {
                                displayValue = state.selectedUser!.fullUserName;
                              } else if (state.status == Status.loading) {
                                displayValue = tr("loading");
                              }
                              return FilterFieldTile(
                                label: tr("user"),
                                value: displayValue,
                                placeholder: tr("select_user"),
                                onTap: () => showUserPicker(context),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),

                  // الفرع & طريقة الدفع
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: BlocBuilder<BranchesBloc, BranchesState>(
                            builder: (context, state) {
                              String displayValue = "";
                              if (state.status == Status.success &&
                                  state.selectedBranch != null) {
                                displayValue = context.locale.languageCode == 'ar'
                                    ? state.selectedBranch!.braName
                                    : state.selectedBranch!.braEName;
                              } else if (state.status == Status.loading) {
                                displayValue = tr("loading");
                              }
                              return FilterFieldTile(
                                label: tr("branch"),
                                value: displayValue,
                                placeholder: tr("select_branch"),
                                onTap: () => showBranchPicker(context),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 5.w),
                          child: BlocBuilder<PayWaysBloc, PayWaysState>(
                            builder: (context, state) {
                              String displayValue = "";
                              if (state.status == Status.success &&
                                  state.selectedPayWay != null) {
                                displayValue = context.locale.languageCode == 'ar'
                                    ? state.selectedPayWay!.name_PW
                                    : state.selectedPayWay!.eName_PW;
                              } else if (state.status == Status.loading) {
                                displayValue = tr("loading");
                              }
                              return FilterFieldTile(
                                label: tr("pay_way"),
                                value: displayValue,
                                placeholder: tr("select_pay_way"),
                                onTap: () => showPayWayPicker(context),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),

                  // مصدر التقرير
                  BlocBuilder<BillSourcesBloc, BillSourcesState>(
                    builder: (context, state) {
                      String displayValue = "";
                      if (state.status == Status.success &&
                          state.selectedBillSource != null) {
                        displayValue = context.locale.languageCode == 'ar'
                            ? state.selectedBillSource!.arName
                            : state.selectedBillSource!.latinName;
                      }
                      return FilterFieldTile(
                        label: tr("report_source"),
                        value: displayValue,
                        placeholder: tr("select_bill_source"),
                        onTap: () => showBillSourcePicker(context),
                      );
                    },
                  ),
                  SizedBox(height: 14.h),

                  // ============================================================
                  // 📋 الفلاتر المتقدمة
                  // ============================================================
                  InkWell(
                    borderRadius: BorderRadius.circular(12.r),
                    onTap: () async {
                      final resultMap = await Navigator.of(context)
                          .push<Map<String, dynamic>>(
                        MaterialPageRoute(
                          builder: (_) => InvoiceProfitAdvancedFiltersScreen(
                            initialViewMode: viewMode,
                            initialSortBy: sortBy,
                            initialGroupBy: groupBy,
                            initialShowRemaining: report_showRemaining,
                            initialZeroInvoices: report_zeroInvoices,
                            initialCostFromLastPurchase: report_costFromLastPurchase,
                            initialFreeCost: report_freeCost,
                            initialShowPaid: report_showPaid,
                            initialShowClientBranch: report_showClientBranch,
                            initialTotalWeight: report_totalWeight,
                            initialHideDiscount: report_hideDiscount,
                            initialTotalReps: report_totalReps,
                            initialDiscountPercent: discountPercent,
                          ),
                        ),
                      );

                      if (resultMap != null) {
                        setState(() {
                          viewMode = resultMap['viewMode'] ?? 'analytical';
                          sortBy = resultMap['sortBy'] ?? 'date';
                          groupBy = resultMap['groupBy'] ?? 'pattern';
                          report_showRemaining = resultMap['showRemaining'] ?? false;
                          report_zeroInvoices = resultMap['zeroInvoices'] ?? false;
                          report_costFromLastPurchase = resultMap['costFromLastPurchase'] ?? false;
                          report_freeCost = resultMap['freeCost'] ?? false;
                          report_showPaid = resultMap['showPaid'] ?? true;
                          report_showClientBranch = resultMap['showClientBranch'] ?? false;
                          report_totalWeight = resultMap['totalWeight'] ?? false;
                          report_hideDiscount = resultMap['hideDiscount'] ?? false;
                          report_totalReps = resultMap['totalReps'] ?? false;
                          discountPercent = resultMap['discountPercent'] ?? 0.0;
                          selectedBsrCodes = resultMap['bsrCodes'] ?? [];
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.line),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tr("advanced_filter"),
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.brandDark,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  tr("advanced_filter_sub"),
                                  style: TextStyle(
                                    fontSize: 10.5.sp,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_left,
                            color: AppColors.textMuted,
                            size: 18.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // ✅ Loading Overlay
              if (state.status == Status.loading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(),
                          SizedBox(height: 10.h),
                          Text(
                            tr("loading_report"),
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          bottomNavigationBar: FilterBottomBar(
            primaryLabel: tr("view_report"),
            secondaryLabel: tr("reset"),
            onSecondary: _resetFilters,
            onPrimary: _applyFilters,
          ),
        );
      },
    );
  }

  // ============================================================
  // 4. Pickers
  // ============================================================

  void showParentAccountPicker(BuildContext context) {
    final bloc = context.read<ParentAccountsBloc>();
    final state = bloc.state;

    if (selectedCustomerId != null && selectedCustomerId != 0) {
      _showConflictDialog(
        context,
        title: tr("warning"),
        message: tr("cannot_select_account_with_client"),
        onConfirm: () {
          setState(() {
            selectedCustomerId = null;
            context.read<CustomersBloc>().add(SelectCustomer(customerId: 0));
          });
          Navigator.pop(context);
          _showParentAccountPickerDialog(context, bloc, state);
        },
      );
      return;
    }

    _showParentAccountPickerDialog(context, bloc, state);
  }

  void _showParentAccountPickerDialog(
      BuildContext context,
      ParentAccountsBloc bloc,
      ParentAccountsState state,
      ) {
    showLookupPicker<ParentAccountModel>(
      context: context,
      title: tr("select_parent_account"),
      items: state.parentAccounts,
      isSelected: (item) => state.selectedParentAccountId == item.acID,
      titleBuilder: (item) => context.locale.languageCode == 'ar'
          ? item.acName
          : item.acEName,
      subtitleBuilder: (item) => item.acCode,
      onSelected: (item) {
        bloc.add(SelectParentAccount(parentAccountId: item.acID));
        setState(() {
          selectedParentAccountId = item.acID;
        });
      },
    );
  }

  void showCustomerPicker(BuildContext context) {
    final bloc = context.read<CustomersBloc>();
    final state = bloc.state;

    if (selectedParentAccountId != null && selectedParentAccountId != 0) {
      _showConflictDialog(
        context,
        title: tr("warning"),
        message: tr("cannot_select_client_with_account"),
        onConfirm: () {
          setState(() {
            selectedParentAccountId = null;
            context.read<ParentAccountsBloc>().add(SelectParentAccount(parentAccountId: 0));
          });
          Navigator.pop(context);
          _showCustomerPickerWithSearch(context, bloc, state);
        },
      );
      return;
    }

    _showCustomerPickerWithSearch(context, bloc, state);
  }

  void _showCustomerPickerWithSearch(
      BuildContext context,
      CustomersBloc bloc,
      CustomersState state,
      ) {
    if (state.status != Status.success || state.customers.isEmpty) {
      showNoDataSnackBar(context);
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        titlePadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 12.h),
        contentPadding: EdgeInsets.zero,
        title: Text(
          tr("select_client"),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 350.h,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Container(
                  height: 44.h,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.mainAppColor),
                  ),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: AppTextTheme.captionBold,
                    decoration: InputDecoration(
                      hintText: tr("search"),
                      border: InputBorder.none,
                      hintStyle: AppTextTheme.caption,
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      bloc.add(
                        LoadCustomers(search: value.isNotEmpty ? value : null),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<CustomersBloc, CustomersState>(
                  bloc: bloc,
                  builder: (context, state) {
                    if (state.status == Status.loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      itemCount: state.customers.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 1.h,
                        color: const Color(0xFFEEF1F7),
                      ),
                      itemBuilder: (context, index) {
                        final item = state.customers[index];
                        final isSelected = state.selectedCustomerId == item.acID;
                        return Material(
                          color: Colors.transparent,
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 4.h,
                            ),
                            title: Text(
                              context.locale.languageCode == 'ar'
                                  ? item.acName
                                  : item.acEName,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: isSelected
                                    ? AppColors.brand
                                    : AppColors.textDark,
                              ),
                            ),
                            subtitle: Text(
                              item.acCode,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textMuted,
                              ),
                            ),
                            trailing: isSelected ? const SelectedIcon() : null,
                            onTap: () {
                              bloc.add(SelectCustomer(customerId: item.acID));
                              setState(() {
                                selectedCustomerId = item.acID;
                              });
                              Navigator.of(dialogContext).pop();
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              tr("cancel"),
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ],
        actionsPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      ),
    );
  }

  void showEmployeePicker(BuildContext context) {
    final bloc = context.read<EmployeesBloc>();
    final state = bloc.state;

    showLookupPicker<EmployeeModel>(
      context: context,
      title: tr("select_rep"),
      items: state.employees,
      isSelected: (item) => state.selectedEmployeeId == item.empId,
      titleBuilder: (item) => item.empName,
      onSelected: (item) {
        bloc.add(SelectEmployee(employeeId: item.empId));
        setState(() {});
      },
    );
  }

  void showCostCenterPicker(BuildContext context) {
    final bloc = context.read<CostCentersBloc>();
    final state = bloc.state;

    showLookupPicker<CostCenterModel>(
      context: context,
      title: tr("select_cost_center"),
      items: state.costCenters,
      isSelected: (item) => state.selectedCostCenterId == item.coID,
      titleBuilder: (item) => context.locale.languageCode == 'ar'
          ? item.codeAndArabicName
          : item.codeAndEnglishName,
      subtitleBuilder: (item) => item.coName,
      onSelected: (item) {
        bloc.add(SelectCostCenter(costCenterId: item.coID));
        setState(() {});
      },
    );
  }

  void showCurrencyPicker(BuildContext context) {
    final bloc = context.read<CurrenciesBloc>();
    final state = bloc.state;

    showLookupPicker<CurrencyModel>(
      context: context,
      title: tr("select_currency"),
      items: state.currencies,
      isSelected: (item) => state.selectedCurrencyId == item.currencyID,
      titleBuilder: (item) => context.locale.languageCode == 'ar'
          ? item.currencyName
          : item.currencyEName,
      onSelected: (item) {
        // ✅ أرسل الـ ID وسعر الصرف
        bloc.add(SelectCurrency(
          currencyId: item.currencyID,
          exchangeRate: item.rate,
        ));
        setState(() {});
      },
    );
  }

  void showUserPicker(BuildContext context) {
    final bloc = context.read<UsersBloc>();
    final state = bloc.state;

    showLookupPicker<UserModel>(
      context: context,
      title: tr("select_user"),
      items: state.users,
      isSelected: (item) => state.selectedUserName == item.fullUserName,
      titleBuilder: (item) => item.fullUserName,
      onSelected: (item) {
        bloc.add(SelectUser(userName: item.fullUserName));
        setState(() {});
      },
    );
  }

  void showBranchPicker(BuildContext context) {
    final bloc = context.read<BranchesBloc>();
    final state = bloc.state;

    showLookupPicker<BranchModel>(
      context: context,
      title: tr("select_branch"),
      items: state.branches,
      isSelected: (item) => state.selectedBranch == item.id,
      titleBuilder: (item) => context.locale.languageCode == 'ar'
          ? item.braName
          : item.braEName,
      subtitleBuilder: (item) => item.braCode,
      onSelected: (item) {
        bloc.add(UpdateBranchesSelection.single(item.id));
        setState(() {});
      },
    );
  }

  void showPayWayPicker(BuildContext context) {
    final bloc = context.read<PayWaysBloc>();
    final state = bloc.state;

    showLookupPicker<PayWayModel>(
      context: context,
      title: tr("select_pay_way"),
      items: state.payWays,
      isSelected: (item) => state.selectedPayWayId == item.pwid,
      titleBuilder: (item) => context.locale.languageCode == 'ar'
          ? item.name_PW
          : item.eName_PW,
      onSelected: (item) {
        bloc.add(SelectPayWay(payWayId: item.pwid));
        setState(() {});
      },
    );
  }

  void showBillSourcePicker(BuildContext context) {
    final bloc = context.read<BillSourcesBloc>();
    final state = bloc.state;

    if (state.status != Status.success || state.billSources.isEmpty) {
      showNoDataSnackBar(context);
      return;
    }

    showLookupPicker<BillSourceModel>(
      context: context,
      title: tr("select_bill_source"),
      items: state.billSources,
      isSelected: (item) {
        if (state.isAllSelected) {
          return item.code == 0;
        }
        return state.selectedBillSourceId == item.code;
      },
      titleBuilder: (item) => context.locale.languageCode == 'ar'
          ? item.arName
          : item.latinName,
      onSelected: (item) {
        bloc.add(SelectBillSource(billSourceId: item.code));
        setState(() {
          selectedBillSourceId = item.code == 0 ? null : item.code;
        });
      },
    );
  }

  // ============================================================
  // 5. Conflict Dialog
  // ============================================================
  void _showConflictDialog(
      BuildContext context, {
        required String title,
        required String message,
        required VoidCallback onConfirm,
      }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: AppColors.orange,
              size: 28.sp,
            ),
            SizedBox(width: 10.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textDark,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              tr("cancel"),
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textMuted,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            ),
            child: Text(
              tr("confirm"),
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showNoDataSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(tr("no_data_available")),
        backgroundColor: AppColors.red,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}