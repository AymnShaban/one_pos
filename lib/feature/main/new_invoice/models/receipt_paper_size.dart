part of '../new_invoice_imports.dart';

/// The three supported thermal paper widths. [dots] is the pixel width the
/// receipt is rendered at (matches the printer head 1:1, so no scaling), and
/// [escPos] is the paper size handed to the ESC/POS [Generator].
enum ReceiptPaperSize {
  mm55(dots: 384, escPos: PaperSize.mm58, labelKey: 'printing.size_55'),
  mm72(dots: 512, escPos: PaperSize.mm72, labelKey: 'printing.size_72'),
  mm80(dots: 576, escPos: PaperSize.mm80, labelKey: 'printing.size_80');

  const ReceiptPaperSize({
    required this.dots,
    required this.escPos,
    required this.labelKey,
  });

  final int dots;
  final PaperSize escPos;
  final String labelKey;
}
