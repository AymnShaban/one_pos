part of '../../home_imports.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  Future<void> _onRefresh(BuildContext context) async {
    context.read<HomeBloc>().add(
      const InitHome(),
    );

    context.read<TopSellingBloc>().add(
      const LoadTopSellingItems(),
    );

    context.read<LowStockBloc>().add(
      const LoadLowStockItems(),
    );

    context.read<DailyOperationsBloc>().add(
      const LoadDailyOperations(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReportsVisibilityBloc(),
      child: Scaffold(
        backgroundColor: const Color(0xffF0F2F8),
        body: CustomRefreshIndicator(
          onRefresh: () => _onRefresh(context),
          trigger: IndicatorTrigger.leadingEdge,
          builder: (
              BuildContext context,
              Widget child,
              IndicatorController controller,
              ) {
            return Stack(
              children: [
                child,

                if (controller.value > 0)
                  Positioned(
                    top: 60.h,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: BouncingBallRefreshIndicator(
                        progress: controller.value.clamp(
                          0.0,
                          1.0,
                        ),
                        isRefreshing: controller.isLoading,
                      ),
                    ),
                  ),
              ],
            );
          },
          child: const _HomeScrollView(),
        ),
      ),
    );
  }
}
class _HomeScrollView extends StatelessWidget {
  const _HomeScrollView();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [


        const SliverToBoxAdapter(
          child: _HomeHeaderSection(),
        ),


        const ReportsSection(),



        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            16.w,
            16.h,
            16.w,
            8.h,
          ),
          sliver: const SliverToBoxAdapter(
            child: TopSellingWidget(),
          ),
        ),



        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            16.w,
            0,
            16.w,
            8.h,
          ),
          sliver: const SliverToBoxAdapter(
            child: LowStockWidget(),
          ),
        ),



        const SliverToBoxAdapter(
          child: DailyOperationList(),
        ),



        const SliverToBoxAdapter(
          child: _ChartsSection(),
        ),


        SliverToBoxAdapter(
          child: SizedBox(
            height: 24.h,
          ),
        ),
      ],
    );
  }
}
List<Widget> _reportCards(BuildContext context) {
  // Tap actions either flip the bottom-nav tab, push a real screen, or
  // land on the shared UnderConstructionScreen for features that
  // aren't built yet.
  void underConstruction(IconData icon, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UnderConstructionScreen(
          title: title,
          icon: icon,
          showAppBar: true,
        ),
      ),
    );
  }

  return [
    _ReportCard(
      title: 'home.live_sales'.tr(),
      subtitle: 'home.live_sales_subtitle'.tr(),
      icon: AppAssets.liveSalesIcon,
      color: const Color(0xffE74C3C),
      highlight: true,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const LiveSalesReportScreen(),
        ),
      ),
    ),

    _ReportCard(
      title: 'home.branch_profit'.tr(),
      subtitle: 'home.branch_profit_subtitle'.tr(),
      icon: AppAssets.netProfitsIcon,
      color: const Color(0xffF5A623),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const BranchProfitScreen(),
          ),
        );
      },
    ),

    _ReportCard(
      title: 'home.invoice_profit'.tr(),
      subtitle: 'home.invoice_profit_subtitle'.tr(),
      icon: AppAssets.invoiceProfitsIcon,
      color: const Color(0xff9B59B6),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [

                BlocProvider<ParentAccountsBloc>(
                  create: (_) => getIt<ParentAccountsBloc>(),
                ),
                BlocProvider<CustomersBloc>(
                  create: (_) => getIt<CustomersBloc>(),
                ),
                BlocProvider<EmployeesBloc>(
                  create: (_) => getIt<EmployeesBloc>(),
                ),
                BlocProvider<CostCentersBloc>(
                  create: (_) => getIt<CostCentersBloc>(),
                ),
                BlocProvider<CurrenciesBloc>(
                  create: (_) => getIt<CurrenciesBloc>(),
                ),
                BlocProvider<UsersBloc>(
                  create: (_) => getIt<UsersBloc>(),
                ),
                BlocProvider(
                  create: (_) => BranchesBloc(
                    dataSource: getIt<BranchesDataSource>(),
                  ),
                ),
                BlocProvider<PayWaysBloc>(
                  create: (_) => getIt<PayWaysBloc>(),
                ),
                BlocProvider<BillSourcesBloc>(
                  create: (_) => getIt<BillSourcesBloc>(),
                ),
                BlocProvider<InvoiceProfitBloc>(
                  create: (_) => getIt<InvoiceProfitBloc>(),
                ),
              ],
              child: const InvoiceProfitBasicFiltersScreen(),
            ),
          ),
        );
      },
    ),

    _ReportCard(
      title: 'home.invoice_items_profit'.tr(),
      subtitle: 'home.invoice_items_profit_subtitle'.tr(),
      icon: AppAssets.invoiceItemsProfitsIcon,
      color: const Color(0xff3B82F6),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ItemProfitScreen(),
          ),
        );
      },
    ),

    _ReportCard(
      title: 'home.revenue_analysis'.tr(),
      subtitle: 'home.revenue_analysis_subtitle'.tr(),
      icon: AppAssets.revenueAnalysisIcon,
      color: const Color(0xff14B8A6),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RevenueAnalysisScreen(),
          ),
        );
      },
    ),

    _ReportCard(
      title: 'home.expenses_analysis'.tr(),
      subtitle: 'home.expenses_analysis_subtitle'.tr(),
      icon: AppAssets.expensesAnalysisIcon,
      color: const Color(0xffF43F5E),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ExpenseAnalysisScreen(), // ✅ بسيط جدًا
          ),
        );
      },
    ),

    _ReportCard(
        title: 'home.items_movement'.tr(),
        subtitle: 'home.items_movement_subtitle'.tr(),
        icon: AppAssets.itemsMovementIcon,
        color: const Color(0xffF59E0B),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return ItemMovementScreen();

          }));

        }
      //    context.read<NavBloc>().add(const ChangeNavTab(3)),
    ),

    _ReportCard(
      title: 'home.vouchers_movement'.tr(),
      subtitle: 'home.vouchers_movement_subtitle'.tr(),
      icon: AppAssets.vouchersMovementIcon,
      color: const Color(0xff3B82F6),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [

                BlocProvider<ReceivedFromBloc>(
                  create: (_) => getIt<ReceivedFromBloc>(),
                ),

                BlocProvider<DeliveredToBloc>(
                  create: (_) => getIt<DeliveredToBloc>(),
                ),

                BlocProvider<ReportSourceBloc>(
                  create: (_) => getIt<ReportSourceBloc>(),
                ),

                BlocProvider<EmployeesBloc>(
                  create: (_) => getIt<EmployeesBloc>(),
                ),
                // ✅ Cost Centers
                BlocProvider<CostCentersBloc>(
                  create: (_) => getIt<CostCentersBloc>(),
                ),

                BlocProvider<CurrenciesBloc>(
                  create: (_) => getIt<CurrenciesBloc>(),
                ),

                BlocProvider<BranchesBloc>(
                  create: (_) => getIt<BranchesBloc>(),
                ),
                BlocProvider<VouchersBloc>(
                  create: (_) => getIt<VouchersBloc>(),
                ),
              ],
              child: const VouchersBasicFiltersScreen(),
            ),
          ),
        );
      },
    ),
    _ReportCard(
        title: 'home.items_inventory'.tr(),
        subtitle: 'home.items_inventory_subtitle'.tr(),
        icon: AppAssets.itemsInventoryIcon,
        color: const Color(0xff10B981),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider<InvoiceCubit>(
                create: (_) => getIt<InvoiceCubit>(),
                child: const BarrenStockTakingScreen(),
              ),
            ),
          );



        }
      // context.read<NavBloc>().add(const ChangeNavTab(4)),
    ),
    _ReportCard(
      title: 'home.items_balance_report'.tr(),
      subtitle: 'home.items_balance_report_subtitle'.tr(),
      icon: AppAssets.itemsBalanceReportIcon,
      color: const Color(0xff6366F1),
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) => BlocProvider(
        //       create: (_) => getIt<ReportsBloc>()
        //         ..add(const ChangeReportType(ReportType.itemsReport))
        //         ..add(const FetchReport()),
        //       child: const ItemsBalanceReportScreen(),
        //     ),
        //   ),
        // );

        Navigator.push(context, MaterialPageRoute(builder: (context){

          return
            ItemMovementBalanceScreen();
        }));
      },
    ),
  ];
}
class _HomeHeaderSection extends StatelessWidget {
  const _HomeHeaderSection();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
        HomeBloc,
        BaseState<HomeStatsModel>,
        HomeStatsModel>(
      selector: (state) {
        if (state.items.isEmpty) {
          return const HomeStatsModel();
        }

        return state.items.first;
      },
      builder: (context, stats) {
        return _HomeHeader(
          stats: stats,
        );
      },
    );
  }
}
class _HomeHeader extends StatelessWidget {
  final HomeStatsModel stats;

