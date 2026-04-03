part of '../../reports_imports.dart';

class ReportsTab extends StatelessWidget {
  const ReportsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F2F8),
      body: BlocBuilder<ReportsBloc, BaseState<ReportSummaryModel>>(
        builder: (context, state) {
          final bloc   = context.read<ReportsBloc>();
          final report = state.items.isNotEmpty
              ? state.items.first
              : const ReportSummaryModel();

          return CustomScrollView(
            slivers: [
              const SalesAppBar(isOnline: true),

              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                  child: Column(
                    children: [
                      // Report type selector
                      ReportTypeSelector(selected: bloc.selectedType),
                      SizedBox(height: 14.h),

                      // Period filter
                      PeriodFilterBar(selected: bloc.selectedPeriod),
                      SizedBox(height: 14.h),

                      // Loading
                      if (state.status == Status.loading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(child: CircularProgressIndicator()),
                        )

                      // Error
                      else if (state.status == Status.failure)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.h),
                          child: Center(
                            child: Text(
                              state.errorMessage ?? 'common.error'.tr(),
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        )

                      // Data
                      else ...[
                          ReportMainStats(report: report),
                          SizedBox(height: 12.h),
                          ReportSecondaryStats(report: report),
                          SizedBox(height: 14.h),
                          if (report.topProducts.isNotEmpty)
                            TopProductsList(products: report.topProducts),
                          SizedBox(height: 14.h),
                        ],
                    ],
                  ),
                ),
              ),

              // Export PDF button
              SliverFillRemaining(
                hasScrollBody: false,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton.icon(
                        onPressed: () => context
                            .read<ReportsBloc>()
                            .add(const ExportReportPdf()),
                        icon: const Icon(Icons.download_rounded,
                            color: Colors.white),
                        label: Text(
                          'reports.export_pdf'.tr(),
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff3B5BDB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
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
