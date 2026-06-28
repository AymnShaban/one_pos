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

  // Tracks selected branch ids as a set so toggles are O(1). Populated
  // (all branches selected) on the first BranchBloc success emission via
  // a BlocListener — until then it's empty.
  final Set<int> _selectedBranchIds = {};
  bool _initialBranchSelectionDone = false;

  // Report-option checkboxes — defaults match the example body the server
  // accepted (everything on).
  bool _showByBranchCurrency = true;
  bool _showBySeller = true;
  bool _showWeight = true;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _fromDate = DateTime(now.year, now.month, now.day);
    _toDate = _fromDate;

    // Lazy-load the branch list from this screen's initState — same
    // pattern Sales tab uses.
    context.read<BranchBloc>().add(const LoadBranches());
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
    context.read<LiveSalesReportBloc>().add(
          LoadLiveSalesReport(
            fromDate: _fromDate,
            toDate: _toDate,
            branchIds: _selectedBranchIds.toList(),
            allBranchesChecked: _isAllSelected(all),
            showSalesManChecked: _showBySeller,
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
      body: BlocListener<BranchBloc, BaseState<BranchModel>>(
        // Auto-select every branch the first time the list lands — mirrors
        // the "الكل" default check in the screenshot.
        listenWhen: (p, c) =>
            !_initialBranchSelectionDone &&
            p.status != Status.success &&
            c.status == Status.success,
        listener: (context, bs) {
          _initialBranchSelectionDone = true;
          _selectAllBranches(bs.items);
        },
        child: SingleChildScrollView(
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
              _OptionsCard(
                showInBranchCurrency: _showByBranchCurrency,
                showBySeller: _showBySeller,
                showWeight: _showWeight,
                onChanged: (kind, value) => setState(() {
                  switch (kind) {
                    case _OptionKind.branchCurrency:
                      _showByBranchCurrency = value;
                    case _OptionKind.bySeller:
                      _showBySeller = value;
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
//  Report-options card
// ────────────────────────────────────────────────────────────────────────
enum _OptionKind { branchCurrency, bySeller, weight }

class _OptionsCard extends StatelessWidget {
  final bool showInBranchCurrency;
  final bool showBySeller;
  final bool showWeight;
  final void Function(_OptionKind kind, bool value) onChanged;

  const _OptionsCard({
    required this.showInBranchCurrency,
    required this.showBySeller,
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
            label: 'live_sales_report.show_by_seller'.tr(),
            value: showBySeller,
            onChanged: (v) => onChanged(_OptionKind.bySeller, v ?? false),
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
            return Column(
              children: state.items
                  .map((p) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: _ReportPageCard(page: p),
                      ))
                  .toList(),
            );
          case Status.initial:
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}

class _ReportPageCard extends StatelessWidget {
  final SalesMovementsReportPage page;

  const _ReportPageCard({required this.page});

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
          if (page.cardHeaderText.isNotEmpty)
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: const Color(0xff3B5BDB).withValues(alpha: 0.08),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12.r),
                ),
              ),
              child: Text(
                page.cardHeaderText,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff1A1A1A),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (page.rows.isNotEmpty) _RowsTable(page: page),
                if (page.rows.isNotEmpty) SizedBox(height: 12.h),
                _Sums(page: page),
                if (page.paymentMethods.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  _LabelValue(
                    label: 'live_sales_report.payment_methods'.tr(),
                    value: page.paymentMethods,
                  ),
                ],
                if (page.cardFooterText.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Text(
                    page.cardFooterText,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: const Color(0xff8A8F99),
                    ),
                  ),
                ],
              ],
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
    final qtyLabel = page.lblQty.isNotEmpty
        ? page.lblQty
        : 'live_sales_report.qty'.tr();
    final valLabel = page.lblVal.isNotEmpty
        ? page.lblVal
        : 'live_sales_report.value'.tr();
    return Column(
      children: [
        // Header row
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: const Color(0xffF0F2F8),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'live_sales_report.invoice_no'.tr(),
                  style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff1A1A1A)),
                ),
              ),
              Expanded(
                child: Text(
                  qtyLabel,
                  style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff1A1A1A)),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  valLabel,
                  style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff1A1A1A)),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
        ...page.rows.map(
          (r) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    r.blNo,
                    style: TextStyle(fontSize: 11.sp),
                  ),
                ),
                Expanded(
                  child: Text(
                    r.qty,
                    style: TextStyle(fontSize: 11.sp),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    r.finalValue,
                    style: TextStyle(fontSize: 11.sp),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Sums extends StatelessWidget {
  final SalesMovementsReportPage page;
  const _Sums({required this.page});

  @override
  Widget build(BuildContext context) {
    // Skip rendering empty / "0"-style server values so the card stays tidy
    // when the report only fills a subset of the sums.
    final entries = <(String, String)>[
      ('live_sales_report.sum_qty'.tr(), page.sumQty),
      ('live_sales_report.sum_final_value'.tr(), page.sumFinalValue),
      ('live_sales_report.sum_cost'.tr(), page.sumBliCost),
      ('live_sales_report.sum_profit'.tr(), page.sumProfit),
      ('live_sales_report.sum_profit_ratio'.tr(), page.sumProfitRatio),
      ('live_sales_report.sum_cost_ratio'.tr(), page.sumBliCostRatio),
    ].where((e) => e.$2.isNotEmpty).toList();

    if (entries.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 12.w,
      runSpacing: 8.h,
      children: entries
          .map((e) => _LabelValue(label: e.$1, value: e.$2))
          .toList(),
    );
  }
}

class _LabelValue extends StatelessWidget {
  final String label;
  final String value;

  const _LabelValue({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xffF7F9FC),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 11.sp,
              color: const Color(0xff8A8F99),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xff1A1A1A),
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
