import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/entity/barren_invoice_model.dart';
import '../../../../core/local/hive_service_impl.dart';
import '../../../../core/models/item_model.dart';
import '../../../main/new_invoice/new_invoice_imports.dart';
import '../../data/services/excel_export_service.dart';
import '../../domain/entities/invoice_product.dart';
import 'invoice_state.dart';

/// Drives the Barren stock-taking screen.
class InvoiceCubit extends Cubit<InvoiceState> {
  final ExcelExportService _excelExportService;
  final InvoiceCache _invoiceCache;
  final ProductSearchDataSource _searchDataSource;

  List<InvoiceProduct> _products = [];

  /// True only when the current products have been exported successfully.
  bool _isExcelExported = false;

  InvoiceCubit({
    required ProductSearchDataSource searchDataSource,
    required InvoiceCache invoiceCache,
    ExcelExportService? excelExportService,
  }) : _searchDataSource = searchDataSource,
       _invoiceCache = invoiceCache,
       _excelExportService = excelExportService ?? ExcelExportService(),
       super(const InvoiceInitial()) {
    _loadPersistedInvoice();
  }

  bool get isExcelExported => _isExcelExported;

  void _loadPersistedInvoice() {
    final saved = _invoiceCache.getInvoice();

    if (saved != null && saved.products.isNotEmpty) {
      _products = List.from(saved.products);

      // المنتجات الموجودة من الكاش لم يتم تصديرها في الجلسة الحالية.
      _isExcelExported = false;

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

  Future<void> addProduct(String barcode, {num realQuantity = 1}) async {
    final trimmed = barcode.trim();

    if (trimmed.isEmpty || realQuantity <= 0) {
      return;
    }

    emit(const InvoiceSearching());

    final result = await _searchDataSource.searchByBarcode(trimmed);

    ItemModel? match;

    result.fold((_) => match = null, (items) {
      match = items.isNotEmpty ? items.first : null;
    });

    if (match == null) {
      emit(InvoiceError(message: 'product_not_found'.tr()));

      await Future.delayed(const Duration(milliseconds: 500));

      emit(_restoreLoaded());
      return;
    }

    final p = match!;

    _products.add(
      InvoiceProduct(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        barcode: p.barCode.isNotEmpty ? p.barCode : trimmed,
        quantity: 1,
        productId: p.productId,
        productArName: p.productArName,
        productEnName: p.productEnName,
        stockQuantity: p.stockQuantity,
        realQuantity: realQuantity,
      ),
    );

    // تم تغيير الأصناف، إذن الـ Excel القديم لم يعد صالحًا.
    _isExcelExported = false;

    await _saveInvoice();

    emit(InvoiceLoaded(products: List.from(_products)));
  }

  void removeProduct(String id) {
    _products.removeWhere((p) => p.id == id);

    // تم تغيير الأصناف.
    _isExcelExported = false;

    _saveInvoice();

    emit(_restoreLoaded());
  }

  /// Replaces the editable real-quantity for a line.
  /// <= 0 removes the line.
  void updateRealQuantity(String id, num realQuantity) {
    if (realQuantity <= 0) {
      removeProduct(id);
      return;
    }

    final index = _products.indexWhere((p) => p.id == id);

    if (index != -1) {
      _products[index] = _products[index].copyWith(realQuantity: realQuantity);

      // تغيير الكمية يجعل الـ Excel القديم غير صالح.
      _isExcelExported = false;

      _saveInvoice();

      emit(InvoiceLoaded(products: List.from(_products)));
    }
  }

  void clearInvoice() {
    _products.clear();

    // تم مسح الأصناف وبالتالي حالة التصدير انتهت.
    _isExcelExported = false;

    _invoiceCache.clearInvoice();

    emit(const InvoiceInitial());
  }

  Future<void> exportToExcel() async {
    if (_products.isEmpty) {
      emit( InvoiceError( message: 'stock_taking.no_products_to_export'.tr(),));

      emit(const InvoiceInitial());
      return;
    }

    emit(const InvoiceExporting());

    try {
      final filePath = await _excelExportService.exportInvoice(
        products: _products,
      );

      if (filePath != null) {
        // التصدير نجح للأصناف الحالية.
        _isExcelExported = true;

        emit(InvoiceExported(filePath: filePath));
      } else {
        emit( InvoiceError(  message: 'stock_taking.export_cancelled'.tr(),));
      }
    } catch (e) {
      InvoiceError(
        message: 'stock_taking.export_failed'.tr(
          args: [e.toString()],
        ),

    );
    }

    await Future.delayed(const Duration(milliseconds: 500));

    emit(_restoreLoaded());
  }

  List<InvoiceProduct> get products => List.from(_products);
}
