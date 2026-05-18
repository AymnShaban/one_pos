part of '../../home_imports.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F2F8),
      body: BlocBuilder<HomeBloc, BaseState<HomeStatsModel>>(
        builder: (context, state) {
          final stats = state.items.isNotEmpty
              ? state.items.first
              : const HomeStatsModel();
          final isSynced = context.read<HomeBloc>().isSynced;

          return CustomScrollView(
            slivers: [
              // ── AppBar ──
              HomeAppBar(isOnline: context.read<HomeBloc>().isOnline),

              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // ── Welcome Card ──
                      GestureDetector(
                        onTap: () {
                          debugPrint(decrypt(printDecryptData));
                        },
                        child: WelcomeCard(isSynced: isSynced),
                      ),
                      SizedBox(height: 16.h),

                      // ── Stats Row ──
                      Row(
                        children: [
                          Expanded(
                            child: StatsCard(
                              label: 'home.products'.tr(),
                              value: '${stats.productsCount}',
                              badge: 'home.active'.tr(),
                              badgeColor: Colors.green,
                              iconColor: const Color(0xff9B59B6),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: StatsCard(
                              label: 'home.invoices'.tr(),
                              value: '${stats.invoicesCount}',
                              badge: '+${stats.invoicesNewCount}',
                              badgeColor: const Color(0xff3B5BDB),
                              iconColor: const Color(0xff4DABF7),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: StatsCard(
                              label: 'home.today_sales'.tr(),
                              value: stats.todaySales.toStringAsFixed(0),
                              badge: '+${stats.salesPercentage}%',
                              badgeColor: Colors.green,
                              iconColor: const Color(0xff40C057),
                              isCurrency: true,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      // ── Sales Section ──
                      _SectionHeader(title: 'home.sales'.tr()),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Expanded(
                            child: ActionCard(
                              label: 'home.new_sales_invoice'.tr(),
                              icon: Icons.shopping_cart_rounded,
                              color: const Color(0xff3B5BDB),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MultiBlocProvider(
                                      providers: [
                                        BlocProvider(
                                          create: (_) => getIt<SalesBloc>(),
                                        ),
                                        BlocProvider(
                                          create: (_) =>
                                              getIt<MainCategoryBloc>(),
                                        ),
                                        BlocProvider(
                                          create: (_) =>
                                              getIt<SubCategoryBloc>(),
                                        ),
                                        BlocProvider(
                                          create: (_) => getIt<HomeBloc>(),
                                        ),
                                        BlocProvider.value(
                                          value: getIt<BasketBloc>(),
                                        ),
                                      ],
                                      child: const SalesTab(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: ActionCard(
                              label: 'home.price_quote'.tr(),
                              icon: Icons.receipt_outlined,
                              color: const Color(0xff3B5BDB),
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      // ── Operations Section ──
                      _SectionHeader(title: 'home.operations'.tr()),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Expanded(
                            child: ActionCard(
                              label: 'home.manage_invoices'.tr(),
                              icon: Icons.inventory_2_rounded,
                              color: const Color(0xff40C057),
                              onTap: () {},
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: ActionCard(
                              label: 'home.reports'.tr(),
                              icon: Icons.trending_up_rounded,
                              color: const Color(0xff9B59B6),
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Expanded(
                            child: ActionCard(
                              label: 'home.customers'.tr(),
                              icon: Icons.people_alt_rounded,
                              color: const Color(0xffE67E22),
                              onTap: () {},
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(child: SizedBox()),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      // ── Recent Activity ──
                      _SectionHeader(title: 'home.recent_activity'.tr()),
                      SizedBox(height: 10.h),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          children: const [
                            RecentActivityItem(
                              name: 'محمد أحمد',
                              invoiceId: 'INV-1234',
                              timeAgo: 'منذ 5 دقائق',
                              amount: 450,
                              status: 'مكتمل',
                            ),
                            Divider(height: 1, indent: 16, endIndent: 16),
                            RecentActivityItem(
                              name: 'فاطمة علي',
                              invoiceId: 'INV-1233',
                              timeAgo: 'منذ 15 دقيقة',
                              amount: 890,
                              status: 'مكتمل',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xff1A1A1A),
        ),
      ),
    );
  }
}
