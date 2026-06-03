import 'dart:developer' as dev;
import 'dart:math';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import '../../domain/entities/invoice_product.dart';

/// Exports a stock-taking session to an Excel file. The mobile UI shows two
/// rows per product (identity + numbers), but the spreadsheet keeps each
/// product on **one row** for readability — six columns: index, name,
/// barcode, system stock, real qty, diff. Green / red fills mirror the
/// mobile colour cue on the diff column.
class ExcelExportService {
  Future<String?> exportInvoice({
    required List<InvoiceProduct> products,
  }) async {
    try {
      final excel = Excel.createExcel();
      final sheet = excel['Invoice'];

      final headerStyle = CellStyle(
        bold: true,
        fontSize: 14,
        horizontalAlign: HorizontalAlign.Center,
        verticalAlign: VerticalAlign.Center,
      );
      final dataStyle = CellStyle(
        horizontalAlign: HorizontalAlign.Center,
        verticalAlign: VerticalAlign.Center,
      );
      // Diff colour cues (matching the mobile row): green = surplus,
      // red = shortage. Background hex strings include the leading '#'
      // and may be ignored on some excel-package versions; the value
      // itself stays correct either way.
      final diffSurplusStyle = CellStyle(
        horizontalAlign: HorizontalAlign.Center,
        verticalAlign: VerticalAlign.Center,
        backgroundColorHex: ExcelColor.fromHexString('#C8E6C9'),
      );
      final diffShortageStyle = CellStyle(
        horizontalAlign: HorizontalAlign.Center,
        verticalAlign: VerticalAlign.Center,
        backgroundColorHex: ExcelColor.fromHexString('#FFCDD2'),
      );

      const headers = ['#', 'الصنف', 'الباركود', 'المخزون', 'الكمية الفعلية', 'الفرق'];
      for (int c = 0; c < headers.length; c++) {
        final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: 0));
        cell.value = TextCellValue(headers[c]);
        cell.cellStyle = headerStyle;
      }

      for (int i = 0; i < products.length; i++) {
        final p = products[i];
        final rowIndex = i + 1;

        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
          ..value = IntCellValue(i + 1)
          ..cellStyle = dataStyle;

        // Prefer Arabic name; fall back to English then barcode.
        final name = p.productArName.isNotEmpty
            ? p.productArName
            : (p.productEnName.isNotEmpty ? p.productEnName : p.barcode);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
          ..value = TextCellValue(name)
          ..cellStyle = dataStyle;

        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
          ..value = TextCellValue(p.barcode)
          ..cellStyle = dataStyle;

        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
          ..value = DoubleCellValue(p.stockQuantity.toDouble())
          ..cellStyle = dataStyle;

        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex))
          ..value = DoubleCellValue(p.realQuantity.toDouble())
          ..cellStyle = dataStyle;

        final diff = p.diff;
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex))
          ..value = DoubleCellValue(diff.toDouble())
          ..cellStyle = diff > 0
              ? diffSurplusStyle
              : diff < 0
                  ? diffShortageStyle
                  : dataStyle;
      }

      // Summary row (one blank row gap, then totals).
      final summaryRowIndex = products.length + 2;
      final summaryStyle = CellStyle(
        bold: true,
        fontSize: 12,
        horizontalAlign: HorizontalAlign.Center,
      );

      final totalReal = products.fold<num>(0, (s, p) => s + p.realQuantity);
      final totalStock = products.fold<num>(0, (s, p) => s + p.stockQuantity);
      final totalDiff = totalReal - totalStock;

      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: summaryRowIndex))
        ..value = TextCellValue('عدد الأصناف: ${products.length}')
        ..cellStyle = summaryStyle;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: summaryRowIndex))
        ..value = DoubleCellValue(totalStock.toDouble())
        ..cellStyle = summaryStyle;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: summaryRowIndex))
        ..value = DoubleCellValue(totalReal.toDouble())
        ..cellStyle = summaryStyle;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: summaryRowIndex))
        ..value = DoubleCellValue(totalDiff.toDouble())
        ..cellStyle = summaryStyle;

      final fileBytes = excel.encode();
      if (fileBytes == null) return null;
      final uint8Bytes = Uint8List.fromList(fileBytes);

      final now = DateTime.now();
      final random = Random().nextInt(10000);
      final dateStr = '${now.day}-${now.month}-${now.year}';
      final fileName = '($dateStr $random).xlsx';

      final outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'حفظ الفاتورة',
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        bytes: uint8Bytes,
      );

      // On Android, saveFile with bytes may return the filename rather than
      // the full path, or null even after a successful save. Either way the
      // user already chose the destination; return what we have.
      return outputPath ?? fileName;
    } catch (e, st) {
      dev.log('Error exporting Excel: $e', stackTrace: st, name: 'barren-export');
      return null;
    }
  }
}
