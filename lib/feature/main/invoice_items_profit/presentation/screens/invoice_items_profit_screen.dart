import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/theme/app_text_theme.dart';
import '../../../../../core/widgets/data/app_date_range_picker.dart';
import '../../data/models/branch_model.dart';
import '../../data/models/profit_item_model.dart' show ProfitItemModel;
import '../widgets/widgets.dart';

class InvoiceItemsProfitScreen extends StatefulWidget {
  const InvoiceItemsProfitScreen({super.key});

  @override
  State<InvoiceItemsProfitScreen> createState() => _ProfitInquiryScreenState();
}

class _ProfitInquiryScreenState extends State<InvoiceItemsProfitScreen> {

  final Map<String, bool> _openSections = {
    'date': false,
    'price': false,
    'display': false,
    'branches': false,
    'cost': false,
  };

  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();


  String _costPriceLabel = 'السعر';
  String _salePriceLabel = 'السعر';


  bool _showReturns = false;
  bool _hideCustomerOffer = false;
  bool _customerBranch = false;

  List<BranchModel> _branches = const [
    BranchModel(id: 1, name: 'الفرع الرئيسي', isSelected: true),
    BranchModel(id: 2, name: 'فرع تجربة', isSelected: true),
    BranchModel(id: 3, name: 'تيست 1', isSelected: true),
    BranchModel(id: 4, name: 'تيست 2', isSelected: true),
  ];


  bool _optionsHidden = false;
  bool _isRefreshing = false;
  int _visibleItemsCount = 4;
  static const String _currencyLabel = 'د.ك';
  static const int _invoicesCount = 128;

  static const List<ProfitItemModel> _allItems = [
    ProfitItemModel(name: 'أرز بسمتي 5 كجم', soldQuantity: 84, cost: 315, sales: 508),
    ProfitItemModel(name: 'زيت عباد الشمس 1.5 لتر', soldQuantity: 156, cost: 612, sales: 756),
    ProfitItemModel(name: 'لبن طازج 1 لتر', soldQuantity: 240, cost: 288, sales: 306),
    ProfitItemModel(name: 'شامبو للشعر الجاف 400 مل', soldQuantity: 62, cost: 217, sales: 368),
    ProfitItemModel(name: 'معجون أسنان 100 مل', soldQuantity: 120, cost: 180, sales: 264),
    ProfitItemModel(name: 'عصير برتقال 1 لتر', soldQuantity: 98, cost: 156, sales: 245),
    ProfitItemModel(name: 'مسحوق غسيل 3 كجم', soldQuantity: 40, cost: 320, sales: 410),
    ProfitItemModel(name: 'شاي أحمر 100 كيس', soldQuantity: 75, cost: 140, sales: 230),
  ];

  List<ProfitItemModel> get _visibleItems =>
      _allItems.take(_visibleItemsCount).toList();

  double get _totalSales =>
      _allItems.fold(0, (sum, item) => sum + item.sales);
  double get _totalCost => _allItems.fold(0, (sum, item) => sum + item.cost);

  void _toggleSection(String key) {
    setState(() => _openSections[key] = !(_openSections[key] ?? false));
  }

  void _toggleBranch(BranchModel branch) {
    setState(() {
      _branches = [
        for (final b in _branches)
          if (b.id == branch.id) b.copyWith(isSelected: !b.isSelected) else b,
      ];
    });
  }

  void _toggleAllBranches(bool selectAll) {
    setState(() {
      _branches = [
        for (final b in _branches) b.copyWith(isSelected: selectAll),
      ];
    });
  }

