import 'package:easy_localization/easy_localization.dart';
import '../../../shared/widget/loading_overlay.dart';
import '../../branch_profit_import.dart';
import 'branch_profit_results_screen.dart';


class BranchProfitScreen extends StatelessWidget {
  const BranchProfitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BranchesBloc>(
          create: (_) => getIt<BranchesBloc>()..add(LoadBranches()),
        ),
        BlocProvider<BranchProfitBloc>(
          create: (_) => getIt<BranchProfitBloc>(),
        ),
      ],
      child: const BranchProfitFiltersScreen(),
    );
  }
}

class BranchProfitFiltersScreen extends StatefulWidget {
  const BranchProfitFiltersScreen({super.key});

  @override
  State<BranchProfitFiltersScreen> createState() =>
      _BranchProfitFiltersScreenState();
}

class _BranchProfitFiltersScreenState extends State<BranchProfitFiltersScreen> {
  late DateTime fromDate;
  late DateTime toDate;
  late DateTime dailyFrom;
  late DateTime dailyTo;

  bool byAccount = false; // true = على مستوى الحسابات, false = على مستوى مركز التكلفة


  bool orderByBranch = true; // true = حسب الفرع, false = حسب الشهور


  bool showExpenses = false;
  bool analysis = false;
  bool postedOnly = false;
  bool profitFromLastPrice = false;
  bool groupByBranch = false;
  bool dailySalesEnabled = false;
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    fromDate = DateTime(now.year, now.month, 1);
    toDate = now;

    // ✅ تهيئة التواريخ اليومية من الآن
    dailyFrom = DateTime(now.year, now.month, now.day);
    dailyTo = DateTime(now.year, now.month, now.day, 23, 59, 59);
  }

  void _applyFilters() {
    final branchState = context.read<BranchesBloc>().state;

    if (branchState.selectedBranchIds.isEmpty) {
      context.showErrorMessage('please_select_branches'.tr());
      return;
    }

    // ✅ استخدام القيم المختارة من المستخدم، وليس حسابها تلقائياً
    final request = BranchProfitRequestModel.create(
      fromDate: fromDate,
      toDate: toDate,
      dailyFrom: dailySalesEnabled ? dailyFrom : null, // ✅ استخدام dailyFrom المختار من المستخدم
      dailyTo: dailySalesEnabled ? dailyTo : null,     // ✅ استخدام dailyTo المختار من المستخدم
      branchIDs: branchState.selectedBranchIds.toList(),
      byAccount: byAccount,
      showExpenses: showExpenses,
      analysis: analysis,
      postedOnly: postedOnly,
      profitFromLastPrice: profitFromLastPrice,
      orderByBranch: orderByBranch,
      groupByBranch: groupByBranch,
    );

    context.read<BranchProfitBloc>().add(
      LoadBranchProfitReport(request: request),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BranchProfitBloc, BaseState<BranchProfitResponseModel>>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == Status.failure) {
          context.showErrorMessage(
            state.errorMessage ?? 'error_loading_report'.tr(),
          );
          return;
        }
        if (state.status == Status.success) {
          if (state.data == null) {
            context.showErrorMessage('no_data_found'.tr());
            return;
          }
          if (state.data!.rows.isEmpty && state.data!.analysisRows.isEmpty) {
            context.showErrorMessage('no_data_found'.tr());
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BranchProfitResultsScreen(
                data: state.data!,
                fromDate: fromDate,
                toDate: toDate,
              ),
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
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildBody(),
          if (isLoading) ReportsLoadingOverlay(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(isLoading),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return GradientAppBar(
      title: 'home.branch_profit'.tr(),
      subtitle: 'home.branch_profit_subtitle'.tr(),
      onBack: () => Navigator.of(context).maybePop(),
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

        DateRangeSection(
          fromDate: fromDate,
          toDate: toDate,
          onFromDateChanged: (date) => setState(() => fromDate = date),
          onToDateChanged: (date) => setState(() => toDate = date),
        ),

        SizedBox(height: 8.h),

        BranchSelectionSection(),
        SizedBox(height: 8.h),


        DisplayLevelSection(
          byAccount: byAccount,
          onChanged: (value) => setState(() => byAccount = value),
        ),
        SizedBox(height: 8.h),


        OrderBySection(
          orderByBranch: orderByBranch,
          onChanged: (value) => setState(() => orderByBranch = value),
        ),
        SizedBox(height: 8.h),



                DailySalesSection(
                  isEnabled: dailySalesEnabled,
                  dailyFrom: dailyFrom,
                  dailyTo: dailyTo,
                  onEnabledChanged: (value) => setState(() => dailySalesEnabled = value),
                  onDailyFromChanged: (date) => setState(() => dailyFrom = date),
                  onDailyToChanged: (date) => setState(() => dailyTo = date),
                ),
        SizedBox(height: 8.h),
        OptionsSection(
          options: BranchProfitOptions(
            byAccount: byAccount,
            showExpenses: showExpenses,
            analysis: analysis,
            postedOnly: postedOnly,
            profitFromLastPrice: profitFromLastPrice,
            orderByBranch: orderByBranch,
            groupByBranch: groupByBranch,
          ),
          onChanged: (newOptions) => setState(() {
            // لاحظ: byAccount و orderByBranch يتم التحكم بهما من DisplayOptionsSection
            //所以我们 لا نحدثهما هنا
            showExpenses = newOptions.showExpenses;
            analysis = newOptions.analysis;
            postedOnly = newOptions.postedOnly;
            profitFromLastPrice = newOptions.profitFromLastPrice;
            groupByBranch = newOptions.groupByBranch;
          }),
        ),

        SizedBox(height: 25.h),
      ],
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
        isLoading ? 'loading'.tr() : 'view_report'.tr(),
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}