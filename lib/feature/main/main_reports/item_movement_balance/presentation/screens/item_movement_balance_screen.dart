import 'package:easy_localization/easy_localization.dart';
import '../../item_movement_balance_import.dart';

class ItemMovementBalanceScreen extends StatelessWidget {
  const ItemMovementBalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ItemMovementBalanceBloc>(
          create: (_) => getIt<ItemMovementBalanceBloc>(),
        ),
        BlocProvider<ProductsBloc>(
          create: (_) => getIt<ProductsBloc>()..add(const LoadProducts()),
        ),
        BlocProvider<GroupsBloc>(
          create: (_) => getIt<GroupsBloc>()..add(const LoadGroups()),
        ),
        BlocProvider<StoresBloc>(
          create: (_) => getIt<StoresBloc>()..add(const LoadStores()),
        ),
        BlocProvider<CostCentersBloc>(
          create: (_) => getIt<CostCentersBloc>()..add(LoadCostCenters()),
        ),
        BlocProvider<CurrenciesBloc>(
          create: (_) => getIt<CurrenciesBloc>()..add(LoadCurrencies()),
        ),
        BlocProvider<MaterialGroupMotionReportSourceBloc>(
          create: (_) => getIt<MaterialGroupMotionReportSourceBloc>()..add(LoadMaterialGroupMotionReportSources()),
        ),
      ],
      child: const ItemMovementBalanceFiltersScreen(),
    );
  }
}

class ItemMovementBalanceFiltersScreen extends StatefulWidget {
  const ItemMovementBalanceFiltersScreen({super.key});

  @override
  State<ItemMovementBalanceFiltersScreen> createState() =>
      _ItemMovementBalanceFiltersScreenState();
}

