import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';

import '../../../invoices_profit/data/models/employee_model.dart';
export '../../../shared/shared_imports.dart';


import '../../../invoices_profit/presentation/manager/employees/bloc/employees_bloc.dart';
import '../../../invoices_profit/presentation/manager/employees/bloc/employees_event.dart';
import '../../../invoices_profit/presentation/manager/employees/bloc/employees_state.dart';
import '../../../invoices_profit/presentation/widget/lookup_picker_dialog.dart';
import '../../../shared/branches/data/models/branch_model.dart';
import '../../../shared/branches/presentation/manager/bloc/branches_bloc.dart';
import '../../../shared/branches/presentation/manager/bloc/branches_event.dart';
import '../../../shared/branches/presentation/manager/bloc/branches_state.dart';
import '../../receipts_and_payments_movement_report_import.dart';

class VouchersBasicFiltersScreen extends StatefulWidget {
  const VouchersBasicFiltersScreen({super.key});

  @override
  State<VouchersBasicFiltersScreen> createState() =>
      _VouchersBasicFiltersScreenState();
}

class _VouchersBasicFiltersScreenState
    extends State<VouchersBasicFiltersScreen> {

  DateTime fromDate = DateTime(2026, 8, 1);
  DateTime toDate = DateTime(2026, 8, 3);

  String? selectedReceivedFrom;
  String? selectedDeliveredTo;
  String? selectedEmployee;
  int? selectedCostCenter;
  int? selectedCurrency;
  String exchangeRate = "1";
  int? selectedBranch;


  int? selectedReportSource;


  bool showReceipts = true;
  bool showPayments = true;
  bool showNetVoucher = true;
  bool showPosted = true;
  bool showUnposted = true;
  bool repByClient = true;


  int sortIndex = 0;


  final TextEditingController _searchReceivedFrom = TextEditingController();
  final TextEditingController _searchDeliveredTo = TextEditingController();

  String tr(String key) => key.tr();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAllLookups();
    });
  }

  void _loadAllLookups() {
    context.read<ReceivedFromBloc>().add(const LoadReceivedFrom());
    context.read<DeliveredToBloc>().add(const LoadDeliveredTo());
    context.read<ReportSourceBloc>().add(LoadReportSources());
    context.read<EmployeesBloc>().add(const LoadEmployees());
    context.read<CostCentersBloc>().add(LoadCostCenters());
    context.read<CurrenciesBloc>().add(LoadCurrencies());
    context.read<BranchesBloc>().add(LoadBranches());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VouchersBloc, VouchersState>(
      listener: (context, state) {
        if (state.status == Status.success && state.data != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ReceiptsAndPaymentsMovementReportResultsScreen(
                reportData: state.data!,
              ),
            ),
          );
        } else if (state.status == Status.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? tr("error_occurred")),
              backgroundColor: AppColors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.slateBg,
          appBar: GradientAppBar(
            title: "vouchers_movement".tr(),
            subtitle: "basic_filters".tr(),
            onBack: () => Navigator.of(context).maybePop(),
            accentIcon: Container(
              width: 34.w,
              height: 34.h,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.compare_arrows,
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
                        label: "from_date".tr(),
                        value: fromDate,
                        onChanged: (d) => setState(() => fromDate = d),
                      ),
                      SizedBox(width: 10.w),
                      DateFieldTile(
                        label: "to_date".tr(),
                        value: toDate,
                        onChanged: (d) => setState(() => toDate = d),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),

                  // ============================================================
                  // 📋 مستلم من & مسلم إلى
                  // ============================================================
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: BlocBuilder<ReceivedFromBloc, ReceivedFromState>(
                            builder: (context, state) {
                              String displayValue = "";
                              if (state.status == Status.success &&
                                  state.selectedItem != null) {
                                displayValue = state.selectedItem!;
                              } else if (state.status == Status.loading) {
                                displayValue = tr("loading");
                              }
                              return FilterFieldTile(
                                label: "received_from".tr(),
                                value: displayValue,
                                placeholder: tr("search"),
                                onTap: () => _showReceivedFromPicker(context),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 5.w),
                          child: BlocBuilder<DeliveredToBloc, DeliveredToState>(
                            builder: (context, state) {
                              String displayValue = "";
                              if (state.status == Status.success &&
                                  state.selectedItem != null) {
                                displayValue = state.selectedItem!;
                              } else if (state.status == Status.loading) {
                                displayValue = tr("loading");
                              }
                              return FilterFieldTile(
                                label: "delivered_to".tr(),
                                value: displayValue,
                                placeholder: tr("search"),
                                onTap: () => _showDeliveredToPicker(context),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ============================================================
                  // 📋 المندوب & مركز التكلفة
                  // ============================================================
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
                                label: "rep".tr(),
                                value: displayValue,
                                placeholder: tr("select_rep"),
                                onTap: () => _showEmployeePicker(context),
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
                                label: "cost_center".tr(),
                                value: displayValue,
                                placeholder: tr("select_cost_center"),
                                onTap: () => _showCostCenterPicker(context),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ============================================================
                  // 📋 العملة & سعر الصرف
                  // ============================================================
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
                                label: "currency".tr(),
                                value: displayValue,
                                placeholder: tr("select_currency"),
                                trailingIcon: Icons.keyboard_arrow_down,
                                onTap: () => _showCurrencyPicker(context),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 5.w),
                          child: FilterFieldTile(
                            label: "exchange_rate".tr(),
                            value: exchangeRate,
                            onTap: () {},
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ============================================================
                  // 📋 الفرع
                  // ============================================================
                  BlocBuilder<BranchesBloc, BranchesState>(
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
                        label: "branch".tr(),
                        value: displayValue,
                        placeholder: tr("select_branch"),
                        trailingIcon: Icons.keyboard_arrow_down,
                        onTap: () => _showBranchPicker(context),
                      );
                    },
                  ),
                  SizedBox(height: 14.h),

                  // ============================================================
                  // 📋 مصدر التقرير (DropDown تحت الفرع مباشرة)
                  // ============================================================
                  BlocBuilder<ReportSourceBloc, ReportSourceState>(
                    builder: (context, state) {
                      String displayValue = "";
                      if (state.status == Status.success &&
                          state.selectedItem != null) {
                        final selected = state.selectedReportSource;
                        if (selected != null) {
                          displayValue = context.locale.languageCode == 'ar'
                              ? selected.name
                              : selected.eName;
                        }
                      } else if (state.status == Status.loading) {
                        displayValue = tr("loading");
                      }

                      return FilterFieldTile(
                        label: "report_source".tr(),
                        value: displayValue,
                        placeholder: tr("select_report_source"),
                        trailingIcon: Icons.keyboard_arrow_down,
                        onTap: () => _showReportSourcePicker(context),
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
                      final result = await Navigator.of(context).push<Map<String, dynamic>>(
                        MaterialPageRoute(
                          builder: (_) => ReceiptsAndPaymentsMovementReportAdvancedFiltersScreen(
                            initialSelectedCount: 0,
                          ),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          showReceipts = result['showReceipts'] ?? false;
                          showPayments = result['showPayments'] ?? false;
                          showNetVoucher = result['showNetVoucher'] ?? false;
                          showPosted = result['showPosted'] ?? false;
                          showUnposted = result['showUnposted'] ?? false;
                          repByClient = result['repByClient'] ?? false;
                          sortIndex = result['sortIndex'] ?? 0;
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
                                  "advanced_filter".tr(),
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.brandDark,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  "advanced_filter_sub".tr(),
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
                          SizedBox(height: 4.h),
                          Text(
                            tr("please_wait"),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textMuted,
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
            primaryLabel: "view_report".tr(),
            secondaryLabel: "reset".tr(),
            onSecondary: () => setState(() {
              // ✅ كل الفلاتر ترجع فاضية
              showReceipts = false;
              showPayments = false;
              showNetVoucher = false;
              showPosted = false;
              showUnposted = false;
              repByClient = false;
              sortIndex = 0;
              selectedReceivedFrom = null;
              selectedDeliveredTo = null;
              selectedReportSource = null;
              selectedEmployee = null;
              selectedCostCenter = null;
              selectedCurrency = null;
              selectedBranch = null;
              exchangeRate = "1";

              context.read<ReceivedFromBloc>().add(const LoadReceivedFrom());
              context.read<DeliveredToBloc>().add(const LoadDeliveredTo());
              context.read<ReportSourceBloc>().add(LoadReportSources());
              context.read<EmployeesBloc>().add(const LoadEmployees());
              context.read<CostCentersBloc>().add(LoadCostCenters());
              context.read<CurrenciesBloc>().add(LoadCurrencies());
              context.read<BranchesBloc>().add(LoadBranches());
              context.read<VouchersBloc>().add(ClearVouchersReport());
            }),
            onPrimary: () {
              _applyFilters();
            },
          ),
        );
      },
    );
  }

  // ============================================================
  // ✅ Apply Filters
  // ============================================================
  void _applyFilters() {
    final receivedFromState = context.read<ReceivedFromBloc>().state;
    final deliveredToState = context.read<DeliveredToBloc>().state;
    final employeesState = context.read<EmployeesBloc>().state;
    final costCentersState = context.read<CostCentersBloc>().state;
    final branchesState = context.read<BranchesBloc>().state;
    final reportSourceState = context.read<ReportSourceBloc>().state;

    // ✅ 1. selectedEntries - مصدر التقرير المختار (قيمة واحدة)
    final List<EtMovementSelectedEntry> selectedEntries = [];

    // ✅ المستخدم اختار مصدر تقرير واحد
    if (reportSourceState.selectedItem != null) {
      selectedEntries.add(
        EtMovementSelectedEntry(
          id: reportSourceState.selectedItem!, // ✅ frmNum
          status: true,
        ),
      );
    }

    // ✅ 2. التواريخ - من الـ UI
    final dateFormat = DateFormat('yyyy-MM-dd');
    final startDate = dateFormat.format(fromDate);
    final endDate = dateFormat.format(toDate);

    // ✅ 3. باقي القيم - من الـ Blocs (null لو مفيش اختيار)
    final request = EtMovementReportRequestModel(
      request: EtMovementRequest(
        startDate: startDate,
        endDate: endDate,
        orderByCode: sortIndex == 1,
        isArabic: context.locale.languageCode == 'ar',
        costCenter:costCentersState.selectedCostCenter?.codeAndArabicName??null,
        employeeId: employeesState.selectedEmployeeId != null
            ? int.tryParse(employeesState.selectedEmployeeId!)
            : null,
        companyBranch: branchesState.selectedBranch?.braName,
        showPosted: showPosted,
        showNotPosted: showUnposted,
        showEntryNet: showNetVoucher,
        checksFilter: null,
        accountFilter: null,
        receivedFrom: receivedFromState.selectedItem,
        deliveredTo: deliveredToState.selectedItem,
        employeeAccordingToCustomer: repByClient,
        currencyRate: double.tryParse(exchangeRate) ?? 1.0,
      ),
      selectedEntries: selectedEntries,
    );



    context.read<VouchersBloc>().add(LoadVouchersReport(request: request));
  }

  // ============================================================
  // ✅ Pickers
  // ============================================================

  void _showReceivedFromPicker(BuildContext context) {
    final bloc = context.read<ReceivedFromBloc>();
    final state = bloc.state;

    showLookupPicker<ReceivedFromModel>(
      context: context,
      title: "received_from".tr(),
      items: state.items,
      isSelected: (item) => state.selectedItem == item.name,
      titleBuilder: (item) => item.name,
      onSelected: (item) => {
        bloc.add(SelectReceivedFrom(name: item.name)),
        setState(() {}),
      },
    );
  }

  void _showDeliveredToPicker(BuildContext context) {
    final bloc = context.read<DeliveredToBloc>();
    final state = bloc.state;

    showLookupPicker<DeliveredToModel>(
      context: context,
      title: "delivered_to".tr(),
      items: state.items,
      isSelected: (item) => state.selectedItem == item.name,
      titleBuilder: (item) => item.name,
      onSelected: (item) => {
        bloc.add(SelectDeliveredTo(name: item.name)),
        setState(() {}),
      },
    );
  }

  void _showReportSourcePicker(BuildContext context) {
    final bloc = context.read<ReportSourceBloc>();
    final state = bloc.state;

    showLookupPicker<ReportSourceModel>(
      context: context,
      title: "select_report_source".tr(),
      items: state.items,
      isSelected: (item) => state.selectedItem == item.frmNum,
      titleBuilder: (item) => context.locale.languageCode == 'ar'
          ? item.name
          : item.eName,
      subtitleBuilder: (item) => item.type.toString(),
      onSelected: (item) => {
        bloc.add(SelectReportSource(frmNum: item.frmNum)),
        setState(() {}),
      },
    );
  }

  void _showEmployeePicker(BuildContext context) {
    final bloc = context.read<EmployeesBloc>();
    final state = bloc.state;

    showLookupPicker<EmployeeModel>(
      context: context,
      title: "select_rep".tr(),
      items: state.employees,
      isSelected: (item) => state.selectedEmployeeId == item.empId,
      titleBuilder: (item) => item.empName,
      onSelected: (item) => {
        bloc.add(SelectEmployee(employeeId: item.empId)),
        setState(() {}),
      },
    );
  }

  void _showCostCenterPicker(BuildContext context) {
    final bloc = context.read<CostCentersBloc>();
    final state = bloc.state;

    showLookupPicker<CostCenterModel>(
      context: context,
      title: "select_cost_center".tr(),
      items: state.costCenters,
      isSelected: (item) => state.selectedCostCenterId == item.coID,
      titleBuilder: (item) => context.locale.languageCode == 'ar'
          ? item.codeAndArabicName
          : item.codeAndEnglishName,
      subtitleBuilder: (item) => item.coName,
      onSelected: (item) => {
        bloc.add(SelectCostCenter(costCenterId: item.coID)),
        setState(() {}),
      },
    );
  }

  void _showCurrencyPicker(BuildContext context) {
    final bloc = context.read<CurrenciesBloc>();
    final state = bloc.state;

    showLookupPicker<CurrencyModel>(
      context: context,
      title: "select_currency".tr(),
      items: state.currencies,
      isSelected: (item) => state.selectedCurrencyId == item.currencyID,
      titleBuilder: (item) => context.locale.languageCode == 'ar'
          ? item.currencyName
          : item.currencyEName,
      onSelected: (item) => {
        bloc.add(SelectCurrency(currencyId: item.currencyID)),
        setState(() {}),
      },
    );
  }

  void _showBranchPicker(BuildContext context) {
    final bloc = context.read<BranchesBloc>();
    final state = bloc.state;

    showLookupPicker<BranchModel>(
      context: context,
      title: "select_branch".tr(),
      items: state.branches,
      isSelected: (item) => state.selectedBranch == item.id,
      titleBuilder: (item) => context.locale.languageCode == 'ar'
          ? item.braName
          : item.braEName,
      subtitleBuilder: (item) => item.braCode,
      onSelected: (item) => {
        bloc.add(UpdateBranchesSelection.single(item.id)),
        setState(() {}),
      },
    );
  }
}