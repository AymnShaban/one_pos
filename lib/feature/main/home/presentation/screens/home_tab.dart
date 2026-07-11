part of '../../home_imports.dart';

/// Redesigned home tab — gradient blue header (logo + notifications +
/// hamburger + welcome + date), a row of 4 stat cards (revenue / expenses
/// / profit / today invoices), a 2×4 grid of "Main Reports" cards, the
/// live-sales feed, and the two summary charts. Tap any report card to
/// either switch the bottom-nav tab (Live Sales / Reports) or push a
/// dedicated feature route (Stock Taking) — anything not yet built lands
/// on the shared [UnderConstructionScreen].
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool _showReports = true;
  @override
  void initState() {
    super.initState();
    // Lazy-load the dashboard only when this tab actually mounts —
    // navigating to Settings (or any other tab) on launch should not
    // trigger any network calls.
    final bloc = context.read<HomeBloc>();
    if (bloc.state.status != Status.success) {
      bloc.add(const InitHome());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F2F8),
      body: BlocBuilder<HomeBloc, BaseState<HomeStatsModel>>(
        builder: (context, state) {
          final stats = state.items.isNotEmpty
              ? state.items.first
              : const HomeStatsModel();
          return CustomScrollView(
            slivers: [
              // ── Header: logo, bell, hamburger, welcome, date + stats ──
              SliverToBoxAdapter(child: _HomeHeader(stats: stats)),

              // ── Main Reports grid ────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      // const Icon(Icons.apps_rounded,
                      //     color: Color(0xff8A8F99), size: 18),

                      InkWell(
                        borderRadius: BorderRadius.circular(12.r),
                        onTap: () {
                          setState(() { _showReports = !_showReports; });
                        },
                        child: Container(
                          width: 36.w,
                          height: 36.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: AnimatedRotation(
                            turns: _showReports ? 0 : 0.5,
                            duration: const Duration(milliseconds: 300),
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
                ),
              ),

              _showReports
                  ? SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.h,
                    crossAxisSpacing: 10.w,
                    childAspectRatio: 1.55,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return _reportCards(context)[index]
                          .animate()
                          .fadeIn(
                        duration: 400.ms,
                        curve: Curves.easeOut,
                      )
                          .slideY(
                        begin: 0.2,
                        end: 0,
                        duration: 400.ms,
                        curve: Curves.easeOut,
                      )
                          .scale(
                        begin: const Offset(0.95, 0.95),
                        duration: 400.ms,
                        curve: Curves.easeOut,
                      );
                    },
                    childCount: _reportCards(context).length,
                  ),
                ),
              )
                  : const SliverToBoxAdapter(
                child: SizedBox.shrink(),
              ),

              // ── Live Sales feed ──────────────────────────────────────
              const SliverToBoxAdapter(child: _LiveSalesSection()),

              // ── Charts ───────────────────────────────────────────────
              const SliverToBoxAdapter(child: _ChartsSection()),

              SliverToBoxAdapter(child: SizedBox(height: 24.h)),
            ],
          );
        },
      ),
    );
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
        icon: Icons.wifi_tethering_rounded,
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
        title: 'home.top_selling_items'.tr(),
        subtitle: 'home.top_selling_subtitle'.tr(),
        icon: Icons.emoji_events_rounded,
        color: const Color(0xffF5A623),
        onTap: () =>
            context.read<NavBloc>().add(const ChangeNavTab(3)), // Reports
      ),

      _ReportCard(
        title: 'home.branches_analysis'.tr(),
        subtitle: 'home.branches_subtitle'.tr(),
        icon: Icons.storefront_rounded,
        color: const Color(0xff9B59B6),
        onTap: () => underConstruction(
          Icons.storefront_rounded,
          'home.branches_analysis'.tr(),
        ),
      ),
      _ReportCard(
        title: 'home.food_categories_report'.tr(),
        subtitle: 'home.food_categories_subtitle'.tr(),
        icon: Icons.local_grocery_store_rounded,
        color: const Color(0xffE67E22),
        onTap: () => underConstruction(
          Icons.local_grocery_store_rounded,
          'home.food_categories_report'.tr(),
        ),
      ),
      _ReportCard(
        title: 'home.stock_transfers'.tr(),
        subtitle: 'home.stock_transfers_subtitle'.tr(),
        icon: Icons.local_shipping_rounded,
        color: const Color(0xff27AE60),
        onTap: () => underConstruction(
          Icons.local_shipping_rounded,
          'home.stock_transfers'.tr(),
        ),
      ),
      _ReportCard(
        title: 'home.stock_taking'.tr(),
        subtitle: 'home.stock_taking_subtitle'.tr(),
        icon: Icons.fact_check_rounded,
        color: const Color(0xff40C057),
        onTap: () {
          // Real feature — push the Barren stock-taking screen with its
          // bloc provided (same wiring used by reports_tab's Stock Taking
          // button).
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider<InvoiceCubit>(
                create: (_) => GetIt.instance<InvoiceCubit>(),
                child: const BarrenStockTakingScreen(),
              ),
            ),
          );
        },
      ),
      _ReportCard(
        title: 'home.expiry_monitoring'.tr(),
        subtitle: 'home.expiry_subtitle'.tr(),
        icon: Icons.event_available_rounded,
        color: const Color(0xff3B5BDB),
        onTap: () => underConstruction(
          Icons.event_available_rounded,
          'home.expiry_monitoring'.tr(),
        ),
      ),
      _ReportCard(
        title: 'home.sales_reports'.tr(),
        subtitle: 'home.sales_reports_subtitle'.tr(),
        icon: Icons.insert_chart_rounded,
        color: const Color(0xff4DABF7),
        onTap: () =>
            context.read<NavBloc>().add(const ChangeNavTab(3)), // Reports
      ),
      // pos item
      _ReportCard(
        title: 'home.pos'.tr(),
        subtitle: 'home.pos_subtitle'.tr(),
        icon: Icons.point_of_sale_rounded,
        color: const Color(0xff20C997),
        onTap: () =>
            context.read<NavBloc>().add(const ChangeNavTab(1)), // Sales
      ),
    ];
  }
}

