part of '../new_invoice_imports.dart';

/// Builds a roll-sized PDF from the captured receipt PNG, so it can be sent to
/// the OS print dialog (any printer) or saved/shared. Embedding the same image
/// keeps Arabic shaping identical to the on-screen/Bluetooth receipt.
class ReceiptPdfBuilder {
  const ReceiptPdfBuilder._();

  static Future<Uint8List> build({
    required Uint8List pngBytes,
    required int widthPx,
    required int heightPx,
    required ReceiptPaperSize size,
  }) async {
    // Thermal printers are 203 dpi = 8 dots/mm, so px / 8 = millimetres.
    final widthMm = widthPx / 8.0;
    final heightMm = heightPx / 8.0;
    final format = PdfPageFormat(
      widthMm * PdfPageFormat.mm,
      heightMm * PdfPageFormat.mm,
      marginAll: 0,
    );

    final doc = pw.Document();
    final image = pw.MemoryImage(pngBytes);
    doc.addPage(
      pw.Page(
        pageFormat: format,
        build: (_) => pw.Image(image, fit: pw.BoxFit.fitWidth),
      ),
    );
    return doc.save();
  }
}
