import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

import '../cubit/invoice_cubit.dart';
import '../cubit/invoice_state.dart';
import '../widgets/barcode_scanner_view.dart';
import '../widgets/barcode_search_field.dart';
import '../widgets/quantity_input_section.dart';
import '../widgets/invoice_table.dart';
import '../widgets/invoice_summary.dart';
import '../widgets/action_buttons.dart';

/// Barren stock-taking screen — scan a barcode, the cubit looks up the
/// product via the catalogue API and adds a line carrying name + system
/// stock + the user's typed real count.
class BarrenStockTakingScreen extends StatefulWidget {
  const BarrenStockTakingScreen({super.key});

  @override
  State<BarrenStockTakingScreen> createState() =>
      _BarrenStockTakingScreenState();
}

class _BarrenStockTakingScreenState extends State<BarrenStockTakingScreen> {
  late TextEditingController _barcodeController;
  late TextEditingController _quantityController;
  late FocusNode _barcodeFocusNode;
  late FocusNode _quantityFocusNode;

  // ── DataWedge EventChannel ─────────────────────────────────────────────
  // Must match the channel name used on the Android side
  // (`MainActivity.kt`) and the app's `applicationId`.
  static const _scannerChannel = EventChannel(
    'com.example.one_pos/scanner',
  );
  StreamSubscription? _scanSubscription;
  // ──────────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _barcodeController  = TextEditingController();
    _quantityController = TextEditingController(text: '1');
    _barcodeFocusNode   = FocusNode();
    _quantityFocusNode  = FocusNode();

    _startScannerListener();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _quantityFocusNode.requestFocus();
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

  // ── Listen to DataWedge broadcasts ────────────────────────────────────
  void _startScannerListener() {
    _scanSubscription = _scannerChannel
        .receiveBroadcastStream()
        .listen(
          (dynamic barcode) {
        if (barcode is String && barcode.trim().isNotEmpty) {
          if (mounted) _processScannedBarcode(barcode.trim());
        }
      },
      onError: (dynamic error) {
        debugPrint('Scanner channel error: $error');
      },
      cancelOnError: false,
    );
  }
  // ──────────────────────────────────────────────────────────────────────

  void _processScannedBarcode(String barcode) {
    final trimmed = barcode.trim();
    if (trimmed.isEmpty) return;

    final quantity = double.tryParse(_quantityController.text) ?? 1.0;
    context.read<InvoiceCubit>().addProduct(trimmed, realQuantity: quantity);

    _barcodeController.clear();
    _quantityController.text = '1';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم إضافة المنتج: $trimmed'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    _quantityFocusNode.requestFocus();
  }

  Future<void> _openScanner(BuildContext context) async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      if (!context.mounted) return;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BarcodeScannerView(
            onBarcodeScanned: (barcode) {
              _processScannedBarcode(barcode);
            },
          ),
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
    final barcode = _barcodeController.text.trim();
    if (barcode.isEmpty) return;
    _processScannedBarcode(barcode);
  }

  void _showClearConfirmation() {
    final cubit = context.read<InvoiceCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'confirm_clear'.tr(),
          textAlign: TextAlign.right,
        ),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: BlocListener<InvoiceCubit, InvoiceState>(
        listener: (context, state) {
          if (state is InvoiceExported) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('export_success'.tr()),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is InvoiceError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              BarcodeSearchField(
                controller: _barcodeController,
                focusNode: _barcodeFocusNode,
                onScanPressed: () => _openScanner(context),
                onBarcodeEntered: (barcode) {
                  _processScannedBarcode(barcode);
                },
              ),

              SizedBox(height: 16.h),

              QuantityInputSection(
                controller: _quantityController,
                focusNode: _quantityFocusNode,
                onAddPressed: _addProductManually,
                onBarcodePressed: () {
                  _quantityFocusNode.requestFocus();
                },
                onSubmitted: (_) {
                  _quantityFocusNode.requestFocus();
                },
              ),

              SizedBox(height: 12.h),

              // Thin progress bar while the API barcode lookup is in flight.
              BlocBuilder<InvoiceCubit, InvoiceState>(
                buildWhen: (prev, curr) =>
                    prev is InvoiceSearching || curr is InvoiceSearching,
                builder: (context, state) => SizedBox(
                  height: 2.h,
                  child: state is InvoiceSearching
                      ? const LinearProgressIndicator(minHeight: 2)
                      : null,
                ),
              ),

              SizedBox(height: 12.h),

              Expanded(
                child: BlocBuilder<InvoiceCubit, InvoiceState>(
                  builder: (context, state) {
                    // Keep showing the last loaded list during transient
                    // states (searching / error / exporting) so the table
                    // doesn't blank out between scans.
                    final products = state is InvoiceLoaded
                        ? state.products
                        : context.read<InvoiceCubit>().products;

                    return InvoiceTable(
                      products: products.reversed.toList(),
                      onDeleteProduct: (id) {
                        context.read<InvoiceCubit>().removeProduct(id);
                      },
                      onRealQuantityChanged: (id, newQty) {
                        context.read<InvoiceCubit>().updateRealQuantity(id, newQty);
                      },
                    );
                  },
                ),
              ),

              SizedBox(height: 20.h),

              BlocBuilder<InvoiceCubit, InvoiceState>(
                builder: (context, state) {
                  final itemCount =
                  state is InvoiceLoaded ? state.totalItems : 0;
                  final totalQuantity = state is InvoiceLoaded
                      ? state.totalQuantity.toDouble()
                      : 0.0;

                  return InvoiceSummary(
                    itemCount: itemCount,
                    totalQuantity: totalQuantity,
                  );
                },
              ),

              SizedBox(height: 20.h),

              BlocBuilder<InvoiceCubit, InvoiceState>(
                builder: (context, state) {
                  final isLoading = state is InvoiceExporting;

                  return ActionButtons(
                    isLoading: isLoading,
                    onExportPressed: () {
                      context.read<InvoiceCubit>().exportToExcel();
                    },
                    onClearPressed: _showClearConfirmation,
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