import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:one_pos/core/helper/helper.dart';

import '../../../../core/bloc/paginated_bloc/paginated_bloc.dart';
import '../../../../core/extension/context_extension.dart';
import '../../../../core/services/service_locator/services_imports.dart';
import '../../../main/main_reports/shared/store/data/models/store_model.dart';

import '../../data/models/add_stock_items_request.dart';
import '../cubit/invoice_cubit.dart';
import '../cubit/invoice_state.dart';
import '../cubit/stock_cubit/stock_cubit.dart';
import '../cubit/stock_cubit/stock_state.dart';

import '../widgets/barcode_scanner_view.dart';
import '../widgets/barcode_search_field.dart';
import '../widgets/quantity_input_section.dart';
import '../widgets/invoice_table.dart';
import '../widgets/invoice_summary.dart';
import '../widgets/action_buttons.dart';

class BarrenStockTakingScreen extends StatelessWidget {
  const BarrenStockTakingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<StockCubit>()..getStores(),
      child: const _BarrenStockTakingView(),
    );
  }
}

class _BarrenStockTakingView extends StatefulWidget {
  const _BarrenStockTakingView();

  @override
  State<_BarrenStockTakingView> createState() => _BarrenStockTakingViewState();
}

class _BarrenStockTakingViewState extends State<_BarrenStockTakingView> {
  late TextEditingController _barcodeController;
  late TextEditingController _quantityController;

  late FocusNode _barcodeFocusNode;
  late FocusNode _quantityFocusNode;

  static const _scannerChannel = EventChannel('com.example.one_pos/scanner');

  StreamSubscription? _scanSubscription;

  StoreModel? _selectedStore;

  @override
  void initState() {
    super.initState();

    _barcodeController = TextEditingController();
    _quantityController = TextEditingController(text: '1');

    _barcodeFocusNode = FocusNode();
    _quantityFocusNode = FocusNode();

    _startScannerListener();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _barcodeFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();

    _barcodeController.dispose();
    _quantityController.dispose();

    _barcodeFocusNode.dispose();
    _quantityFocusNode.dispose();

    super.dispose();
  }

  // ============================================================
  // Scanner
  // ============================================================

  void _startScannerListener() {
    _scanSubscription = _scannerChannel.receiveBroadcastStream().listen(
      (dynamic barcode) {
        if (barcode is! String) return;

        final trimmed = barcode.trim();

        if (trimmed.isEmpty || !mounted) return;

        _processScannedBarcode(trimmed);
      },
      onError: (dynamic error) {
        debugPrint('Scanner channel error: $error');
      },
      cancelOnError: false,
    );
  }