  const _HomeHeader({
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            AppAssets.backgroundImage,
          ),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12.h,
        left: 16.w,
        right: 16.w,
        bottom: 8.h,
      ),
      child: Column(
        children: [
          SizedBox(height: 80.h),

          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'home.sales_total'.tr(),
                  value: stats.totalRevenue,
                  unit: 'home.riyal_sa'.tr(),
                  percentage: stats.revenuePercentage,
                  icon: Icons.attach_money_rounded,
                  accent: const Color(0xff40C057),
                ),
              ),

              SizedBox(width: 2),

              Expanded(
                child: _StatCard(
                  label: 'home.costs'.tr(),
                  value: stats.totalExpenses,
                  unit: 'home.riyal_sa'.tr(),
                  percentage: stats.expensesPercentage,
                  icon: Icons.remove_circle_outline_rounded,
                  accent: const Color(0xffE74C3C),
                ),
              ),

              SizedBox(width: 2),

              Expanded(
                child: _StatCard(
                  label: 'home.daily_sales'.tr(),
                  value: stats.todaySales,
                  unit: 'home.riyal_sa'.tr(),
                  percentage: stats.salesPercentage,
                  icon: Icons.show_chart_rounded,
                  accent: const Color(0xff3B5BDB),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class ReportsSection extends StatelessWidget {
  const ReportsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsVisibilityBloc, bool>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, showReports) {
        return SliverMainAxisGroup(
          slivers: [
            SliverToBoxAdapter(
              child: _ReportsHeader(
                showReports: showReports,
              ),
            ),

            if (showReports)
              const _ReportsGrid(),
          ],
        );
      },
    );
  }
}
class _ReportsGrid extends StatelessWidget {
  const _ReportsGrid();

