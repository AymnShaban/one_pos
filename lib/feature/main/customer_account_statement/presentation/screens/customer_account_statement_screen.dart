import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/extension/context_extension.dart';
import '../../../../../core/services/service_locator/services_imports.dart';
import '../../../../../core/widgets/filter_field.dart';
import '../../customer_account_imports.dart';
import '../../data/models/report_source_request_model.dart';
import '../manager/customer_account_bloc/customer_account_event.dart';
import 'customer_account_statement_details_screen.dart';

import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/extension/context_extension.dart';
import '../../../../../core/services/service_locator/services_imports.dart';
import '../../../../../core/widgets/filter_field.dart';
import '../../customer_account_imports.dart';
import '../../data/models/report_source_request_model.dart';
import '../manager/customer_account_bloc/customer_account_event.dart';
import 'customer_account_statement_details_screen.dart';

class ClientStatementScreen extends StatelessWidget {
  const ClientStatementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MainAccountsBloc>(
          create: (_) => getIt<MainAccountsBloc>()..add(LoadMainAccounts()),
        ),
        BlocProvider<CustomerSupplierBloc>(
          create: (_) => getIt<CustomerSupplierBloc>()
            ..add(LoadCustomerSuppliers()),
        ),
        BlocProvider<CustomerStatementReportBloc>(
          create: (_) => getIt<CustomerStatementReportBloc>(),
        ),
        BlocProvider<CustomerAccountReportSourceBloc>(
          create: (_) => getIt<CustomerAccountReportSourceBloc>()..add(LoadCustomerAccountReportSources()),
        ),
      ],
      child: const ClientStatementFiltersScreen(),
    );
  }
}

class ClientStatementFiltersScreen extends StatefulWidget {
  const ClientStatementFiltersScreen({super.key});

  @override
  State<ClientStatementFiltersScreen> createState() =>
      _ClientStatementFiltersScreenState();
}

