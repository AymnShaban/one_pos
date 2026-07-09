part of '../../new_invoice_imports.dart';

/// Off-screen, monochrome, print-only rendition of the invoice. Rendered at a
/// FIXED logical width of [size].dots so `RepaintBoundary.toImage(pixelRatio:1)`
/// produces an image exactly that many pixels wide — a 1:1 match to the printer
/// head. Deliberately uses raw pixel sizes (NOT ScreenUtil .w/.sp) and pure
/// black-on-white so the 1-bit thermal raster stays crisp.
class ReceiptView extends StatelessWidget {
  final InvoiceDetailsModel invoice;
  final ReceiptPaperSize size;
  final bool isAr;

  const ReceiptView({
    super.key,
    required this.invoice,
    required this.size,
    required this.isAr,
  });

  double get _base => size == ReceiptPaperSize.mm55 ? 20 : 24;

  @override
  Widget build(BuildContext context) {
    final width = size.dots.toDouble();
    return Directionality(
      textDirection: isAr ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Material(
        color: Colors.white,
        child: Container(
          width: width,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header: branch + invoice type ──
              _t(_branchName(), size: _base + 6, bold: true, center: true),
              const SizedBox(height: 4),
              _t(_invoiceTypeLabel(invoice.invoiceTypeId),
                  size: _base, center: true),
              const SizedBox(height: 8),
              _dashed(),
              // ── Meta ──
              _kv('invoice_details.invoice_number'.tr(), '#${invoice.invoiceNo}'),
              if (invoice.invoiceDate != null)
                _kv(
                  'invoice_details.date'.tr(),
                  DateFormat('yyyy/MM/dd  HH:mm', 'en_US')
                      .format(invoice.invoiceDate!),
                ),
              _kv(
                'invoice_details.customer'.tr(),
                invoice.customerName?.trim().isNotEmpty == true
                    ? invoice.customerName!
                    : '-',
              ),
              const SizedBox(height: 6),
              _dashed(),
              // ── Items ──
              ...invoice.items.map(_itemBlock),
              _dashed(),
              // ── Totals ──
              _kv('invoice_details.total'.tr(), _money(invoice.totalValue)),
              if (invoice.totalDiscount != 0)
                _kv('invoice_details.total_discount'.tr(),
                    _money(invoice.totalDiscount)),
              if (invoice.totalAddition != 0)
                _kv('invoice_details.total_addition'.tr(),
                    _money(invoice.totalAddition)),
              const SizedBox(height: 4),
              _kv(
                'invoice_details.final_value'.tr(),
                _money(invoice.finalValue, symbol: invoice.symbol),
                bold: true,
                big: true,
              ),
              const SizedBox(height: 6),
              _dashed(),
              // ── Payments ──
              ...invoice.payWays.map(
                (p) => _kv(
                  _payWayLabel(p, isAr),
                  _money(p.localValue, symbol: invoice.symbol),
                ),
              ),
              const SizedBox(height: 8),
              _dashed(),
              // ── Footer ──
              if (invoice.createdBy?.trim().isNotEmpty == true)
                _t(
                  '${'invoice_details.created_by'.tr()} ${invoice.createdBy}',
                  size: _base - 4,
                  center: true,
                ),
              _t(
                invoice.taxBill
                    ? 'invoice_details.taxable'.tr()
                    : 'invoice_details.non_taxable'.tr(),
                size: _base - 4,
                center: true,
              ),
              const SizedBox(height: 6),
              _t('printing.thank_you'.tr(),
                  size: _base, bold: true, center: true),
            ],
          ),
        ),
      ),
    );
  }

  String _branchName() =>
      invoice.companyBranchName?.trim().isNotEmpty == true
          ? invoice.companyBranchName!
          : '${'invoice_details.branch'.tr()} ${invoice.companyBranchId ?? ''}'
              .trim();

  Widget _itemBlock(InvoiceDetailsItem item) {
    final qty = item.unitName?.isNotEmpty == true
        ? '${_num(item.quantity)} ${item.unitName}'
        : _num(item.quantity);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _t(item.displayName(isAr), size: _base, bold: true),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _t('$qty × ${item.price.toStringAsFixed(2)}', size: _base - 4),
              _t(item.totalValue.toStringAsFixed(3),
                  size: _base - 2, bold: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _kv(String k, String v, {bool bold = false, bool big = false}) {
    final fs = big ? _base + 2 : _base - 2;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(child: _t(k, size: fs, bold: bold)),
          const SizedBox(width: 8),
          _t(v, size: fs, bold: bold),
        ],
      ),
    );
  }

  Widget _t(String text,
      {required double size, bool bold = false, bool center = false}) {
    return Text(
      text,
      textAlign: center ? TextAlign.center : TextAlign.start,
      style: TextStyle(
        color: Colors.black,
        fontSize: size,
        height: 1.15,
        fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
      ),
    );
  }

  Widget _dashed() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Container(height: 2, color: Colors.black),
      );
}