  @override
  Widget build(BuildContext context) {
    final cards = _reportCards(context);
    final crossAxisCount = AppResponsive.isMobile(context) ? 2 : 4;
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
      ),
      sliver: SliverGrid(
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 4.h,
          crossAxisSpacing: 4.w,
          childAspectRatio: 2.5,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            return cards[index]
                .animate()
                .fadeIn(
              duration: 350.ms,
              delay: Duration(
                milliseconds: index * 40,
              ),
              curve: Curves.easeOut,
            )
                .slideY(
              begin: 0.15,
              end: 0,
              duration: 350.ms,
              delay: Duration(
                milliseconds: index * 40,
              ),
              curve: Curves.easeOutCubic,
            )
             ;
          },
          childCount: cards.length,
        ),
      ),
    );
  }
}
class _ReportsHeader extends StatelessWidget {
  final bool showReports;

  const _ReportsHeader({
    required this.showReports,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16.w,
        24.h,
        16.w,
        8.h,
      ),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 18.h,
            decoration: BoxDecoration(
              color: const Color(0xff3B5BDB),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          SizedBox(width: 8.w),

          Expanded(
            child: Text(
              'home.main_reports'.tr(),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xff1A1A1A),
              ),
            ),
          ),

          InkWell(
            borderRadius: BorderRadius.circular(12.r),
            onTap: () {
              context.read<ReportsVisibilityBloc>().add(
                const ToggleReportsVisibility(),
              );
            },
            child: Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: AnimatedRotation(
                turns: showReports ? 0 : 0.5,
                duration: const Duration(
                  milliseconds: 300,
                ),
                curve: Curves.easeInOut,
                child: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xff8A8F99),
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _StatCard extends StatelessWidget {
  final String label;
  final num value;
  final String unit;
  final int? percentage;
  final IconData icon;
  final Color accent;

  const _StatCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.percentage,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: 120,
          padding: EdgeInsets.fromLTRB(10.w, 16.h, 10.w, 0.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextTheme.caption
                    .copyWith(color: const Color(0xff8A8F99)),
              ),
              Text(
                _formatMoney(value.toDouble()),
                style: AppTextTheme.titleSmallBold,
              ),
            ],
          ),
        ),
        Positioned(
          top: -14.h,
          child: CircleAvatar(
            radius: 17.w,
            backgroundColor: AppColors.white,
            child: Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accent, size: 20.sp),
            ),
          ),
        ),
      ],
    );
  }

  String _formatMoney(double v) {
    // Thousands-grouping for the dashboard.
    final intPart = v.toInt();
    final str = intPart.toString();
    final buf = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      buf.write(str[i]);
      final remaining = str.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) buf.write(',');
    }
    return buf.toString();
  }
}
class _ReportCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String icon;
  final Color color;
  final VoidCallback onTap;
  final bool highlight;

  const _ReportCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.r),
      child: GestureDetector(
        onTap: onTap,

        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: highlight
                ? Border.all(color: color.withValues(alpha: 0.4), width: 1.5)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          // Grid uses crossAxisCount=3 with aspectRatio=1.05, so the cell
          // ends up small. MainAxisSize.min stops the Column claiming full
          // height (no Spacer-forced growth), the icon shrinks 48→38, and
          // Flexible around the text widgets lets them collapse / ellipsis
          // gracefully when the cell can't fit both lines comfortably.
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  SvgPicture.asset(
                    icon,
                    width:40.sp,
                    height: 40.sp,

                  ),
                  if (highlight)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          'LIVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 7.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.labelMedium11Bold,
                    ),

                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.labelMedium
                          .copyWith(color: const Color(0xff8A8F99)),
                    ),
                  ],
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
class _ChartsSection extends StatelessWidget {
  const _ChartsSection();

