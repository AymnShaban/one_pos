part of '../../live_sales_report_imports.dart';

/// Live-sales report — filters (branches / options / date range) on top,
/// results below. Self-provides [BranchBloc] + [LiveSalesReportBloc] so
/// it can be pushed as a route directly from the home dashboard with no
/// upstream wiring.
class LiveSalesReportScreen extends StatelessWidget {
  const LiveSalesReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BranchBloc>(
          create: (_) => GetIt.instance<BranchBloc>(),
        ),
        BlocProvider<LiveSalesReportBloc>(
          create: (_) => GetIt.instance<LiveSalesReportBloc>(),
        ),
        BlocProvider<DelegateBloc>(
          create: (_) => GetIt.instance<DelegateBloc>(),
        ),
      ],
      child: const _LiveSalesReportView(),
    );
  }
}

class _LiveSalesReportView extends StatefulWidget {
  const _LiveSalesReportView();

  @override
  State<_LiveSalesReportView> createState() => _LiveSalesReportViewState();
}

class _LiveSalesReportViewState extends State<_LiveSalesReportView> {
  late DateTime _fromDate;
  late DateTime _toDate;

  // Tracks selected branch ids as a set so toggles are O(1). Starts empty —
  // the user picks the branches they need.
  final Set<int> _selectedBranchIds = {};

  // Same idea as branches, but empty/all-selected both mean "every seller"
  // (matches SalesMovementsReportRequest.allSalesManChecked defaulting true).
  final Set<int> _selectedDelegateIds = {};

  // Report-option checkboxes — all off by default; the user opts in.
  // (The "show by seller" flag is now implicit — the sellers card is the
  // control surface for it, so we always request the by-seller breakdown
  // when this screen is used.)
  bool _showByBranchCurrency = false;
  bool _showWeight = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _fromDate = DateTime(now.year, now.month, now.day);
    _toDate = _fromDate;

