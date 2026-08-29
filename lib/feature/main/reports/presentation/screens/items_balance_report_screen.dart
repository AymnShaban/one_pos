part of '../../reports_imports.dart';
class ItemsBalanceReportScreen extends StatelessWidget {
  const ItemsBalanceReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainAppColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
            'reports.items_balance_report'.tr(),
              style: AppTextTheme.heading2.copyWith(
                color: Colors.white,
              ),
            ),
            Text(
              'reports.items_balance_report_subtitle'.tr(),
              style: AppTextTheme.labelSmall.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .15),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.analytics_outlined,
                color: Colors.white,
                size: 22.sp,
              ),
            ),
          ),
        ],
      ),

      body: BlocBuilder<ReportsBloc, BaseState<ReportSummaryModel>>(
        builder: (context, state) {
          final bloc = context.read<ReportsBloc>();

          final report = state.items.isNotEmpty
              ? state.items.first
              : const ReportSummaryModel();

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(18.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff3B82F6),
                        Color(0xff2563EB),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Row(
                    children: [

                      Container(
                        width: 58.w,
                        height: 58.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .15),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Icon(
                          Icons.inventory_2_rounded,
                          color: Colors.white,
                          size: 30.sp,
                        ),
                      ),

                      SizedBox(width: 16.w),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              'reports.items_balance_report_header'.tr(),
                              style: AppTextTheme.heading2.copyWith(
                                color: Colors.white,
                              ),
                            ),

                            SizedBox(height: 6.h),

                            Text(
                              'reports.items_balance_report_description'.tr(),
                              style: AppTextTheme.labelSmall.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(height: 18.h),

                PeriodFilterBar(
                  selected: bloc.selectedPeriod,
                ),

                SizedBox(height: 18.h),

                if (state.status == Status.loading)

                  const Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(),
                  )

                else if (state.status == Status.failure)

                  Center(
                    child: Text(
                      state.errorMessage ?? "",
                      style: const TextStyle(color: Colors.red),
                    ),
                  )

                else ...[

                    ReportMainStats(
                      report: report,
                    ),

                    SizedBox(height: 14.h),

                    ReportSecondaryStats(
                      report: report,
                    ),

                    SizedBox(height: 16.h),

                    if (report.topProducts.isNotEmpty)
                      TopProductsList(
                        products: report.topProducts,
                      ),
                  ]
              ],
            ),
          );
        },
      ),
    );
  }
}