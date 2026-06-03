import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/entity/barren_invoice_model.dart';
import '../../../../core/local/hive_service_impl.dart';
import '../../../../core/models/item_model.dart';
import '../../../main/new_invoice/new_invoice_imports.dart';
import '../../data/services/excel_export_service.dart';
import '../../domain/entities/invoice_product.dart';
import 'invoice_state.dart';

/// Drives the Barren stock-taking screen: every scanned barcode is sent to
/// the catalogue API ([ProductSearchDataSource.searchByBarcode]) so the line
/// can be enriched with product name + system stock, and the user can type
/// their physical count alongside it.
class InvoiceCubit extends Cubit<InvoiceState> {
  final ExcelExportService _excelExportService;
  final InvoiceCache _invoiceCache;
  final ProductSearchDataSource _searchDataSource;
  List<InvoiceProduct> _products = [];

  InvoiceCubit({
    required ProductSearchDataSource searchDataSource,
    required InvoiceCache invoiceCache,
    ExcelExportService? excelExportService,
  })  : _searchDataSource = searchDataSource,
        _invoiceCache = invoiceCache,
        _excelExportService = excelExportService ?? ExcelExportService(),
        super(const InvoiceInitial()) {
    _loadPersistedInvoice();
  }

  void _loadPersistedInvoice() {
    final saved = _invoiceCache.getInvoice();
    if (saved != null && saved.products.isNotEmpty) {
      _products = List.from(saved.products);
      emit(InvoiceLoaded(products: List.from(_products)));
    }
  }

  Future<void> _saveInvoice() async {
    await _invoiceCache.cacheInvoice(
      BarrenInvoiceModel(savedAt: DateTime.now(), products: _products),
    );
  }

  InvoiceState _restoreLoaded() => _products.isEmpty
      ? const InvoiceInitial()
      : InvoiceLoaded(products: List.from(_products));

  /// Look up the scanned barcode via the API and append a new line on
  /// success. On not-found / failure, show a one-shot [InvoiceError] then
  /// restore the previous list state (no row added).
  Future<void> addProduct(String barcode, {num realQuantity = 1}) async {
    final trimmed = barcode.trim();
    if (trimmed.isEmpty || realQuantity <= 0) return;

    emit(const InvoiceSearching());
    final result = await _searchDataSource.searchByBarcode(trimmed);

    ItemModel? match;
    result.fold(
      (_) => match = null,
      (items) => match = items.isNotEmpty ? items.first : null,
    );

    if (match == null) {
      emit(InvoiceError(message: 'product_not_found'.tr()));
      await Future.delayed(const Duration(milliseconds: 500));
      emit(_restoreLoaded());
      return;
    }

    final p = match!;
    _products.add(InvoiceProduct(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      barcode: p.barCode.isNotEmpty ? p.barCode : trimmed,
      quantity: 1,
      productId: p.productId,
      productArName: p.productArName,
      productEnName: p.productEnName,
      stockQuantity: p.stockQuantity,
      realQuantity: realQuantity,
    ));
    await _saveInvoice();
    emit(InvoiceLoaded(products: List.from(_products)));
  }

  void removeProduct(String id) {
    _products.removeWhere((p) => p.id == id);
    _saveInvoice();
    emit(_restoreLoaded());
  }

  /// Replaces the editable real-quantity for a line. <=0 removes the line.
  void updateRealQuantity(String id, num realQuantity) {
    if (realQuantity <= 0) {
      removeProduct(id);
      return;
    }
    final index = _products.indexWhere((p) => p.id == id);
    if (index != -1) {
      _products[index] = _products[index].copyWith(realQuantity: realQuantity);
      _saveInvoice();
      emit(InvoiceLoaded(products: List.from(_products)));
    }
  }

  void clearInvoice() {
    _products.clear();
    _invoiceCache.clearInvoice();
    emit(const InvoiceInitial());
  }

  Future<void> exportToExcel() async {
    if (_products.isEmpty) {
      emit(const InvoiceError(message: 'لا توجد منتجات لتصديرها'));
      emit(const InvoiceInitial());
      return;
    }

    emit(const InvoiceExporting());
    try {
      final filePath = await _excelExportService.exportInvoice(products: _products);
      if (filePath != null) {
        emit(InvoiceExported(filePath: filePath));
      } else {
        emit(const InvoiceError(message: 'تم إلغاء التصدير'));
      }
    } catch (e) {
      emit(InvoiceError(message: 'فشل تصدير الملف: ${e.toString()}'));
    }
    await Future.delayed(const Duration(milliseconds: 500));
    emit(_restoreLoaded());
  }

  List<InvoiceProduct> get products => List.from(_products);
}