  @override
  Widget build(BuildContext context) {
    // IntrinsicHeight: the Row sits inside a SliverToBoxAdapter (unbounded
    // height). With `crossAxisAlignment: stretch` alone the children get an
    // infinite-height constraint and layout asserts. IntrinsicHeight pins
    // the row's height to the tallest child first, so stretch then matches
    // both cards to that bounded height.
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _BranchPie()),
            SizedBox(width: 10.w),
            Expanded(child: _WeeklyTrend()),
          ],
        ),
      ),
    );
  }
}
class _BranchPie extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final slices = [
      ('home.salmiya'.tr(), 40, const Color(0xff3B5BDB)),
      ('home.hawalli'.tr(), 30, const Color(0xff9B59B6)),
      ('home.farwaniya'.tr(), 20, const Color(0xff40C057)),
      ('home.ahmadi'.tr(), 10, const Color(0xffE67E22)),
    ];
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'home.branches_distribution'.tr(),
            maxLines: 2,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xff1A1A1A),
            ),
          ),
          SizedBox(height: 12.h),
          // Stacked horizontal bar — clean placeholder until fl_chart is added.
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: SizedBox(
              height: 12.h,
              child: Row(
                children: slices
                    .map(
                      (s) => Expanded(
                        flex: s.$2,
                        child: Container(color: s.$3),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          ...slices.map(
            (s) => Padding(
              padding: EdgeInsets.symmetric(vertical: 3.h),
              child: Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: s.$3,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      s.$1,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: const Color(0xff1A1A1A),
                      ),
                    ),
                  ),
                  Text(
                    '${s.$2}%',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff1A1A1A),
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
}
class _WeeklyTrend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Real 7-day series sliced from the dashboard balances' 30-day
    // `dailySales` array. We rebuild whenever HomeBloc emits — the bloc
    // caches the full DashboardBalancesModel on `balances` after a
    // successful `InitHome`.
    return BlocBuilder<HomeBloc, BaseState<HomeStatsModel>>(
      builder: (context, _) {
        final all = context.read<HomeBloc>().balances?.dailySales ?? const [];
        final today = DateTime.now().day;
        // Trailing 7 days ending at "today" — entries are already sorted
        // ascending by `day` (server returns 1..30). Guarding with `>= 1`
        // avoids underflow early in the month (e.g. today == 3 → days 1..3).
        final lowerBound = today - 6;
        final window = all
            .where((e) => e.day >= lowerBound && e.day <= today)
            .toList();

        final max = window.fold<double>(
          0,
          (m, e) => e.total > m ? e.total : m,
        );

        return Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'home.weekly_sales'.tr(),
                maxLines: 2,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff1A1A1A),
                ),
              ),
              SizedBox(height: 12.h),
              SizedBox(
                height: 90.h,
                child: window.isEmpty
                    ? const SizedBox.shrink()
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: window.map((e) {
                          final ratio = max == 0 ? 0.0 : e.total / max;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 1.5.w, vertical: 1.5.h),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: ratio * 70.h,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff3B5BDB)
                                          .withValues(alpha: 0.5 + ratio * 0.5),
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    '${e.day}',
                                    style: TextStyle(
                                      fontSize: 8.sp,
                                      color: const Color(0xff8A8F99),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
