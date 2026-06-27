part of '../../home_imports.dart';

/// Top-level screen. Hosts the 6-tab bottom navigation (per the redesign):
///
///   0 — Home (the redesigned dashboard)
///   1 — Live Sales (the existing sales catalogue / basket flow)
///   2 — Accounts (placeholder)
///   3 — Reports
///   4 — More (placeholder)
///   5 — Settings
///
/// Tabs share state via `IndexedStack`, so popping back into a tab restores
/// it instead of rebuilding. Order is *logical* — Directionality.rtl
/// renders Home rightmost on Arabic locales, which matches the design.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static final List<Widget> _screens = [
    // 0 — Home
    const HomeTab(),

    // 1 — Live Sales (catalogue + basket flow)
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<SalesBloc>()),
        BlocProvider(create: (_) => getIt<MainCategoryBloc>()),
        BlocProvider(create: (_) => getIt<SubCategoryBloc>()),
        BlocProvider.value(value: getIt<BasketBloc>()),
      ],
      child: const SalesTab(),
    ),

    // 2 — Accounts (not built yet)
    const UnderConstructionScreen(),

    // 3 — Reports
    BlocProvider(
      create: (_) => getIt<ReportsBloc>(),
      child: const ReportsTab(),
    ),

    // 4 — More (not built yet)
    const UnderConstructionScreen(),

    // 5 — Settings
    BlocProvider(
      create: (_) => getIt<SettingsBloc>(),
      child: const SettingsTab(),
    ),
  ];

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const InitHome());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavBloc, NavState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: state.currentIndex,
            children: MainScreen._screens,
          ),
          bottomNavigationBar: _BottomNavBar(currentIndex: state.currentIndex),
        );
      },
    );
  }
}

/// 6-tab bottom navigation. The Live Sales item (index 1) gets a slightly
/// raised circular treatment so it reads as the primary action — same
/// pattern the design screenshot calls out.
class _BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const _BottomNavBar({required this.currentIndex});

  static const _accent = Color(0xff3B5BDB);
  static const _liveAccent = Color(0xffE74C3C);
  static const _muted = Color(0xff8A8F99);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _item(
                context,
                0,
                Icons.home_outlined,
                Icons.home_rounded,
                'nav_home'.tr(),
              ),
              _liveItem(context),
              _item(
                context,
                2,
                Icons.account_balance_wallet_outlined,
                Icons.account_balance_wallet_rounded,
                'nav_accounts'.tr(),
              ),
              _item(
                context,
                3,
                Icons.bar_chart_outlined,
                Icons.bar_chart_rounded,
                'nav_reports'.tr(),
              ),
              _item(
                context,
                4,
                Icons.apps_outlined,
                Icons.apps_rounded,
                'nav_more'.tr(),
              ),
              _item(
                context,
                5,
                Icons.settings_outlined,
                Icons.settings_rounded,
                'nav_settings'.tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context,
    int index,
    IconData icon,
    IconData activeIcon,
    String label,
  ) {
    final selected = currentIndex == index;
    final color = selected ? _accent : _muted;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: () => context.read<NavBloc>().add(ChangeNavTab(index)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(selected ? activeIcon : icon, color: color, size: 22.sp),
              SizedBox(height: 4.h),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: color,
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// The prominent center tab — Live Sales. A red ring + raised treatment
  /// matches the design's "primary action" emphasis.
  Widget _liveItem(BuildContext context) {
    final selected = currentIndex == 1;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: () => context.read<NavBloc>().add(const ChangeNavTab(1)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: selected
                      ? _liveAccent
                      : _liveAccent.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _liveAccent.withValues(alpha: selected ? 0 : 0.6),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.wifi_tethering_rounded,
                  color: selected ? Colors.white : _liveAccent,
                  size: 22.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'nav_live_sales'.tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: _liveAccent,
                  fontWeight: selected ? FontWeight.bold : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