    // Lazy-load the branch list from this screen's initState — same
    // pattern Sales tab uses.
    context.read<BranchBloc>().add(const LoadBranches());
    context.read<DelegateBloc>().add(const LoadDelegates());
  }

  // ─────────────────────────────────────────────────────────────────────
  //  Branch selection helpers
  // ─────────────────────────────────────────────────────────────────────
  void _selectAllBranches(List<BranchModel> all) {
    setState(() {
      _selectedBranchIds
        ..clear()
        ..addAll(all.map((b) => b.branchId));
    });
  }

  void _toggleBranch(int id) {
    setState(() {
      if (_selectedBranchIds.contains(id)) {
        _selectedBranchIds.remove(id);
      } else {
        _selectedBranchIds.add(id);
      }
    });
  }

  bool _isAllSelected(List<BranchModel> all) =>
      all.isNotEmpty && _selectedBranchIds.length == all.length;

  // ─────────────────────────────────────────────────────────────────────
  //  Delegate (seller) selection helpers
  // ─────────────────────────────────────────────────────────────────────
  void _selectAllDelegates(List<DelegateModel> all) {
    setState(() {
      _selectedDelegateIds
        ..clear()
        ..addAll(all.map((d) => d.empId));
    });
  }

  void _toggleDelegate(int id) {
    setState(() {
      if (_selectedDelegateIds.contains(id)) {
        _selectedDelegateIds.remove(id);
      } else {
        _selectedDelegateIds.add(id);
      }
    });
  }

  bool _isAllDelegatesSelected(List<DelegateModel> all) =>
      all.isNotEmpty && _selectedDelegateIds.length == all.length;

  // ─────────────────────────────────────────────────────────────────────
  //  Submit
  // ─────────────────────────────────────────────────────────────────────
  void _preview(BuildContext context) {
    if (_selectedBranchIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'live_sales_report.select_at_least_one_branch'.tr()),
        ),
      );
      return;
    }
    final all = context.read<BranchBloc>().state.items;

    final allDelegates = context.read<DelegateBloc>().state.items;
    final allSellersSelected = _selectedDelegateIds.isEmpty ||
        _selectedDelegateIds.length == allDelegates.length;
    // Server 400s with "NoSpecificSalesman" when `selectedDelegateDtos` is
    // empty — even when `chk_AllSalesManChecked: true` is set. Always send
    // the full id list, whether the user tapped "All" or picked rows.
    final delegateIdsToSend = allSellersSelected
        ? allDelegates.map((d) => d.empId).toList()
        : _selectedDelegateIds.toList();

    context.read<LiveSalesReportBloc>().add(
          LoadLiveSalesReport(
            fromDate: _fromDate,
            toDate: _toDate,
            branchIds: _selectedBranchIds.toList(),
            delegateIds: delegateIdsToSend,
            allBranchesChecked: _isAllSelected(all),
            allSalesManChecked: allSellersSelected,
            // The former "show by seller" report-option has been folded
            // into the sellers card; requesting this screen implies
            // wanting the by-seller breakdown.
            showSalesManChecked: true,
            weightChecked: _showWeight,
            showByBranchCurrencyChecked: _showByBranchCurrency,
            cultureName: context.locale.languageCode,
          ),
        );
  }

  // ─────────────────────────────────────────────────────────────────────
  //  Build
  // ─────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F2F8),
      appBar: AppBar(
        backgroundColor: const Color(0xff3B5BDB),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text(
          'live_sales_report.title'.tr(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _BranchesCard(
              selectedIds: _selectedBranchIds,
              isAllSelected: _isAllSelected,
              onSelectAll: _selectAllBranches,
              onToggle: _toggleBranch,
            ),
            SizedBox(height: 12.h),
            _DelegatesCard(
              selectedIds: _selectedDelegateIds,
              isAllSelected: _isAllDelegatesSelected,
              onSelectAll: _selectAllDelegates,
              onToggle: _toggleDelegate,
            ),
            SizedBox(height: 12.h),
            _OptionsCard(
              showInBranchCurrency: _showByBranchCurrency,
              showWeight: _showWeight,
              onChanged: (kind, value) => setState(() {
                switch (kind) {
                  case _OptionKind.branchCurrency:
                    _showByBranchCurrency = value;
                  case _OptionKind.weight:
                    _showWeight = value;
                }
              }),
            ),
            SizedBox(height: 12.h),
            _DateRangeCard(
              fromDate: _fromDate,
              toDate: _toDate,
              onFromPicked: (d) => setState(() => _fromDate = d),
              onToPicked: (d) => setState(() => _toDate = d),
              onPreview: () => _preview(context),
            ),
            SizedBox(height: 16.h),
            const _ResultsSection(),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────
//  Branches card
// ────────────────────────────────────────────────────────────────────────
class _BranchesCard extends StatelessWidget {
  final Set<int> selectedIds;
  final bool Function(List<BranchModel>) isAllSelected;
  final void Function(List<BranchModel>) onSelectAll;
  final void Function(int) onToggle;

  const _BranchesCard({
    required this.selectedIds,
    required this.isAllSelected,
    required this.onSelectAll,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';
    return _SectionCard(
      title: 'live_sales_report.branches'.tr(),
      child: BlocBuilder<BranchBloc, BaseState<BranchModel>>(
        builder: (context, bs) {
          if (bs.status == Status.loading) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: const Center(child: CircularProgressIndicator()),
            );
          }
          if (bs.status == Status.failure) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Text(
                bs.errorMessage ?? 'common.error'.tr(),
                style: TextStyle(color: Colors.red, fontSize: 12.sp),
              ),
            );
          }
          final all = bs.items;
          return Column(
            children: [
              _CheckRow(
                label: 'live_sales_report.all'.tr(),
                value: isAllSelected(all),
                onChanged: (v) {
                  if (v == true) {
                    onSelectAll(all);
                  } else {
                    // Untick "All" → clear the selection.
                    onSelectAll(const []);
                  }
                },
              ),
              ...all.map(
                (b) => _CheckRow(
                  label: isAr ? b.branchArName : b.branchEnName,
                  value: selectedIds.contains(b.branchId),
                  onChanged: (_) => onToggle(b.branchId),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────
//  Delegates (sellers) card
// ────────────────────────────────────────────────────────────────────────
class _DelegatesCard extends StatelessWidget {
  final Set<int> selectedIds;
  final bool Function(List<DelegateModel>) isAllSelected;
  final void Function(List<DelegateModel>) onSelectAll;
  final void Function(int) onToggle;

  const _DelegatesCard({
    required this.selectedIds,
    required this.isAllSelected,
    required this.onSelectAll,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'live_sales_report.show_by_seller'.tr(),
      child: BlocBuilder<DelegateBloc, BaseState<DelegateModel>>(
        builder: (context, ds) {
          if (ds.status == Status.loading) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: const Center(child: CircularProgressIndicator()),
            );
          }
          if (ds.status == Status.failure) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Text(
                ds.errorMessage ?? 'common.error'.tr(),
                style: TextStyle(color: Colors.red, fontSize: 12.sp),
              ),
            );
          }
          final all = ds.items;
          return Column(
            children: [
              _CheckRow(
                label: 'live_sales_report.all'.tr(),
                value: isAllSelected(all),
                onChanged: (v) {
                  if (v == true) {
                    onSelectAll(all);
                  } else {
                    // Untick "All" → clear the selection.
                    onSelectAll(const []);
                  }
                },
              ),
              ...all.map(
                (d) => _CheckRow(
                  label: d.empName,
                  value: selectedIds.contains(d.empId),
                  onChanged: (_) => onToggle(d.empId),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────
//  Report-options card
// ────────────────────────────────────────────────────────────────────────
enum _OptionKind { branchCurrency, weight }

class _OptionsCard extends StatelessWidget {
  final bool showInBranchCurrency;
  final bool showWeight;
  final void Function(_OptionKind kind, bool value) onChanged;

  const _OptionsCard({
    required this.showInBranchCurrency,
    required this.showWeight,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'live_sales_report.report_options'.tr(),
      child: Column(
        children: [
          _CheckRow(
            label: 'live_sales_report.show_in_branch_currency'.tr(),
            value: showInBranchCurrency,
            onChanged: (v) => onChanged(_OptionKind.branchCurrency, v ?? false),
          ),
          _CheckRow(
            label: 'live_sales_report.show_weight'.tr(),
            value: showWeight,
            onChanged: (v) => onChanged(_OptionKind.weight, v ?? false),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────
//  Date range + preview button
// ────────────────────────────────────────────────────────────────────────
class _DateRangeCard extends StatelessWidget {
  final DateTime fromDate;
  final DateTime toDate;
  final void Function(DateTime) onFromPicked;
  final void Function(DateTime) onToPicked;
  final VoidCallback onPreview;

  const _DateRangeCard({
    required this.fromDate,
    required this.toDate,
    required this.onFromPicked,
    required this.onToPicked,
    required this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: null,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _DateField(
                  label: 'live_sales_report.from_date'.tr(),
                  value: fromDate,
                  onPicked: onFromPicked,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _DateField(
                  label: 'live_sales_report.to_date'.tr(),
                  value: toDate,
                  onPicked: onToPicked,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onPreview,
              icon: const Icon(Icons.search, color: Colors.white, size: 18),
              label: Text(
                'live_sales_report.preview'.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff3B5BDB),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final DateTime value;
  final void Function(DateTime) onPicked;

  const _DateField({
    required this.label,
    required this.value,
    required this.onPicked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xff8A8F99),
            )),
        SizedBox(height: 4.h),
        InkWell(
          borderRadius: BorderRadius.circular(8.r),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: value,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) onPicked(picked);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.grey.shade300),
              color: Colors.white,
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 16, color: Color(0xff8A8F99)),
                SizedBox(width: 6.w),
                Text(
                  '${value.year}/'
                  '${value.month.toString().padLeft(2, '0')}/'
                  '${value.day.toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 13.sp, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ────────────────────────────────────────────────────────────────────────
//  Results section
// ────────────────────────────────────────────────────────────────────────
class _ResultsSection extends StatelessWidget {
  const _ResultsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LiveSalesReportBloc, BaseState<SalesMovementsReportPage>>(
      builder: (context, state) {
        switch (state.status) {
          case Status.loading:
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 32.h),
              child: const Center(child: CircularProgressIndicator()),
            );
          case Status.failure:
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Center(
                child: Text(
                  state.errorMessage ?? 'common.error'.tr(),
                  style: TextStyle(color: Colors.red, fontSize: 13.sp),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          case Status.success:
            if (state.items.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: Center(
                  child: Text(
                    'live_sales_report.no_results'.tr(),
                    style: TextStyle(
                        color: const Color(0xff8A8F99), fontSize: 13.sp),
                  ),
                ),
              );
            }
            // The API appends a grand-total page (no branch title, no
            // rows — only the sums). Its data is already covered by the
            // summary cards on top, so drop it from the branch list and
            // from the totals math (it would double-count otherwise).
            final branchPages = state.items
                .where((p) =>
                    p.cardHeaderText.isNotEmpty || p.rows.isNotEmpty)
                .toList();
            final pagesForTotals =
                branchPages.isNotEmpty ? branchPages : state.items;
            return Column(
              children: [
                _SummaryCards(pages: pagesForTotals),
                SizedBox(height: 16.h),
                ...branchPages.map((p) => Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: _ReportPageCard(page: p),
                    )),
              ],
            );
          case Status.initial:
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}

// ────────────────────────────────────────────────────────────────────────
//  Number helpers — server sends pre-formatted strings ("3,101.203"),
//  so grand totals are re-parsed / re-formatted locally.
// ────────────────────────────────────────────────────────────────────────
double? _parseNum(String s) {
  final cleaned = s.replaceAll(',', '').replaceAll('%', '').trim();
  if (cleaned.isEmpty) return null;
  return double.tryParse(cleaned);
}

String _formatNum(double v, {int decimals = 3}) {
  final neg = v < 0;
  final parts = v.abs().toStringAsFixed(decimals).split('.');
  final intPart = parts[0];
  final buf = StringBuffer();
  for (int i = 0; i < intPart.length; i++) {
    buf.write(intPart[i]);
    final remaining = intPart.length - 1 - i;
    if (remaining > 0 && remaining % 3 == 0) buf.write(',');
  }
  final decimalsPart = decimals > 0 ? '.${parts[1]}' : '';
  return '${neg ? '-' : ''}$buf$decimalsPart';
}

// ────────────────────────────────────────────────────────────────────────
//  Grand-total summary cards (value / cost / profit / qty / ratios)
// ────────────────────────────────────────────────────────────────────────
class _SummaryCards extends StatelessWidget {
  final List<SalesMovementsReportPage> pages;

  const _SummaryCards({required this.pages});

  @override
  Widget build(BuildContext context) {
    double sumOf(String Function(SalesMovementsReportPage) pick) =>
        pages.fold(0.0, (acc, p) => acc + (_parseNum(pick(p)) ?? 0));

    final totalValue = sumOf((p) => p.sumFinalValue);
    final totalCost = sumOf((p) => p.sumBliCost);
    final totalProfit = sumOf((p) => p.sumProfit);
    final totalQty = sumOf((p) => p.sumQty);
    final profitRatio = totalValue == 0 ? 0.0 : totalProfit / totalValue * 100;
    final profitOfCost = totalCost == 0 ? 0.0 : totalProfit / totalCost * 100;

    final cards = <_SummaryCardData>[
      _SummaryCardData(
        label: 'live_sales_report.total_value'.tr(),
        value: _formatNum(totalValue),
        icon: Icons.payments_rounded,
        gradient: const [Color(0xff2E9E4F), Color(0xff5BC272)],
      ),
      _SummaryCardData(
        label: 'live_sales_report.total_cost'.tr(),
        value: _formatNum(totalCost),
        icon: Icons.account_balance_wallet_rounded,
        gradient: const [Color(0xffD63B3B), Color(0xffE96A6A)],
      ),
      _SummaryCardData(
        label: 'live_sales_report.total_profit'.tr(),
        value: _formatNum(totalProfit),
        icon: Icons.show_chart_rounded,
        gradient: const [Color(0xffEF8D1E), Color(0xffF5AE4F)],
      ),
      _SummaryCardData(
        label: 'live_sales_report.total_qty'.tr(),
        value: _formatNum(totalQty),
        icon: Icons.view_in_ar_rounded,
        gradient: const [Color(0xff1F63D6), Color(0xff4E8BEF)],
      ),
      _SummaryCardData(
        label: 'live_sales_report.profit_ratio'.tr(),
        value: '${_formatNum(profitRatio)}%',
        icon: Icons.percent_rounded,
        gradient: const [Color(0xff5A5F68), Color(0xff7C828C)],
      ),
      _SummaryCardData(
        label: 'live_sales_report.profit_of_cost_ratio'.tr(),
        value: '${_formatNum(profitOfCost)}%',
        icon: Icons.percent_rounded,
        gradient: const [Color(0xff23272F), Color(0xff3A4049)],
      ),
    ];

    return Column(
      children: [
        for (final c in cards)
          Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: _SummaryCard(data: c),
          ),
      ],
    );
  }
}

class _SummaryCardData {
  final String label;
  final String value;
  final IconData icon;
  final List<Color> gradient;

  const _SummaryCardData({
    required this.label,
    required this.value,
    required this.icon,
    required this.gradient,
  });
}

class _SummaryCard extends StatelessWidget {
  final _SummaryCardData data;

  const _SummaryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        gradient: LinearGradient(
          colors: data.gradient,
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        boxShadow: [
          BoxShadow(
            color: data.gradient.first.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(data.icon, color: Colors.white, size: 24.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.label,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  data.value,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────
//  Per-branch report card — navy gradient shell, stat chips, invoice
//  table, payment-method chips.
// ────────────────────────────────────────────────────────────────────────
class _ReportPageCard extends StatelessWidget {
  final SalesMovementsReportPage page;

  const _ReportPageCard({required this.page});

  @override
  Widget build(BuildContext context) {
    final stats = <(String, String)>[
      ('live_sales_report.value'.tr(), page.sumFinalValue),
      ('live_sales_report.sum_cost'.tr(), page.sumBliCost),
      ('live_sales_report.sum_profit'.tr(), page.sumProfit),
      ('live_sales_report.qty'.tr(), page.sumQty),
      ('live_sales_report.sum_profit_ratio'.tr(), page.sumProfitRatio),
      ('live_sales_report.sum_cost_ratio'.tr(), page.sumBliCostRatio),
    ].where((e) => e.$2.isNotEmpty).toList();

    return Container(
      constraints: BoxConstraints(maxHeight: 480.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        gradient: const LinearGradient(
          colors: [Color(0xff16307E), Color(0xff2B4CC0)],
          begin: AlignmentDirectional.topCenter,
          end: AlignmentDirectional.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff16307E).withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // Cap the card and let the whole shell (header + stats + inner white
      // panel) scroll as one when a branch has enough invoice rows to blow
      // past the cap. Keeps every card the same visual height regardless
      // of how many rows it holds.
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          if (page.cardHeaderText.isNotEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 14.h, 12.w, 4.h),
              child: Text(
                page.cardHeaderText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          if (stats.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              child: Row(
                children: [
                  for (final s in stats) ...[
                    _HeaderStatChip(label: s.$1, value: s.$2),
                    SizedBox(width: 6.w),
                  ],
                ],
              ),
            ),
          if (page.rows.isNotEmpty ||
              page.paymentMethods.trim().isNotEmpty ||
              page.cardFooterText.isNotEmpty)
            Container(
              margin: EdgeInsets.fromLTRB(6.w, 2.h, 6.w, 6.h),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (page.rows.isNotEmpty) _RowsTable(page: page),
                  _PaymentMethodChips(raw: page.paymentMethods),
                  // cardFooterText is just a text dump of the payment
                  // methods — only show it when there are no chips.
                  if (page.cardFooterText.isNotEmpty &&
                      page.paymentMethods.trim().isEmpty)
                    Padding(
                      padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 10.h),
                      child: Text(
                        page.cardFooterText,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: const Color(0xff8A8F99),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small translucent stat chip inside the navy card header.
class _HeaderStatChip extends StatelessWidget {
  final String label;
  final String value;

  const _HeaderStatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _RowsTable extends StatelessWidget {
  final SalesMovementsReportPage page;

  const _RowsTable({required this.page});

  @override
  Widget build(BuildContext context) {
    final qtyLabel =  'live_sales_report.qty'.tr();
    final valLabel = 'live_sales_report.value'.tr();

    TextStyle headerStyle = TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.bold,
      color: const Color(0xff1A2B5C),
    );
    TextStyle cellStyle = TextStyle(
      fontSize: 12.sp,
      color: const Color(0xff1A1A1A),
    );

    return Column(
      children: [
        // Header row
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: const Color(0xffEDF1FA),
            borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'live_sales_report.invoice'.tr(),
                  style: headerStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(qtyLabel,
                    style: headerStyle, textAlign: TextAlign.center),
              ),
              Expanded(
                child: Text(valLabel,
                    style: headerStyle, textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
        ...page.rows.asMap().entries.map(
          (entry) => Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
            color: entry.key.isEven
                ? const Color(0xffF5F6FA)
                : Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Text(entry.value.blNo,
                      style: cellStyle, textAlign: TextAlign.center),
                ),
                Expanded(
                  child: Text(entry.value.qty,
                      style: cellStyle, textAlign: TextAlign.center),
                ),
                Expanded(
                  child: Text(entry.value.finalValue,
                      style: cellStyle, textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Payment-methods footer — the server sends one pre-formatted string;
/// split it into "label + amount" chips, falling back to a single chip
/// when the format doesn't match.
class _PaymentMethodChips extends StatelessWidget {
  final String raw;

  const _PaymentMethodChips({required this.raw});

  static final _trailingNumber =
      RegExp(r'^(.*?)[\s:،]*(-?[\d,]+(?:\.\d+)?)\s*$');

  List<(String, String)> _parse() {
    final tokens = raw
        .split(RegExp(r'[\n|;،]+'))
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();
    return tokens.map((t) {
      final m = _trailingNumber.firstMatch(t);
      if (m != null && m.group(1)!.trim().isNotEmpty) {
        return (m.group(1)!.trim().replaceAll(RegExp(r'[:\s]+$'), ''),
            m.group(2)!);
      }
      return ('', t);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (raw.trim().isEmpty) return const SizedBox.shrink();
    final methods = _parse();
    return Padding(
      padding: EdgeInsets.all(10.w),
      child: Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        alignment: WrapAlignment.center,
        children: [
          for (final m in methods)
            Container(
              constraints: BoxConstraints(minWidth: 90.w),
              padding:
                  EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xffE9EFFF),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xffD4DEF8)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (m.$1.isNotEmpty)
                    Text(
                      m.$1,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: const Color(0xff6B7A99),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  if (m.$1.isNotEmpty) SizedBox(height: 2.h),
                  Text(
                    m.$2,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff1A2B5C),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────
//  Reusable bits
// ────────────────────────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String? title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null)
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xff3B5BDB).withValues(alpha: 0.08),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12.r),
                ),
              ),
              child: Text(
                title!,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff1A1A1A),
                ),
              ),
            ),
          Padding(padding: EdgeInsets.all(12.w), child: child),
        ],
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _CheckRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(6.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          children: [
            SizedBox(
              width: 20.w,
              height: 20.w,
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeColor: const Color(0xff3B5BDB),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xff1A1A1A),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
