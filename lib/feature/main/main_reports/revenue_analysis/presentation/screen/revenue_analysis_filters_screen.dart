import 'package:easy_localization/easy_localization.dart';

import '../../../../../../core/extension/context_extension.dart';
import '../../../../../../core/services/service_locator/services_imports.dart';
import '../../../../../../core/widgets/filter_field.dart';
import '../../../shared/widget/loading_overlay.dart';
import '../../revenue_analysis_import.dart';

class RevenueAnalysisScreen extends StatelessWidget {
  const RevenueAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RevenueAccountsBloc>(
          create: (_) => getIt<RevenueAccountsBloc>(),
        ),
        BlocProvider<RevenueReportBloc>(
          create: (_) => getIt<RevenueReportBloc>(),
        ),
      ],
      child: const RevenueAnalysisFiltersScreen(),
    );
  }
}

class RevenueAnalysisFiltersScreen extends StatefulWidget {
  const RevenueAnalysisFiltersScreen({super.key});

  @override
  State<RevenueAnalysisFiltersScreen> createState() =>
      _RevenueAnalysisFiltersScreenState();
}

class _RevenueAnalysisFiltersScreenState
    extends State<RevenueAnalysisFiltersScreen> {
  late DateTime fromDate;
  late DateTime toDate;

  PeriodType periodType = PeriodType.monthly;
  int? selectedAccountId;

  bool showColumnValues = true;
  bool detailedCostCenters = true;
  bool detailedComparison = true;

  List<RevenueAccountModel> accounts = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    fromDate = DateTime(now.year, 1, 1);
    toDate = now;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAccounts();
    });
  }

  void _loadAccounts() {
    context.read<RevenueAccountsBloc>().add(const LoadRevenueAccounts());
  }

  void _resetFilters() {
    setState(() {
      final now = DateTime.now();
      fromDate = DateTime(now.year, 1, 1);
      toDate = now;
      periodType = PeriodType.monthly;
      showColumnValues = true;
      detailedCostCenters = true;
      detailedComparison = true;
      selectedAccountId = null;
    });
    context.read<RevenueReportBloc>().add(ClearRevenueReport());
  }

  void _applyFilters() {
    if (selectedAccountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('please_select_account'.tr()),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    final request = RevenueReportRequestModel(
      mainAcID: selectedAccountId!,
      startDate: fromDate,
      endDate: toDate,
      showDetailedCostCenter: detailedCostCenters,
      coType: periodType.coType,
      coEType: periodType.coEType,
    );

    context.read<RevenueReportBloc>().add(
      LoadRevenueReport(request: request),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RevenueReportBloc, RevenueReportState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == Status.success && state.reportData != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => RevenueAnalysisResultsScreen(
                reportData: state.reportData!,
              ),
            ),
          );
        } else if (state.status == Status.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'error_loading_report'.tr()),
              backgroundColor: AppColors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == Status.loading;
        return _buildScaffold(isLoading);
      },
    );
  }

  Widget _buildScaffold(bool isLoading) {
    return Scaffold(
      backgroundColor: AppColors.slateBg,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildBody(),
          if (isLoading) const ReportsLoadingOverlay(),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(isLoading),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return GradientAppBar(
      title: "revenue_analysis".tr(),
      subtitle: "report_options".tr(),
      onBack: () => Navigator.of(context).maybePop(),
      accentIcon: Container(
        width: 34.w,
        height: 34.h,
        decoration: BoxDecoration(
          color: AppColors.teal,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(Icons.show_chart, color: Colors.white, size: 16.sp),
      ),
    );
  }

  Widget _buildBody() {
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 10.h),
      children: [
        _buildAccountSection(),
        SizedBox(height: 16.h),
        _buildDateRangeSection(),
        SizedBox(height: 16.h),
        _buildPeriodTypeSection(),
        SizedBox(height: 16.h),
        _buildDisplayOptionsSection(),
      ],
    );
  }

  Widget _buildAccountSection() {
    return BlocBuilder<RevenueAccountsBloc, RevenueAccountsState>(
      builder: (context, state) {
        if (state.status == Status.loading) {
          return _buildLoadingField();
        }
        if (state.status == Status.failure) {
          return _buildErrorField(
            message: state.errorMessage ?? 'error_loading_accounts'.tr(),
            onRetry: _loadAccounts,
          );
        }

        accounts = state.accounts;
        final accountNames = accounts.map((e) => e.name).toList();
        final selectedAccount = accounts.firstWhere(
              (account) => account.id == selectedAccountId,
          orElse: () => RevenueAccountModel(id: 0, name: '', code: ''),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'select_account'.tr(),
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: 8.h),
            FilterField(
              label: 'account'.tr(),
              value: selectedAccount.id != 0 ? selectedAccount.name : null,
              placeholder: 'select_account'.tr(),
              isSelected: selectedAccountId != null,
              icon: Icons.account_balance,
              options: accountNames,
              enableSearch: true,
              searchHint: 'search_accounts'.tr(),
              onChanged: (value) {
                if (value != null) {
                  final selected = accounts.firstWhere(
                        (account) => account.name == value,
                    orElse: () => RevenueAccountModel(id: 0, name: '', code: ''),
                  );
                  setState(() => selectedAccountId = selected.id);
                }
              },
              onClear: () => setState(() => selectedAccountId = null),
            ),
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

  Widget _buildDateRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'period'.tr(),
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                label: 'from'.tr(),
                date: fromDate,
                onChanged: (date) => setState(() => fromDate = date),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _buildDateField(
                label: 'to'.tr(),
                date: toDate,
                onChanged: (date) => setState(() => toDate = date),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required Function(DateTime) onChanged,
  }) {
    return Column(
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
            final picked = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
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
    );
  }

  Widget _buildPeriodTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'period_type'.tr(),
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.line),
          ),
          child: Wrap(
            spacing: 8.w,
            children: PeriodType.values.map((type) {
              final isSelected = periodType == type;
              return ChoiceChip(
                label: Text(
                  type.name.tr(),
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: isSelected ? AppColors.white : AppColors.textDark,
                  ),
                ),
                selected: isSelected,
                onSelected: (_) => setState(() => periodType = type),
                selectedColor: AppColors.blue,
                backgroundColor: AppColors.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  side: BorderSide(
                    color: isSelected ? AppColors.blue : AppColors.line,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDisplayOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'display_options'.tr(),
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.line),
          ),
          child: Column(
            children: [
              _buildSwitchTile(
                title: 'show_column_values'.tr(),
                value: showColumnValues,
                onChanged: (value) => setState(() => showColumnValues = value),
              ),
              _buildSwitchTile(
                title: 'detailed_cost_centers'.tr(),
                value: detailedCostCenters,
                onChanged: (value) => setState(() => detailedCostCenters = value),
              ),
              _buildSwitchTile(
                title: 'detailed_comparison'.tr(),
                value: detailedComparison,
                onChanged: (value) => setState(() => detailedComparison = value),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textDark,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.blue,
            activeTrackColor: AppColors.blue.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(bool isLoading) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, -4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: isLoading ? null : _resetFilters,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                side: BorderSide(color: AppColors.textMuted),
              ),
              child: Text(
                'reset'.tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: isLoading ? null : _applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue,
                foregroundColor: AppColors.white,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: isLoading
                  ? SizedBox(
                height: 20.h,
                width: 20.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              )
                  : Text(
                'view_report'.tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}