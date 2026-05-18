part of '../../home_imports.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static final List<Widget> _screens = [
    const HomeTab(),
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<SalesBloc>()),
        BlocProvider(create: (_) => getIt<MainCategoryBloc>()),
        BlocProvider(create: (_) => getIt<SubCategoryBloc>()),
        BlocProvider.value(value: getIt<BasketBloc>()),
      ],
      child: const SalesTab(),
    ),
    BlocProvider(create: (_) => getIt<InvoicesBloc>(), child: InvoicesTab()),
    BlocProvider(create: (_) => getIt<ReportsBloc>(), child: ReportsTab()),
    BlocProvider(
      create: (_) => getIt<SettingsBloc>(),
      child: const SettingsTab(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavBloc, NavState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(index: state.currentIndex, children: _screens),
          bottomNavigationBar: _BottomNavBar(currentIndex: state.currentIndex),
        );
      },
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const _BottomNavBar({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => context.read<NavBloc>().add(ChangeNavTab(index)),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xff3B5BDB),
        unselectedItemColor: const Color(0xff8A8F99),
        selectedFontSize: 11.sp,
        unselectedFontSize: 11.sp,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home_rounded),
            label: 'nav_home'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_cart_outlined),
            activeIcon: const Icon(Icons.shopping_cart_rounded),
            label: 'nav_sales'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.receipt_long_outlined),
            activeIcon: const Icon(Icons.receipt_long_rounded),
            label: 'nav_invoices'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bar_chart_outlined),
            activeIcon: const Icon(Icons.bar_chart_rounded),
            label: 'nav_reports'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            activeIcon: const Icon(Icons.settings_rounded),
            label: 'nav_settings'.tr(),
          ),
        ],
      ),
    );
  }
}
