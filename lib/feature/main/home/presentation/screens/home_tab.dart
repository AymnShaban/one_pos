import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/bloc/paginated_bloc/paginated_bloc.dart';
import '../../manager/home_bloc/home_bloc.dart';
import '../../models/home_stats_model.dart';
import '../widgets/action_card.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/recent_activity_item.dart';
import '../widgets/stats_card.dart';
import '../widgets/welcome_card.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F2F8),
      body: BlocBuilder<HomeBloc, BaseState<HomeStatsModel>>(
        builder: (context, state) {
          final stats = state.items.isNotEmpty ? state.items.first : const HomeStatsModel();
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
                      WelcomeCard(isSynced: isSynced),
                      SizedBox(height: 16.h),

                      // ── Stats Row ──
                      Row(
                        children: [
                          Expanded(
                            child: StatsCard(
                              label: 'products'.tr(),
                              value: '${stats.productsCount}',
                              badge: 'active'.tr(),
                              badgeColor: Colors.green,
                              iconColor: const Color(0xff9B59B6),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: StatsCard(
                              label: 'invoices'.tr(),
                              value: '${stats.invoicesCount}',
                              badge: '+${stats.invoicesNewCount}',
                              badgeColor: const Color(0xff3B5BDB),
                              iconColor: const Color(0xff4DABF7),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: StatsCard(
                              label: 'today_sales'.tr(),
                              value: '${stats.todaySales.toStringAsFixed(0)}',
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
                      _SectionHeader(title: 'sales'.tr()),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Expanded(
                            child: ActionCard(
                              label: 'new_sales_invoice'.tr(),
                              icon: Icons.shopping_cart_rounded,
                              color: const Color(0xff3B5BDB),
                              onTap: () {},
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: ActionCard(
                              label: 'price_quote'.tr(),
                              icon: Icons.receipt_outlined,
                              color: const Color(0xff3B5BDB),
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      // ── Operations Section ──
                      _SectionHeader(title: 'operations'.tr()),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Expanded(
                            child: ActionCard(
                              label: 'manage_invoices'.tr(),
                              icon: Icons.inventory_2_rounded,
                              color: const Color(0xff40C057),
                              onTap: () {},
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: ActionCard(
                              label: 'reports'.tr(),
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
                              label: 'customers'.tr(),
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
                      _SectionHeader(title: 'recent_activity'.tr()),
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