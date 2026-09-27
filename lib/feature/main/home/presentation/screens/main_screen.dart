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

    // 1 — Live Sales (catalogue + basket flow). SalesCategoryBloc is
    // provided inside SalesTab so the load fires when that tab actually
    // mounts (lazy-load pattern).
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<SalesBloc>()),
        BlocProvider(create: (_) => getIt<BranchBloc>()),
        BlocProvider(create: (_) => getIt<InvoiceSetupBloc>()),
        BlocProvider(create: (_) => getIt<SalesCategoryBloc>()),
        BlocProvider.value(value: getIt<BasketBloc>()),
      ],
      child: const SalesTab(),
    ),


    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<EntriesBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<MainAccountsBloc>(),
        ), BlocProvider(
          create: (_) => getIt<FillAccountsBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<VoucherCreationBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<JournalEntryBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<CurrenciesBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<BranchesBloc>(), // ✅ أضف هذا
        ),
      ],
      child:  VoucherCreationScreen(),
    ),

    // 2 — Accounts (not built yet)
     ClientStatementScreen(),



    // 4 — More (not built yet)


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
    context.read<DailyOperationsBloc>().add(const LoadDailyOperations());
    final topSellingBloc = context.read<TopSellingBloc>();
    if (topSellingBloc.state.status != Status.success) {
      topSellingBloc.add(const LoadTopSellingItems());
    }


    final lowStockBloc = context.read<LowStockBloc>();
    if (lowStockBloc.state.status != Status.success) {
      lowStockBloc.add(const LoadLowStockItems());
    }
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

  static const _accent = AppColors.mainAppColor;
  static const _muted = AppColors.secondaryAppColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundColor2,
        border: Border(
          top: BorderSide(
            color: AppColors.mainAppColor.withValues(alpha: .12),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 20,
            offset: const Offset(0, -4),
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
              _item(
                context,
                1,
                Icons.sell_outlined,
                Icons.sell_rounded,
                'home.pos'.tr(),
              ),

              _item(
                context,
                2,
                Icons.receipt_long_outlined,
                Icons.receipt_long,
                'nav_entries'.tr(),
              ),
              _item(
                context,
                3,
                Icons.receipt_long_outlined,
                Icons.receipt_long_rounded,
                'nav_accounts'.tr(),
              ),

              _item(
                context,
                4,
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

}
