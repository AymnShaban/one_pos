import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/helper/helper.dart';
import '../../../invoices/manager/invoices_bloc/invoices_bloc.dart';
import '../../../invoices/manager/invoices_bloc/invoices_event.dart';
import '../../../invoices/presentation/screens/invoices_tab.dart';
import '../../../sales/manager/sales_bloc/sales_bloc.dart';
import '../../../sales/manager/sales_bloc/sales_event.dart';
import '../../../sales/presentation/screens/sales_tab.dart';
import '../../manager/bottom_nav_bloc/bottom_nav_bloc.dart';
import '../../manager/bottom_nav_bloc/bottom_nav_event.dart';
import '../../manager/bottom_nav_bloc/bottom_nav_states.dart';
import 'home_tab.dart';
import 'invoices_placeholder.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static final List<Widget> _screens = [
    const HomeTab(),
    BlocProvider(
        create: (_) => getIt<SalesBloc>()..add(const FetchProducts()),

        child: const SalesTab()),
     BlocProvider(
         create: (_) => getIt<InvoicesBloc>()..add(const FetchInvoices()),

         child: InvoicesTab()),

    const SalesPlaceholder(),
    const SalesPlaceholder(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavBloc, NavState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: state.currentIndex,
            children: _screens,
          ),
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
            label: 'home.home'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_cart_outlined),
            activeIcon: const Icon(Icons.shopping_cart_rounded),
            label: 'home.sales'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.receipt_long_outlined),
            activeIcon: const Icon(Icons.receipt_long_rounded),
            label: 'home.invoices'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bar_chart_outlined),
            activeIcon: const Icon(Icons.bar_chart_rounded),
            label: 'home.reports'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            activeIcon: const Icon(Icons.settings_rounded),
            label: 'home.settings'.tr(),
          ),
        ],
      ),
    );
  }
}