  void _processScannedBarcode(String barcode) {
    final trimmed = barcode.trim();

    if (trimmed.isEmpty) return;

    if (_selectedStore == null) {
      context.showTopSnackBar(

        backgroundColor: Colors.orange.shade800,
        icon: Icons.store_outlined,
        child: Text(
            'stock_taking.select_store_first'.tr(),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      );

      return;
    }

    _barcodeController.value = TextEditingValue(
      text: trimmed,
      selection: TextSelection.collapsed(offset: trimmed.length),
    );

    final quantity = double.tryParse(_quantityController.text.trim()) ?? 1.0;

    context.read<InvoiceCubit>().addProduct(trimmed, realQuantity: quantity);

    _barcodeController.clear();
    _quantityController.text = '1';

    _barcodeFocusNode.requestFocus();
  }

  // ============================================================
  // Store
  // ============================================================

  String _storeName(StoreModel store) {
    final name = store.branchName.toString().trim() ?? '';

    if (name.isNotEmpty) return name;

    final arabicName = store.codeAndArabicName.toString().trim() ?? '';

    if (arabicName.isNotEmpty) return arabicName;

    return 'stock_taking.store_without_name'.tr();
  }

  String _storeSubtitle(StoreModel store) {
    final englishName = store.branchEName.toString().trim() ?? '';

    if (englishName.isNotEmpty) return englishName;

    final code = store.codeAndEnglishName.toString().trim() ?? '';

    if (code.isNotEmpty) return code;

    return '';
  }


  void _showStorePicker(List<StoreModel> stores) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.62,
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16.r),
            ),
          ),
          child: Column(
            children: [
              // Handle
              SizedBox(height: 6.h),

              Container(
                width: 34.w,
                height: 3.h,
                decoration: BoxDecoration(
                  color: AppColors.borderColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),

              // Header
              Padding(
                padding: EdgeInsets.fromLTRB(
                  12.w,
                  8.h,
                  8.w,
                  7.h,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 34.w,
                      height: 34.w,
                      decoration: BoxDecoration(
                        color: AppColors.brandLight,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.store_outlined,
                        color: AppColors.brand,
                        size: 18.sp,
                      ),
                    ),

                    SizedBox(width: 8.w),

                    Expanded(
                      child: Text(
                        'stock_taking.select_store'.tr(),
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 32.w,
                      height: 32.w,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.of(sheetContext).pop();
                        },
                        icon: Icon(
                          Icons.close_rounded,
                          size: 18.sp,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 2.h),

              // Stores
              Expanded(
                child: stores.isEmpty
                    ? Center(
                  child: Text(
                    'stock_taking.no_stores'.tr(),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textMuted,
                    ),
                  ),
                )
                    : ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                    12.w,
                    1.h,
                    12.w,
                    10.h,
                  ),
                  itemCount: stores.length,
                  separatorBuilder: (_, __) =>
                      SizedBox(height: 4.h),
                  itemBuilder: (context, index) {
                    final store = stores[index];

                    final isSelected =
                        _selectedStore?.id == store.id;

                    return InkWell(
                      borderRadius: BorderRadius.circular(8.r),
                      onTap: () {
                        setState(() {
                          _selectedStore = store;
                        });

                        Navigator.of(sheetContext).pop();

                        WidgetsBinding.instance
                            .addPostFrameCallback((_) {
                          if (!mounted) return;

                          _barcodeFocusNode.requestFocus();
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(
                          milliseconds: 120,
                        ),
                        height: 50.h,
                        padding: EdgeInsets.symmetric(
                          horizontal: 9.w,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius:
                          BorderRadius.circular(8.r),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.brand
                                : AppColors.borderColor,
                            width: isSelected ? 1.1 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 31.w,
                              height: 31.w,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.brandLight
                                    : AppColors.lightGray,
                                borderRadius:
                                BorderRadius.circular(7.r),
                              ),
                              child: Icon(
                                Icons.storefront_outlined,
                                color: isSelected
                                    ? AppColors.brand
                                    : AppColors.textMuted,
                                size: 17.sp,
                              ),
                            ),

                            SizedBox(width: 8.w),

                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _storeName(store),
                                    maxLines: 1,
                                    overflow:
                                    TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color:
                                      AppColors.textPrimary,
                                    ),
                                  ),

                                  if (_storeSubtitle(store)
                                      .isNotEmpty)
                                    Text(
                                      _storeSubtitle(store),
                                      maxLines: 1,
                                      overflow:
                                      TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 9.sp,
                                        color:
                                        AppColors.textMuted,
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            SizedBox(width: 5.w),

                            Icon(
                              isSelected
                                  ? Icons.check_circle_rounded
                                  : Icons
                                  .radio_button_unchecked_rounded,
                              color: isSelected
                                  ? AppColors.brand
                                  : AppColors.borderColor,
                              size: 18.sp,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildStoreSelector() {
    return BlocBuilder<StockCubit, StockState>(
      buildWhen: (previous, current) =>
      previous.storesState != current.storesState,
      builder: (context, state) {
        final stores = state.storesState.data ?? [];
        final isLoading = state.storesState.status == Status.loading;
        final hasError = state.storesState.status == Status.failure;

        return InkWell(
          onTap: () {
            if (isLoading) return;

            if (stores.isEmpty) {
              context.read<StockCubit>().getStores();
              return;
            }

            _showStorePicker(stores);
          },
          borderRadius: BorderRadius.circular(10.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: double.infinity,
            height: 62.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: _selectedStore != null
                    ? AppColors.brand.withValues(alpha: 0.65)
                    : AppColors.borderColor,
                width: _selectedStore != null ? 1.1 : 1,
              ),
            ),
            child: Row(
              children: [
                // Store Icon
                Container(
                  width: 38.w,
                  height: 38.w,
                  decoration: BoxDecoration(
                    color: AppColors.brandLight,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: isLoading
                      ? Padding(
                    padding: EdgeInsets.all(10.w),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.brand,
                    ),
                  )
                      : Icon(
                    Icons.store_outlined,
                    color: AppColors.brand,
                    size: 21.sp,
                  ),
                ),

                SizedBox(width: 10.w),

                // Store Info
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          isLoading
                              ? 'stock_taking.loading_stores'.tr()
                              : hasError
                              ? 'stock_taking.failed_to_load_stores'.tr()
                              : _selectedStore == null
                              ? 'stock_taking.select_store'.tr()
                              : _storeName(_selectedStore!),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),

                      if (_selectedStore != null &&
                          _storeSubtitle(_selectedStore!).isNotEmpty) ...[
                        SizedBox(width: 8.w),
                        Flexible(
                          child: Text(
                            '• ${_storeSubtitle(_selectedStore!)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ],

                      if (hasError) ...[
                        SizedBox(width: 8.w),
                        Text(
                          'stock_taking.retry'.tr(),
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                SizedBox(width: 8.w),

                // Arrow
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textMuted,
                  size: 22.sp,
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  // ============================================================
  // Scanner
  // ============================================================

  Future<void> _openScanner(BuildContext context) async {
    if (_selectedStore == null) {
      context.showTopSnackBar(
        backgroundColor: Colors.orange.shade800,
        icon: Icons.store_outlined,
        child:  Text(
          'stock_taking.select_store_first'.tr(),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      );

      return;
    }

    final status = await Permission.camera.request();

    if (status.isGranted) {
      if (!context.mounted) return;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              BarcodeScannerView(onBarcodeScanned: _processScannedBarcode),
        ),
      );
    } else {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('camera_permission_denied'.tr()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _addProductManually() {
    if (_selectedStore == null) {
      context.showTopSnackBar(
        backgroundColor: Colors.orange.shade800,
        icon: Icons.store_outlined,
        child:Text(
            'stock_taking.select_store_first'.tr(),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      );

      return;
    }

    final barcode = _barcodeController.text.trim();

    if (barcode.isEmpty) return;

    _processScannedBarcode(barcode);
  }

  // ============================================================
  // Clear
  // ============================================================

  void _showClearConfirmation() {
    final cubit = context.read<InvoiceCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('confirm_clear'.tr(), textAlign: TextAlign.right),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('no'.tr()),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                cubit.clearInvoice();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('invoice_cleared'.tr()),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              child: Text(
                'yes'.tr(),
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'scan_barcode'.tr(),
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          // ==========================================================
          // Invoice Listener
          // ==========================================================
          BlocListener<InvoiceCubit, InvoiceState>(
            listenWhen: (prev, curr) =>
                curr is InvoiceError ||
                curr is InvoiceExported ||
                (prev is InvoiceSearching && curr is InvoiceLoaded),
            listener: (context, state) {
              if (state is InvoiceError) {
                context.showTopSnackBar(
                  backgroundColor: const Color(0xFFC62828),
                  icon: Icons.error_outline,
                  child: Text(
                    state.message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              } else if (state is InvoiceExported) {
                context.showTopSnackBar(
                  backgroundColor: const Color(0xFF2E7D32),
                  icon: Icons.check_circle_outline,
                  child: Text(
                    'export_success'.tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              } else if (state is InvoiceLoaded && state.products.isNotEmpty) {
                final added = state.products.last;

                context.showTopSnackBar(
                  backgroundColor: const Color(0xFF2E7D32),
                  icon: Icons.check_circle_outline,
                  child: Text(
                    '${'product_added'.tr()}: '
                    '${added.displayName(context.isArabic)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }
            },
          ),

          // ==========================================================
          // Stock Save Listener
          // ==========================================================
          BlocListener<StockCubit, StockState>(
            listenWhen: (previous, current) =>
                previous.addStockState != current.addStockState,
            listener: (context, state) {
              final addStockState = state.addStockState;

              if (addStockState.status == Status.success) {
                final response = addStockState.data;

                context.showTopSnackBar(
                  backgroundColor: const Color(0xFF2E7D32),
                  icon: Icons.check_circle_outline,
                  child: Text(
                    response?.message ?? 'stock_taking.save_success'.tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );

                // ==================================================
                // API Success
                // امسح الأصناف من الشاشة + Hive
                // ==================================================
                context.read<InvoiceCubit>().clearInvoice();

                // Reset save state
                context.read<StockCubit>().resetAddStockState();

                _barcodeController.clear();
                _quantityController.text = '1';

                _barcodeFocusNode.requestFocus();
              }

              if (addStockState.status == Status.failure) {
                context.showTopSnackBar(
                  backgroundColor: const Color(0xFFC62828),
                  icon: Icons.error_outline,
                  child: Text(
                    addStockState.errorMessage ??  'stock_taking.save_error'.tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );

                context.read<StockCubit>().resetAddStockState();
              }
            },
          ),
        ],

        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Column(
            children: [
              // ========================================================
              // Store selector
              // ========================================================
              _buildStoreSelector(),

              SizedBox(height: 12.h),

              // ========================================================
              // Quantity + Barcode
              // ========================================================
              Row(
                children: [
                  Expanded(
                    child: QuantityInputSection(
                      controller: _quantityController,
                      focusNode: _quantityFocusNode,
                      onAddPressed: _addProductManually,
                      onBarcodePressed: () {
                        _barcodeFocusNode.requestFocus();
                      },
                      onSubmitted: (_) {
                        _barcodeFocusNode.requestFocus();
                      },
                    ),
                  ),

                  Expanded(
                    child: BarcodeSearchField(
                      controller: _barcodeController,
                      focusNode: _barcodeFocusNode,
                      onScanPressed: () {
                        _barcodeFocusNode.requestFocus();

                        _openScanner(context);
                      },
                      onBarcodeEntered: (barcode) {
                        _processScannedBarcode(barcode);
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 4.h),

              // ========================================================
              // Search progress
              // ========================================================
              BlocBuilder<InvoiceCubit, InvoiceState>(
                buildWhen: (prev, curr) =>
                    prev is InvoiceSearching || curr is InvoiceSearching,
                builder: (context, state) {
                  return SizedBox(
                    height: 2.h,
                    child: state is InvoiceSearching
                        ? const LinearProgressIndicator(minHeight: 2)
                        : null,
                  );
                },
              ),

              SizedBox(height: 12.h),

              // ========================================================
              // Products table
              // ========================================================
              Expanded(
                child: BlocBuilder<InvoiceCubit, InvoiceState>(
                  builder: (context, state) {
                    final products = state is InvoiceLoaded
                        ? state.products
                        : context.read<InvoiceCubit>().products;

                    return InvoiceTable(
                      products: products.reversed.toList(),
                      onDeleteProduct: (id) {
                        context.read<InvoiceCubit>().removeProduct(id);
                      },
                      onRealQuantityChanged: (id, newQty) {
                        context.read<InvoiceCubit>().updateRealQuantity(
                          id,
                          newQty,
                        );
                      },
                    );
                  },
                ),
              ),

              SizedBox(height: 10.h),

              // ========================================================
              // Summary
              // ========================================================
              BlocBuilder<InvoiceCubit, InvoiceState>(
                builder: (context, state) {
                  final itemCount = state is InvoiceLoaded
                      ? state.totalItems
                      : 0;

                  final totalQuantity = state is InvoiceLoaded
                      ? state.totalQuantity.toDouble()
                      : 0.0;

                  return InvoiceSummary(
                    itemCount: itemCount,
                    totalQuantity: totalQuantity,
                  );
                },
              ),

              SizedBox(height: 10.h),

              // ========================================================
              // Actions
              // ========================================================
              BlocBuilder<StockCubit, StockState>(
                buildWhen: (previous, current) =>
                    previous.addStockState != current.addStockState,
                builder: (context, stockState) {
                  return BlocBuilder<InvoiceCubit, InvoiceState>(
                    builder: (context, invoiceState) {
                      final isSaving =
                          stockState.addStockState.status == Status.loading;

                      final isExporting = invoiceState is InvoiceExporting;

                      final isExcelExported = context
                          .read<InvoiceCubit>()
                          .isExcelExported;

                      return ActionButtons(
                        isSaving: isSaving,
                        isExporting: isExporting,

                        // ==================================================
                        // Save
                        // ==================================================
                        onSavePressed: () async {
                          if (!isExcelExported) {
                            context.showTopSnackBar(
                              backgroundColor: Colors.orange.shade800,
                              icon: Icons.file_download_outlined,
                              child:  Text(
                              'stock_taking.export_excel_first'.tr(),

                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );

                            return;
                          }

                          if (_selectedStore == null) {
                            context.showTopSnackBar(
                              backgroundColor: Colors.orange.shade800,
                              icon: Icons.store_outlined,
                              child:  Text(
                                'stock_taking.select_store_first'.tr(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );

                            return;
                          }

                          final invoiceCubit = context.read<InvoiceCubit>();

                          final products = invoiceCubit.products;

                          if (products.isEmpty) {
                            context.showTopSnackBar(
                              backgroundColor: Colors.orange.shade800,
                              icon: Icons.inventory_2_outlined,
                              child:  Text(
                                'stock_taking.add_products_first'.tr(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );

                            return;
                          }

                          final request = AddStockItemsRequest(
                            storeCode: _selectedStore!.id.toString(),
                            items: products.map((product) {
                              return AddStockItem(
                                mtid: product.productId.toString(),
                                qty: product.realQuantity.toInt(),
                                barcode: product.barcode,
                              );
                            }).toList(),
                          );

                          await context.read<StockCubit>().addStockItems(
                            request,
                          );
                        },

                        // ==================================================
                        // Excel
                        // ==================================================
                        onExportPressed: () {
                          context.read<InvoiceCubit>().exportToExcel();
                        },

                        // ==================================================
                        // Clear
                        // ==================================================
                        onClearPressed: _showClearConfirmation,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