class _ItemMovementBalanceFiltersScreenState
    extends State<ItemMovementBalanceFiltersScreen> {
  late DateTime fromDate;
  late DateTime toDate;

  // ==================== Selections ====================
  ProductModel? selectedProduct;
  GroupModel? selectedGroup;
  StoreModel? selectedStore;
  CostCenterModel? selectedCostCenter;
  CurrencyModel? selectedCurrency;
  List<MaterialGroupMotionReportSourceModel> selectedSources = [];

  // ==================== Toggle Switches ====================
  bool arabic = true;
  bool showPrice = true;
  bool showTotal = true;
  bool groupByGroup = false;
  bool showEmpty = false;
  bool outputAtCost = true;
  bool lastPeriod = false;
  bool _isReportSourcesExpanded = false;
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    fromDate = DateTime(now.year, now.month, 1);
    toDate = now;
  }

  void _clearSelection(String field) {
    setState(() {
      switch (field) {
        case 'product':
          selectedProduct = null;
          break;
        case 'group':
          selectedGroup = null;
          break;
        case 'store':
          selectedStore = null;
          break;
        case 'costCenter':
          selectedCostCenter = null;
          break;
        case 'currency':
          selectedCurrency = null;
          break;
        case 'sources':
          selectedSources = [];
          break;
      }
    });
  }

  void _applyFilters() {
    ///if (selectedProduct == null) {
    //  context.showErrorMessage('please_select_product'.tr());
    //  return;
   // }

    final request = ItemMovementBalanceRequestModel.create(
      fromDate: fromDate,
      toDate: toDate,
      materialId: selectedProduct?.mtid ?? '',
      groupId: selectedGroup?.groupID ?? '',
      storeId: selectedStore?.id.toString() ?? '',
      costCenterId: selectedCostCenter?.coID.toString() ?? '',
      sources: selectedSources.map((e) => e.frmNum.toString()).toList(),
      arabic: arabic,
      showPrice: showPrice,
      showTotal: showTotal,
      groupByGroup: groupByGroup,
      showEmpty: showEmpty,
      outputAtCost: outputAtCost,
      lastPeriod: lastPeriod,
    );

    context.read<ItemMovementBalanceBloc>().add(
      LoadItemMovementBalanceReport(request: request),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ItemMovementBalanceBloc, BaseState<ItemMovementBalanceResponseModel>>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == Status.failure) {
          context.showErrorMessage(
            state.errorMessage ?? 'error_loading_report'.tr(),
          );
          return;
        }

        if (state.status != Status.success) {
          return;
        }

        final data = state.data;

        if (data == null || data.rows.isEmpty) {
          context.showErrorMessage(
            data?.message ?? 'no_data_found'.tr(),
          );
          return;
        }

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ItemMovementBalanceDetailsScreen(
              reportData: data,
              fromDate: fromDate,
              toDate: toDate,
            ),
          ),
        );
      },
      builder: (context, state) {
        final isLoading = state.status == Status.loading;
        return _buildScaffold(isLoading);
      },
    );
  }

  Widget _buildScaffold(bool isLoading) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: _buildBody(),
          ),
          if (isLoading) _buildLoadingOverlay(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(isLoading),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return GradientAppBar(
      title: "item_movement_balance_report".tr(),
      subtitle: "select_filters_for_report".tr(),
      onBack: () => Navigator.of(context).maybePop(),
    );
  }

  // ==================== Helper: Row with 2 columns ====================
  Widget _buildTwoColumnsRow({
    required Widget left,
    required Widget right,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: left,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: right,
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        _buildSectionLabel('period'.tr()),
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                label: 'from'.tr(),
                date: fromDate,
                onChanged: (date) => setState(() => fromDate = date),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _buildDateField(
                label: 'to'.tr(),
                date: toDate,
                onChanged: (date) => setState(() => toDate = date),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // ==================== 2. الصنف (لوحده) ====================
        _buildSectionLabel('product'.tr()),
        _buildProductField(),
        SizedBox(height: 16.h),

        // ==================== 3. المجموعة + 4. المخزن (جنب بعض) ====================
        _buildTwoColumnsRow(
          left: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionLabel('group'.tr()),
              _buildGroupField(),
            ],
          ),
          right: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionLabel('store'.tr()),
              _buildStoreField(),
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // ==================== 5. مركز التكلفة + 6. العملة (جنب بعض) ====================
        _buildTwoColumnsRow(
          left: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionLabel('cost_center'.tr()),
              _buildCostCenterField(),
            ],
          ),
          right: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionLabel('currency'.tr()),
              _buildCurrencyField(),
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // ==================== 7. مصادر التقرير (لوحدها) ====================
        _buildSectionLabel('report_sources'.tr()),
        _buildReportSourcesField(),
        SizedBox(height: 16.h),

        // ==================== 8. الخيارات (Toggles) ====================
        _buildSectionLabel('options'.tr()),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.line),
          ),
          child: Column(
            children: [
              _buildToggleRow(
                title: 'arabic'.tr(),
                value: arabic,
                onChanged: (v) => setState(() => arabic = v),
              ),
              _buildToggleRow(
                title: 'show_price'.tr(),
                value: showPrice,
                onChanged: (v) => setState(() => showPrice = v),
              ),
              _buildToggleRow(
                title: 'show_total'.tr(),
                value: showTotal,
                onChanged: (v) => setState(() => showTotal = v),
              ),
              _buildToggleRow(
                title: 'group_by_group'.tr(),
                value: groupByGroup,
                onChanged: (v) => setState(() => groupByGroup = v),
              ),
              _buildToggleRow(
                title: 'show_empty'.tr(),
                value: showEmpty,
                onChanged: (v) => setState(() => showEmpty = v),
              ),
              _buildToggleRow(
                title: 'output_at_cost'.tr(),
                value: outputAtCost,
                onChanged: (v) => setState(() => outputAtCost = v),
              ),
              _buildToggleRow(
                title: 'last_period'.tr(),
                value: lastPeriod,
                onChanged: (v) => setState(() => lastPeriod = v),
              ),
            ],
          ),
        ),
        SizedBox(height: 80.h),
      ],
    );
  }

  // ==================== Field Widgets ====================

  Widget _buildProductField() {
    return BlocBuilder<ProductsBloc, BaseState<List<ProductModel>>>(
      builder: (context, state) {
        if (state.status == Status.loading) {
          return _buildLoadingField();
        }
        if (state.status == Status.failure) {
          return _buildErrorField(
            message: state.errorMessage ?? 'error_loading_products'.tr(),
            onRetry: () =>
                context.read<ProductsBloc>().add(const LoadProducts()),
          );
        }

        final products = state.data ?? [];
        final productNames = products.map((e) => e.mtName).toList();

        return FilterField(
          label: 'product'.tr(),
          value: selectedProduct?.mtName,
          placeholder: 'select_product'.tr(),
          isSelected: selectedProduct != null,
          icon: Icons.inventory,
          options: productNames,
          enableSearch: true,
          searchHint: 'search_products'.tr(),
          onChanged: (value) {
            if (value != null) {
              final selected = products.firstWhere(
                    (product) => product.mtName == value,
                orElse: () => products.first,
              );
              setState(() => selectedProduct = selected);
            }
          },
          onClear: selectedProduct != null
              ? () => _clearSelection('product')
              : null,
        );
      },
    );
  }

  Widget _buildGroupField() {
    return BlocBuilder<GroupsBloc, BaseState<List<GroupModel>>>(
      builder: (context, state) {
        if (state.status == Status.loading) {
          return _buildLoadingField();
        }
        if (state.status == Status.failure) {
          return _buildErrorField(
            message: state.errorMessage ?? 'error_loading_groups'.tr(),
            onRetry: () =>
                context.read<GroupsBloc>().add(const LoadGroups()),
          );
        }

        final groups = state.data ?? [];
        final groupNames = groups.map((e) => e.groupName).toList();

        return FilterField(
          label: 'group'.tr(),
          value: selectedGroup?.groupName,
          placeholder: 'select_group'.tr(),
          isSelected: selectedGroup != null,
          icon: Icons.folder,
          options: groupNames,
          enableSearch: true,
          searchHint: 'search_groups'.tr(),
          onChanged: (value) {
            if (value != null) {
              final selected = groups.firstWhere(
                    (group) => group.groupName == value,
                orElse: () => groups.first,
              );
              setState(() => selectedGroup = selected);
            }
          },
          onClear: selectedGroup != null
              ? () => _clearSelection('group')
              : null,
        );
      },
    );
  }

  Widget _buildStoreField() {
    return BlocBuilder<StoresBloc, BaseState<List<StoreModel>>>(
      builder: (context, state) {
        if (state.status == Status.loading) {
          return _buildLoadingField();
        }
        if (state.status == Status.failure) {
          return _buildErrorField(
            message: state.errorMessage ?? 'error_loading_stores'.tr(),
            onRetry: () =>
                context.read<StoresBloc>().add(const LoadStores()),
          );
        }

        final stores = state.data ?? [];
        final storeNames = stores.map((e) => e.branchName).toList();

        return FilterField(
          label: 'store'.tr(),
          value: selectedStore?.branchName,
          placeholder: 'select_store'.tr(),
          isSelected: selectedStore != null,
          icon: Icons.storefront,
          options: storeNames,
          enableSearch: true,
          searchHint: 'search_stores'.tr(),
          onChanged: (value) {
            if (value != null) {
              final selected = stores.firstWhere(
                    (store) => store.branchName == value,
                orElse: () => stores.first,
              );
              setState(() => selectedStore = selected);
            }
          },
          onClear: selectedStore != null
              ? () => _clearSelection('store')
              : null,
        );
      },
    );
  }

  Widget _buildCostCenterField() {
    return BlocBuilder<CostCentersBloc, CostCentersState>(
      builder: (context, state) {
        if (state.status == Status.loading) {
          return _buildLoadingField();
        }
        if (state.status == Status.failure) {
          return _buildErrorField(
            message: state.errorMessage ?? 'error_loading_cost_centers'.tr(),
            onRetry: () =>
                context.read<CostCentersBloc>().add(LoadCostCenters()),
          );
        }

        final costCenters = state.costCenters;
        final costCenterNames = costCenters.map((e) => e.coName).toList();

        return FilterField(
          label: 'cost_center'.tr(),
          value: selectedCostCenter?.coName,
          placeholder: 'select_cost_center'.tr(),
          isSelected: selectedCostCenter != null,
          icon: Icons.account_balance,
          options: costCenterNames,
          enableSearch: true,
          searchHint: 'search_cost_centers'.tr(),
          onChanged: (value) {
            if (value != null) {
              final selected = costCenters.firstWhere(
                    (center) => center.coName == value,
                orElse: () => costCenters.first,
              );
              setState(() => selectedCostCenter = selected);
            }
          },
          onClear: selectedCostCenter != null
              ? () => _clearSelection('costCenter')
              : null,
        );
      },
    );
  }

  Widget _buildCurrencyField() {
    return BlocBuilder<CurrenciesBloc, CurrenciesState>(
      builder: (context, state) {
        if (state.status == Status.loading) {
          return _buildLoadingField();
        }
        if (state.status == Status.failure) {
          return _buildErrorField(
            message: state.errorMessage ?? 'error_loading_currencies'.tr(),
            onRetry: () =>
                context.read<CurrenciesBloc>().add(LoadCurrencies()),
          );
        }

        final currencies = state.currencies;
        final currencyNames = currencies.map((e) => e.currencyName).toList();

        return FilterField(
          label: 'currency'.tr(),
          value: selectedCurrency?.currencyName,
          placeholder: 'select_currency'.tr(),
          isSelected: selectedCurrency != null,
          icon: Icons.attach_money,
          options: currencyNames,
          enableSearch: true,
          searchHint: 'search_currencies'.tr(),
          onChanged: (value) {
            if (value != null) {
              final selected = currencies.firstWhere(
                    (currency) => currency.currencyName == value,
                orElse: () => currencies.first,
              );
              setState(() => selectedCurrency = selected);
            }
          },
          onClear: selectedCurrency != null
              ? () => _clearSelection('currency')
              : null,
        );
      },
    );
  }

  Widget _buildReportSourcesField() {
    return BlocBuilder<
        MaterialGroupMotionReportSourceBloc,
        MaterialGroupMotionReportSourceState
    >(
      builder: (context, state) {
        if (state.status == Status.loading) {
          return _buildLoadingField();
        }

        if (state.status == Status.failure) {
          return _buildErrorField(
            message: state.errorMessage ??
                'error_loading_report_sources'.tr(),
            onRetry: () => context
                .read<MaterialGroupMotionReportSourceBloc>()
                .add(
              const LoadMaterialGroupMotionReportSources(),
            ),
          );
        }

        final sources = state.items;
        final sourceNames = sources.map((e) => e.name).toList();

        return _buildMultiSelectField(
          label: 'sources'.tr(),
          selectedItems: selectedSources,
          allItems: sources,
          placeholder: 'select_sources'.tr(),
          icon: Icons.source,
          options: sourceNames,
          onChanged: (selectedValues) {
            setState(() {
              selectedSources = sources
                  .where(
                    (e) => selectedValues.contains(e.name),
              )
                  .toList();
            });
          },
          onClear: selectedSources.isNotEmpty
              ? () => _clearSelection('sources')
              : null,
        );
      },
    );
  }
  // ==================== Helper Widgets ====================

  Widget _buildSectionLabel(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required Function(DateTime) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.h),
        InkWell(
          onTap: () async {
            final picked = await AppDatePicker.show(
              context: context,
              initialDate: date,
            );
            if (picked != null) onChanged(picked);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.line),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppColors.blue,
                  size: 16.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    DateFormat('dd/MM/yyyy').format(date),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleRow({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textDark,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.blue,
            inactiveTrackColor: AppColors.line,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 20.h,
            width: 20.w,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.blue,
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            'loading'.tr(),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorField({
    required String message,
    required VoidCallback onRetry,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.red),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.red,
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.red,
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(
              'retry'.tr(),
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiSelectField({
    required String label,
    required List<MaterialGroupMotionReportSourceModel> selectedItems,
    required List<MaterialGroupMotionReportSourceModel> allItems,
    required String placeholder,
    required IconData icon,
    required List<String> options,
    required Function(List<String>) onChanged,
    VoidCallback? onClear,
  }) {
    final selectedNames = selectedItems.map((e) => e.name).toList();

    final bool isAllSelected =
        allItems.isNotEmpty &&
            selectedItems.length == allItems.length;

    final bool isPartiallySelected =
        selectedItems.isNotEmpty && !isAllSelected;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 12.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.line,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================
          // Header
          // =========================
          Row(
            children: [
              // Select All
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(8.r),
                  onTap: allItems.isEmpty
                      ? null
                      : () {
                    if (isAllSelected) {
                      onChanged([]);
                    } else {
                      onChanged(
                        allItems
                            .map((e) => e.name)
                            .toList(),
                      );
                    }
                  },
                  child: Row(
                    children: [
                      Checkbox(

                        value: isPartiallySelected
                            ? null
                            : isAllSelected,
                        tristate: true,
                        onChanged: allItems.isEmpty
                            ? null
                            : (value) {
                          if (isAllSelected) {
                            onChanged([]);
                          } else {
                            onChanged(
                              allItems
                                  .map((e) => e.name)
                                  .toList(),
                            );
                          }
                        },
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'select_all'.tr(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Expand / Collapse
              IconButton(
                onPressed: () {
                  setState(() {
                    _isReportSourcesExpanded =
                    !_isReportSourcesExpanded;
                  });
                },
                icon: AnimatedRotation(
                  turns:
                  _isReportSourcesExpanded ? 0.5 : 0,
                  duration: const Duration(
                    milliseconds: 200,
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.textMuted,
                    size: 24.sp,
                  ),
                ),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(
                  minWidth: 32.w,
                  minHeight: 32.h,
                ),
              ),

              // Clear All
              if (selectedItems.isNotEmpty)
                IconButton(

                  onPressed: onClear ?? () => onChanged([]),
                  icon: Icon(
                    Icons.close,
                    color: AppColors.textMuted,
                    size: 20.sp,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(
                    minWidth: 32.w,
                    minHeight: 32.h,
                  ),
                ),
            ],
          ),


          AnimatedSize(
            duration: const Duration(
              milliseconds: 250,
            ),
            curve: Curves.easeInOut,
            child: !_isReportSourcesExpanded
                ? const SizedBox.shrink()
                : Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),

                if (options.isNotEmpty)
                  Wrap(
                    spacing: 4.w,
                    runSpacing: 4.h,
                    children: options.map((option) {
                      final bool isSelected =
                      selectedNames.contains(option);

                      return FilterChip(
                        label: Text(
                          option,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isSelected
                                ? AppColors.white
                                : AppColors.textDark,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (_) {
                          final newSelected =
                          List<String>.from(
                            selectedNames,
                          );

                          if (isSelected) {
                            newSelected.remove(option);
                          } else {
                            newSelected.add(option);
                          }

                          onChanged(newSelected);
                        },
                        backgroundColor:
                        AppColors.white,
                        selectedColor:
                        AppColors.blue,
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(6.r),
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.blue
                                : AppColors.line,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                      );
                    }).toList(),
                  )
                else
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.h,
                    ),
                    child: Text(
                      placeholder,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildFloatingActionButton(bool isLoading) {
    return FloatingActionButton.extended(
      onPressed: isLoading ? null : _applyFilters,
      backgroundColor: isLoading ? AppColors.textMuted : AppColors.blue,
      foregroundColor: AppColors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      icon: isLoading
          ? SizedBox(
        height: 20.h,
        width: 20.w,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.white,
        ),
      )
          : Icon(
        Icons.visibility,
        size: 20.sp,
      ),
      label: Text(
        isLoading ? 'loading'.tr() : 'view_report'.tr(),
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: AppColors.blue,
              ),
              SizedBox(height: 16.h),
              Text(
                'loading_report'.tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}