class _ClientStatementFiltersScreenState
    extends State<ClientStatementFiltersScreen> {
  late DateTime fromDate;
  late DateTime toDate;

  MainAccountModel? selectedMainAccount;
  CustomerSupplierModel? selectedFromCustomer;
  CustomerSupplierModel? selectedToCustomer;

  List<MainAccountModel> mainAccounts = [];
  List<CustomerSupplierModel> customers = [];

  bool _isReportSourcesExpanded = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    fromDate = DateTime(now.year, now.month, 1);
    toDate = now;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    context.read<MainAccountsBloc>().add(LoadMainAccounts());
    context.read<CustomerSupplierBloc>().add(LoadCustomerSuppliers());
  }

  void _clearMainAccount() {
    setState(() => selectedMainAccount = null);
  }

  void _clearFromCustomer() {
    setState(() => selectedFromCustomer = null);
  }

  void _clearToCustomer() {
    setState(() => selectedToCustomer = null);
  }

  void _applyFilters() {
    if (selectedFromCustomer == null || selectedToCustomer == null) {
      context.showErrorMessage('please_select_customer'.tr());
      return;
    }

    // Get selected report sources from bloc and convert to ReportSourceModel
    final sourceState = context.read<CustomerAccountReportSourceBloc>().state;
    final selectedSources = sourceState.items
        .where((item) => sourceState.selectedItems.contains(item.value))
        .map((item) => ReportSourceModel(
      value: item.value,
      text: item.text,
      checked: true,
    ))
        .toList();

    final request = CustomerStatementRequestModel.create(
      fromAccountId: selectedFromCustomer!.acId.toString(),
      toAccountId: selectedToCustomer!.acId.toString(),
      fromDate: fromDate,
      toDate: toDate,
      mainAccountId: selectedMainAccount?.acId.toString(),
      currencyId: '1',
      cultureName: 'ar',
      reportSources: selectedSources.isNotEmpty ? selectedSources : null,
    );

    context.read<CustomerStatementReportBloc>().add(
      LoadCustomerStatementReport(request: request),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
        CustomerStatementReportBloc,
        BaseState<List<CustomerAccountStatementResponseModel>>
    >(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == Status.failure) {
          context.showErrorMessage(
            state.errorMessage ?? 'error_loading_statement'.tr(),
          );
          return;
        }

        if (state.status != Status.success) {
          return;
        }

        final data = state.data;

        if (data == null || data.isEmpty) {
          context.showErrorMessage('no_data_found'.tr());
          return;
        }

        final firstItem = data.first;

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ClientStatementResultsScreen(
              statementData: firstItem,
              fromDate: fromDate,
              toDate: toDate,
              clientName: firstItem.acName ?? 'Client',
            ),
          ),
        );
      },
      builder: (context, state) {
        final isLoading = state.status == Status.loading;
        return _buildScaffold(isLoading);
      },
    );
  }

  Widget _buildScaffold(bool isLoading) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildBody(),
          if (isLoading) _buildLoadingOverlay(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(isLoading),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return GradientAppBar(
      title: "client_statement".tr(),
      subtitle: "select_accounts_and_period".tr(),
      accentIcon: Container(
        width: 34.w,
        height: 34.h,
        decoration: BoxDecoration(
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(
          Icons.account_balance_wallet,
          color: AppColors.white,
          size: 16.sp,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      children: [
        _buildSectionLabel('period'.tr()),
        Row(
          children: [
            _buildDateField(
              label: 'from'.tr(),
              date: fromDate,
              onChanged: (date) => setState(() => fromDate = date),
            ),
            SizedBox(width: 10.w),
            _buildDateField(
              label: 'to'.tr(),
              date: toDate,
              onChanged: (date) => setState(() => toDate = date),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        _buildSectionLabel('main_account'.tr()),
        BlocBuilder<MainAccountsBloc, BaseState<List<MainAccountModel>>>(
          builder: (context, state) {
            if (state.status == Status.loading) {
              return _buildLoadingField();
            }
            if (state.status == Status.failure) {
              return _buildErrorField(
                message: state.errorMessage ?? 'error_loading_accounts'.tr(),
                onRetry: () => context.read<MainAccountsBloc>().add(LoadMainAccounts()),
              );
            }

            mainAccounts = state.data ?? [];
            final accountNames = mainAccounts.map((e) => e.displayName).toList();

            return FilterField(
              label: 'main_account'.tr(),
              value: selectedMainAccount?.displayName,
              placeholder: 'select_main_account'.tr(),
              isSelected: selectedMainAccount != null,
              icon: Icons.account_balance,
              options: accountNames,
              enableSearch: true,
              searchHint: 'search_accounts'.tr(),
              onChanged: (value) {
                if (value != null) {
                  final selected = mainAccounts.firstWhere(
                        (account) => account.displayName == value,
                    orElse: () => MainAccountModel(),
                  );
                  setState(() => selectedMainAccount = selected);
                }
              },
              onClear: selectedMainAccount != null ? _clearMainAccount : null,
            );
          },
        ),
        SizedBox(height: 16.h),

        _buildSectionLabel('customer_range'.tr()),
        BlocBuilder<CustomerSupplierBloc, BaseState<List<CustomerSupplierModel>>>(
          builder: (context, state) {
            if (state.status == Status.loading) {
              return Row(
                children: [
                  Expanded(child: _buildLoadingField()),
                  SizedBox(width: 8.w),
                  Expanded(child: _buildLoadingField()),
                ],
              );
            }
            if (state.status == Status.failure) {
              return _buildErrorField(
                message: state.errorMessage ?? 'error_loading_customers'.tr(),
                onRetry: () => context.read<CustomerSupplierBloc>().add(LoadCustomerSuppliers()),
              );
            }

            customers = state.data ?? [];
            final customerNames = customers.map((e) => e.displayName).toList();

            return Row(
              children: [
                Expanded(
                  child: FilterField(
                    label: 'from_customer'.tr(),
                    value: selectedFromCustomer?.displayName,
                    placeholder: 'select_from_customer'.tr(),
                    isSelected: selectedFromCustomer != null,
                    icon: Icons.arrow_forward,
                    isCompact: true,
                    options: customerNames,
                    enableSearch: true,
                    searchHint: 'search_customers'.tr(),
                    onChanged: (value) {
                      if (value != null) {
                        final selected = customers.firstWhere(
                              (customer) => customer.displayName == value,
                          orElse: () => CustomerSupplierModel(),
                        );
                        setState(() => selectedFromCustomer = selected);
                      }
                    },
                    onClear: selectedFromCustomer != null ? _clearFromCustomer : null,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: FilterField(
                    label: 'to_customer'.tr(),
                    value: selectedToCustomer?.displayName,
                    placeholder: 'select_to_customer'.tr(),
                    isSelected: selectedToCustomer != null,
                    icon: Icons.arrow_back,
                    isCompact: true,
                    options: customerNames,
                    enableSearch: true,
                    searchHint: 'search_customers'.tr(),
                    onChanged: (value) {
                      if (value != null) {
                        final selected = customers.firstWhere(
                              (customer) => customer.displayName == value,
                          orElse: () => CustomerSupplierModel(),
                        );
                        setState(() => selectedToCustomer = selected);
                      }
                    },
                    onClear: selectedToCustomer != null ? _clearToCustomer : null,
                  ),
                ),
              ],
            );
          },
        ),
        SizedBox(height: 16.h),

        _buildReportSourcesField(),

        if (selectedFromCustomer != null && selectedToCustomer != null)
          _buildSummaryInfo(),
      ],
    );
  }

  Widget _buildReportSourcesField() {
    return BlocBuilder<
        CustomerAccountReportSourceBloc,
        CustomerAccountReportSourceState>(
      builder: (context, state) {
        if (state.status == Status.loading) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionLabel('report_sources'.tr()),
              _buildLoadingField(),
              SizedBox(height: 16.h),
            ],
          );
        }

        if (state.status == Status.failure) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionLabel('report_sources'.tr()),
              _buildErrorField(
                message: state.errorMessage ??
                    'error_loading_report_sources'.tr(),
                onRetry: () {
                  context
                      .read<CustomerAccountReportSourceBloc>()
                      .add(
                    LoadCustomerAccountReportSources(),
                  );
                },
              ),
              SizedBox(height: 16.h),
            ],
          );
        }

        final sources = state.items;
        final selectedItems = sources
            .where((e) => state.selectedItems.contains(e.value))
            .toList();

        // Convert to ReportSourceModel for the multi select field
        final reportSourceItems = sources.map((e) => ReportSourceModel(
          value: e.value,
          text: e.text,
          checked: state.selectedItems.contains(e.value),
        )).toList();

        final selectedReportItems = selectedItems.map((e) => ReportSourceModel(
          value: e.value,
          text: e.text,
          checked: true,
        )).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel('report_sources'.tr()),
            _buildMultiSelectField(
              label: 'sources'.tr(),
              selectedItems: selectedReportItems,
              allItems: reportSourceItems,
              placeholder: 'select_sources'.tr(),
              icon: Icons.source,
              options: sources.map((e) => e.text).toList(),
              onChanged: (selectedValues) {
                final bloc = context
                    .read<CustomerAccountReportSourceBloc>();

                // Clear all selections first
                bloc.add(ClearCustomerAccountReportSources());

                // Then select each chosen value
                for (final source in sources) {
                  if (selectedValues.contains(source.text)) {
                    bloc.add(
                      SelectCustomerAccountReportSource(
                        value: source.value,
                      ),
                    );
                  }
                }
              },
              onClear: state.selectedItems.isNotEmpty
                  ? () {
                context
                    .read<CustomerAccountReportSourceBloc>()
                    .add(
                  ClearCustomerAccountReportSources(),
                );
              }
                  : null,
            ),
            SizedBox(height: 16.h),
          ],
        );
      },
    );
  }

  Widget _buildLoadingField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.blue,
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            'loading'.tr(),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorField({
    required String message,
    required VoidCallback onRetry,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.red),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.red,
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.red,
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(
              'retry'.tr(),
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required Function(DateTime) onChanged,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          InkWell(
            onTap: () async {
              final picked = await AppDatePicker.show(
                context: context,
                initialDate: date,
              );
              if (picked != null) onChanged(picked);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: AppColors.line),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: AppColors.blue,
                    size: 16.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      DateFormat('dd/MM/yyyy').format(date),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryInfo() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.blue, AppColors.blue.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withOpacity(0.2),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryChip(
            label: 'from'.tr(),
            value: selectedFromCustomer?.displayName ?? '',
            icon: Icons.arrow_forward,
          ),
          _buildSummaryChip(
            label: 'to'.tr(),
            value: selectedToCustomer?.displayName ?? '',
            icon: Icons.arrow_back,
          ),
          _buildSummaryChip(
            label: 'period'.tr(),
            value: '${DateFormat('dd/MM').format(fromDate)} - ${DateFormat('dd/MM').format(toDate)}',
            icon: Icons.calendar_today,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryChip({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: AppColors.white.withOpacity(0.6),
                size: 12.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: AppColors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(bool isLoading) {
    return FloatingActionButton.extended(
      onPressed: isLoading ? null : _applyFilters,
      backgroundColor: isLoading ? AppColors.textMuted : AppColors.blue,
      foregroundColor: AppColors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      icon: isLoading
          ? SizedBox(
        height: 20.h,
        width: 20.w,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.white,
        ),
      )
          : Icon(
        Icons.visibility,
        size: 20.sp,
      ),
      label: Text(
        isLoading ? 'loading'.tr() : 'view_statement'.tr(),
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: AppColors.blue,
              ),
              SizedBox(height: 16.h),
              Text(
                'loading_statement'.tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMultiSelectField({
    required String label,
    required List<ReportSourceModel> selectedItems,
    required List<ReportSourceModel> allItems,
    required String placeholder,
    required IconData icon,
    required List<String> options,
    required Function(List<String>) onChanged,
    VoidCallback? onClear,
  }) {
    final selectedNames = selectedItems.map((e) => e.text).toList();
    final isAllSelected = options.isNotEmpty && selectedNames.length == options.length;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 12.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.line,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.blue,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  selectedNames.isEmpty
                      ? placeholder
                      : '${selectedNames.length} ${'selected'.tr()}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: selectedNames.isEmpty
                        ? AppColors.textMuted
                        : AppColors.textDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Select All checkbox
              InkWell(
                onTap: () {
                  if (isAllSelected) {
                    onChanged([]);
                  } else {
                    onChanged(List<String>.from(options));
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      isAllSelected
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: AppColors.blue,
                      size: 20.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'select_all'.tr(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              // Expand/Collapse arrow
              IconButton(
                icon: Icon(
                  _isReportSourcesExpanded ? Icons.expand_less : Icons.expand_more,
                  color: AppColors.textMuted,
                  size: 24.sp,
                ),
                onPressed: () {
                  setState(() {
                    _isReportSourcesExpanded = !_isReportSourcesExpanded;
                  });
                },
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(
                  minWidth: 28.w,
                  minHeight: 28.h,
                ),
              ),
              if (onClear != null)
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: AppColors.textMuted,
                    size: 18.sp,
                  ),
                  onPressed: onClear,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(
                    minWidth: 28.w,
                    minHeight: 28.h,
                  ),
                ),
            ],
          ),

          if (_isReportSourcesExpanded && options.isNotEmpty) ...[
            SizedBox(height: 12.h),

            // List of items with checkboxes
            ...options.map((option) {
              final isSelected = selectedNames.contains(option);

              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: InkWell(
                  onTap: () {
                    final newSelected = List<String>.from(selectedNames);
                    if (isSelected) {
                      newSelected.remove(option);
                    } else {
                      newSelected.add(option);
                    }
                    onChanged(newSelected);
                  },
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: isSelected ? AppColors.blue : AppColors.textMuted,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        option,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: isSelected ? AppColors.blue : AppColors.textDark,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}