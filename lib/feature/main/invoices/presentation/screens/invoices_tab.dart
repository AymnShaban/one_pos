part of '../../invoices_imports.dart';

class InvoicesTab extends StatelessWidget {
  const InvoicesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F2F8),
      body: BlocBuilder<InvoicesBloc, BaseState<InvoiceModel>>(
        builder: (context, state) {
          final stats = InvoiceStatsModel.fromList(state.items);

          return CustomScrollView(
            slivers: [
              const SalesAppBar(isOnline: true),

              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Title
                      Text(
                        'إدارة الفواتير',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff1A1A1A),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'عرض وإدارة جميع الفواتير',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xff8A8F99),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Search
                      _InvoiceSearchBar(
                        onChanged: (q) => context
                            .read<InvoicesBloc>()
                            .add(SearchInvoices(q)),
                      ),
                      SizedBox(height: 12.h),

                      // Filter bar
                      const InvoiceFilterBar(),
                      SizedBox(height: 16.h),

                      // Stats
                      InvoiceStatsRow(stats: stats),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),

              // Loading
              if (state.status == Status.loading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )

              // Error
              else if (state.status == Status.failure)
                SliverFillRemaining(
                  child: Center(
                    child: Text(
                      state.errorMessage ?? 'error'.tr(),
                      style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    ),
                  ),
                )

              // Empty
              else if (state.items.isEmpty &&
                    state.status == Status.success)
                  SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'لا توجد فواتير',
                        style: TextStyle(
                          color: const Color(0xff8A8F99),
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  )

                // List
                else
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          if (index == state.items.length - 1) {
                            context
                                .read<InvoicesBloc>()
                                .add(const LoadMoreInvoices());
                          }
                          final invoice = state.items[index];
                          return InvoiceCard(
                            invoice: invoice,
                            onDelete: () => context
                                .read<InvoicesBloc>()
                                .add(DeleteInvoice(invoice.invoiceId)),
                            onEdit:  () {},
                            onPrint: () {},
                            onView:  () {},
                          );
                        },
                        childCount: state.items.length,
                      ),
                    ),
                  ),

              // Load more indicator
              if (state.status == Status.isLoadingMore)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.h),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),

              SliverToBoxAdapter(child: SizedBox(height: 20.h)),
            ],
          );
        },
      ),
    );
  }
}




class _InvoiceSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const _InvoiceSearchBar({required this.onChanged});

  @override
  State<_InvoiceSearchBar> createState() => _InvoiceSearchBarState();
}

class _InvoiceSearchBarState extends State<_InvoiceSearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        textAlign: TextAlign.right,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: 'بحث برقم الفاتورة أو اسم العميل...',
          hintStyle: TextStyle(
            color: const Color(0xff8A8F99),
            fontSize: 13.sp,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: const Color(0xff8A8F99),
            size: 22.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
        ),
      ),
    );
  }
}