// ────────────────────────────────────────────────────────────────────────
//  Header
// ────────────────────────────────────────────────────────────────────────

class _HomeHeader extends StatelessWidget {
  final HomeStatsModel stats;

  const _HomeHeader({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage(AppAssets.backgroundImage), fit: BoxFit.cover),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12.h,
        left: 16.w,
        right: 16.w,
        bottom: 8.h,
      ),
      child: Column(
        children: [
          // Top row: hamburger | logo | notifications
          // Row(
          //   children: [
          //     const _HeaderIcon(icon: Icons.menu_rounded),
          //
          //     const Spacer(),
          //     const _HeaderIcon(
          //       icon: Icons.notifications_none_rounded,
          //       badge: 3,
          //     ),
          //   ],
          // ),
          SizedBox(height:80.h),

          // Welcome line
          // Row(
          //   children: [
          //     Text(
          //       '👋',
          //       style: TextStyle(fontSize: 18.sp),
          //     ),
          //     SizedBox(width: 6.w),
          //     Expanded(
          //       child: Text(
          //         'home.welcome_admin'.tr(),
          //         style: AppTextTheme.body2.copyWith(color: AppColors.black)
          //       ),
          //     ),
          //     const Icon(Icons.calendar_today_outlined,
          //         color: Colors.white70, size: 16),
          //     SizedBox(width: 4.w),
          //     Text(
          //       _today(context),
          //       style: TextStyle(
          //         color: Colors.white70,
          //         fontSize: 12.sp,
          //       ),
          //     ),
          //   ],
          // ),

          // 3 stat cards — Sales / Costs / Daily Sales
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
              SizedBox(width: 8.w),
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
              SizedBox(width: 8.w),
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

  // String _today(BuildContext context) {
  //   final now = DateTime.now();
  //   return '${now.day}/${now.month}/${now.year}';
  // }
}

// class _HeaderIcon extends StatelessWidget {
//   final IconData icon;
//   final int? badge;
//
//   const _HeaderIcon({required this.icon, this.badge});
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         Container(
//           width: 36.w,
//           height: 36.w,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: Colors.white.withValues(alpha: 0.15),
//             borderRadius: BorderRadius.circular(10.r),
//           ),
//           child: Icon(icon, color: Colors.white, size: 20.sp),
//         ),
//         if (badge != null && badge! > 0)
//           Positioned(
//             top: -4,
//             right: -4,
//             child: Container(
//               padding: EdgeInsets.all(4.w),
//               constraints: BoxConstraints(minWidth: 16.w, minHeight: 16.w),
//               decoration: const BoxDecoration(
//                 color: Color(0xffE74C3C),
//                 shape: BoxShape.circle,
//               ),
//               child: Center(
//                 child: Text(
//                   '$badge',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 9.sp,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }

// ────────────────────────────────────────────────────────────────────────
//  Stat card (top header — money / count variants)
// ────────────────────────────────────────────────────────────────────────

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

// ────────────────────────────────────────────────────────────────────────
//  Main Reports grid card
// ────────────────────────────────────────────────────────────────────────

class _ReportCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
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
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: highlight
                ? Border.all(color: color.withValues(alpha: 0.4), width: 1.5) : null,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 38.w,
                    height: 38.w,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(icon, color: color, size: 20.sp),
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
              SizedBox(height: 6.h),
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextTheme.body2Bold,
                ),
              ),
              SizedBox(height: 2.h),
              Flexible(
                child: Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextTheme.captionBold
                      .copyWith(color: const Color(0xff8A8F99)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────
//  Live Sales feed
// ────────────────────────────────────────────────────────────────────────

class _LiveSalesSection extends StatelessWidget {
  const _LiveSalesSection();

  @override
  Widget build(BuildContext context) {
    final samples = [
      _LiveSale('home.live_sales_now'.tr(), '100043', '09:41 AM', 1.5,
          Icons.local_drink_outlined),
      _LiveSale('Khobz', '100045', '09:40 AM', 0.75, Icons.bakery_dining_outlined),
      _LiveSale('Pepsi', '100042', '09:39 AM', 1.2, Icons.local_drink_outlined),
    ];
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: const BoxDecoration(
                  color: Color(0xffE74C3C),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                'home.live_sales_now'.tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff1A1A1A),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () =>
                    context.read<NavBloc>().add(const ChangeNavTab(1)),
                child: Text(
                  'home.view_all'.tr(),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xff3B5BDB),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
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
              children: List.generate(samples.length, (i) {
                final s = samples[i];
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 10.h),
                      child: Row(
                        children: [
                          Container(
                            width: 36.w,
                            height: 36.w,
                            decoration: BoxDecoration(
                              color: const Color(0xffF0F2F8),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(s.icon,
                                color: const Color(0xff8A8F99), size: 18.sp),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xff1A1A1A),
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  '${'new_invoice.product_code'.tr()}: ${s.code}',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: const Color(0xff8A8F99),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${s.value.toStringAsFixed(3)} '
                                '${'common.EGP'.tr()}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff40C057),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                s.time,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: const Color(0xff8A8F99),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (i != samples.length - 1)
                      Divider(
                        height: 1,
                        indent: 12.w,
                        endIndent: 12.w,
                        color: const Color(0xffF0F2F8),
                      ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveSale {
  final String name;
  final String code;
  final String time;
  final double value;
  final IconData icon;
  _LiveSale(this.name, this.code, this.time, this.value, this.icon);
}

// ────────────────────────────────────────────────────────────────────────
//  Charts section (placeholders — no chart lib in pubspec)
// ────────────────────────────────────────────────────────────────────────

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
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 0),
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
