

import 'package:easy_localization/easy_localization.dart';

import '../../../../../../core/services/service_locator/services_imports.dart';
import '../../../shared/widget/loading_overlay.dart';
import '../../item_profit_import.dart';

import '../widget/bootom_bar.dart';

import '../widget/filter_content_widget.dart';

class ItemProfitScreen extends StatelessWidget {
  const ItemProfitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BranchesBloc>(
          create: (_) => BranchesBloc(
            dataSource: getIt<BranchesDataSource>(),
          )..add(LoadBranches()),
        ),
        BlocProvider<ItemProfitBloc>(
          create: (_) => ItemProfitBloc(
            dataSource: getIt<ItemProfitDataSource>(),
          ),
        ),
      ],
      child: const ItemProfitFiltersScreen(),
    );
  }
}


class ItemProfitFiltersScreen extends StatefulWidget {
  const ItemProfitFiltersScreen({super.key});

  @override
  State<ItemProfitFiltersScreen> createState() =>
      _ItemProfitFiltersScreenState();
}

class _ItemProfitFiltersScreenState extends State<ItemProfitFiltersScreen> {
  final now = DateTime.now();

  late DateTime fromDate = DateTime.now();
  late DateTime toDate = DateTime.now();
  bool costZero = false;
  bool costEqualsSale = false;
  bool costGreaterThanSale = false;
  bool showReturns = false;
  bool hideClient = false;
  bool clientBranch = false;

  PriceTypeModel salePrice = priceTypes.first;
  PriceTypeModel costPrice = priceTypes.first;

  bool _isLoading = false;

  void _resetFilters() {
    if (_isLoading) return;
    setState(() {

      fromDate = DateTime.now();
      toDate = DateTime.now();
      costZero = false;
      costEqualsSale = false;
      costGreaterThanSale = false;
      showReturns = false;
      hideClient = false;
      clientBranch = false;
      salePrice = priceTypes.first;
      costPrice = priceTypes.first;
    });
  }

  void _applyFilters() {
    if (_isLoading) return;

    final branchState = context.read<BranchesBloc>().state;

    if (branchState.selectedBranchIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('select_branch'.tr()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final branchIds = branchState.branchIdsToSend;

    final request = ItemProfitRequestModel(
      startDate: fromDate.toUtc().toIso8601String(),
      endDate: DateTime(
        toDate.year,
        toDate.month,
        toDate.day,
      ).toIso8601String(),
      branchIds: branchIds,
      payTypes: [],
      bsrCodes: [],
      priceTypeIndex: priceTypes.indexOf(salePrice),
      costTypeIndex: priceTypes.indexOf(costPrice),
      showReturn: showReturns,
      showWithoutCustomer: hideClient,
      showCustomerBranch: clientBranch,
      filterCostZero: costZero,
      filterCostEqSale: costEqualsSale,
      filterCostBigSale: costGreaterThanSale,
      language: context.locale.languageCode,
    );

    context.read<ItemProfitBloc>().add(
      LoadItemProfitReport(request: request),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Scaffold(
        backgroundColor: AppColors.slateBg,
        appBar: _buildAppBar(context),
        body: _buildBody(context),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return GradientAppBar(
      title: "item_profit_report".tr(),
      subtitle: "query_options".tr(),
      onBack: () => Navigator.of(context).maybePop(),
      accentIcon: Container(
        width: 34.w,
        height: 34.h,
        decoration: BoxDecoration(
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: const Icon(
          Icons.inventory_2,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocConsumer<ItemProfitBloc, BaseState<ItemProfitResponseModel>>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        setState(() {
          _isLoading = state.status == Status.loading;
        });

        if (state.status == Status.success && state.data != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ItemProfitResultsScreen(
                reportData: state.data!,
              ),
            ),
          );
        }

        if (state.status == Status.failure && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == Status.loading;
        final content = FilterContentWidget(
          fromDate: fromDate,
          toDate: toDate,
          costZero: costZero,
          costEqualsSale: costEqualsSale,
          costGreaterThanSale: costGreaterThanSale,
          showReturns: showReturns,
          hideClient: hideClient,
          clientBranch: clientBranch,
          salePrice: salePrice,
          costPrice: costPrice,
          isLoading: isLoading,
          onFromDateChanged: (date) => setState(() => fromDate = date),
          onToDateChanged: (date) => setState(() => toDate = date),
          onCostZeroChanged: (value) => setState(() => costZero = value),
          onCostEqualsSaleChanged: (value) => setState(() => costEqualsSale = value),
          onCostGreaterThanSaleChanged: (value) => setState(() => costGreaterThanSale = value),
          onShowReturnsChanged: (value) => setState(() => showReturns = value),
          onHideClientChanged: (value) => setState(() => hideClient = value),
          onClientBranchChanged: (value) => setState(() => clientBranch = value),
          onSalePriceChanged: (value) => setState(() => salePrice = value),
          onCostPriceChanged: (value) => setState(() => costPrice = value),
        );

        if (state.status == Status.loading) {
          return Stack(
            children: [
              content,
              const ReportsLoadingOverlay(),
            ],
          );
        }
        return content;
      },
    );
  }

  Widget _buildBottomBar() {
    return BottomBarWidget(
      isLoading: _isLoading,
      onReset: _resetFilters,
      onApply: _applyFilters,
    );
  }
}






