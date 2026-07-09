part of '../new_invoice_imports.dart';

/// Turns a captured receipt image into ESC/POS bytes for the chosen paper size.
/// The [image] must already be sized to [size].dots wide (see [ReceiptView]).
class ReceiptBuilder {
  const ReceiptBuilder._();

  static Future<List<int>> build(
    img.Image image,
    ReceiptPaperSize size,
  ) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(size.escPos, profile);
    final bytes = <int>[];
    bytes.addAll(generator.imageRaster(image, align: PosAlign.center));
    bytes.addAll(generator.feed(2));
    bytes.addAll(generator.cut());
    return bytes;
  }
}