  Future<void> _refreshResults() async {
    setState(() => _isRefreshing = true);

    await Future.delayed(const Duration(milliseconds: 700));
    if (mounted) setState(() => _isRefreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        
        backgroundColor:  AppColors.mainAppColor,
        leading:   InkWell(
          onTap:(){
            Navigator.pop(context);
          },
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            margin: EdgeInsets.all(8),
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.arrow_back, color: Colors.white, size: 16.sp),
          ),
        ),
        scrolledUnderElevation: 0,
        centerTitle: true,
        title:
        Text(
          'أرباح أصناف الفواتير',
          textAlign: TextAlign.center,
          style: AppTextTheme.titleSmallBold.copyWith(
            color: AppColors.whiteColor,
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!_optionsHidden) ...[
                      ExpandableSectionCard(
                        icon: Icons.calendar_today_outlined,
                        title: 'time_period'.tr(),
                        meta: '${_fmtShortDate(_fromDate)} → ${_fmtShortDate(_toDate)}',
                        isOpen: _openSections['date']!,
                        onToggle: () => _toggleSection('date'),
                        child: AppDateRangePicker(
                          fromDate: _fromDate,
                          toDate: _toDate,
                          onFromDateChanged: (d) {
                            setState(() => _fromDate = d);
                          },
                          onToDateChanged: (d) {
                            setState(() => _toDate = d);
                          },
                        ),
                      ),
                      SizedBox(height: 12.h),
                      ExpandableSectionCard(
                        icon: Icons.sell_outlined,
                        title: 'أساس الأسعار',
                        meta: 'سعر التكلفة والبيع',
                        isOpen: _openSections['price']!,
                        onToggle: () => _toggleSection('price'),
                        child: PriceBasisSection(
                          costPriceLabel: _costPriceLabel,
                          salePriceLabel: _salePriceLabel,
                          onTapCostPrice: () {
                            // TODO: open the real cost-price basis picker,
                            // then setState(() => _costPriceLabel = picked).
                          },
                          onTapSalePrice: () {
                            // TODO: open the real sale-price basis picker,
                            // then setState(() => _salePriceLabel = picked).
                          },
                        ),
                      ),
                      SizedBox(height: 12.h),
                      ExpandableSectionCard(
                        icon: Icons.tune,
                        title: 'خيارات العرض',
                        meta: 'المرتجعات وعرض العميل',
                        isOpen: _openSections['display']!,
                        onToggle: () => _toggleSection('display'),
                        child: DisplayOptionsSection(
                          showReturns: _showReturns,
                          onShowReturnsChanged: (v) =>
                              setState(() => _showReturns = v),
                          hideCustomerOffer: _hideCustomerOffer,
                          onHideCustomerOfferChanged: (v) =>
                              setState(() => _hideCustomerOffer = v),
                          customerBranch: _customerBranch,
                          onCustomerBranchChanged: (v) =>
                              setState(() => _customerBranch = v),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      ExpandableSectionCard(
                        icon: Icons.apartment,
                        title: 'فروع الشركة',
                        meta:
                            '${_branches.where((b) => b.isSelected).length} فروع محددة',
                        isOpen: _openSections['branches']!,
                        onToggle: () => _toggleSection('branches'),
                        child: BranchesSection(
                          branches: _branches,
                          onToggleBranch: _toggleBranch,
                          onToggleAll: _toggleAllBranches,
                        ),
                      ),
                      SizedBox(height: 12.h),


                    ],
                    ProfitSummaryCard(
                      itemsCount: _allItems.length,
                      invoicesCount: _invoicesCount,
                    ),
                    SizedBox(height: 12.h),
                    ProfitStatsRow(
                      totalSales: _totalSales,
                      totalCost: _totalCost,
                      currencyLabel: _currencyLabel,
                    ),
                    SizedBox(height: 12.h),
                    ResultsToolbar(
                      onSort: () {

                      },
                    ),
                    SizedBox(height: 10.h),
                    for (final item in _visibleItems) ...[
                      ProfitItemCard(item: item, currencyLabel: _currencyLabel),
                      SizedBox(height: 10.h),
                    ],
                    if (_visibleItemsCount < _allItems.length)
                      LoadMoreButton(
                        remainingCount: _allItems.length - _visibleItemsCount,
                        onTap: () {
                          setState(() {
                            _visibleItemsCount =
                                (_visibleItemsCount + 4).clamp(
                              0,
                              _allItems.length,
                            );
                          });
                        },
                      ),
                    SizedBox(height: 90.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: RefreshFooterButton(
        onPressed: _refreshResults,
        isLoading: _isRefreshing,
      ),
    );
  }

  String _fmtShortDate(DateTime d) => '${d.day}/${d.month}/${d.year}';
}
