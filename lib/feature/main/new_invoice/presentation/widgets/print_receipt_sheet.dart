part of '../../new_invoice_imports.dart';

/// Bottom sheet: pick paper size (55/72/80) + a paired printer, then print.
/// Holds an off-screen [RepaintBoundary] wrapping [ReceiptView]; on print it
/// captures that boundary to a PNG, converts to ESC/POS bytes, and dispatches
/// [PrintReceipt] to [PrinterBloc].
class PrintReceiptSheet extends StatefulWidget {
  final InvoiceDetailsModel invoice;

  const PrintReceiptSheet({super.key, required this.invoice});

  @override
  State<PrintReceiptSheet> createState() => _PrintReceiptSheetState();
}

class _PrintReceiptSheetState extends State<PrintReceiptSheet> {

  // initState
  @override
  void initState() {
    super.initState();
    // Load paired devices on sheet open.
    context.read<PrinterBloc>().add(const LoadPairedDevices());
  }

  final GlobalKey _receiptKey = GlobalKey();
  ReceiptPaperSize _size = ReceiptPaperSize.mm80;
  String? _selectedMac;
  bool _capturing = false;

  Future<bool> _ensurePermissions() async {
    // Android 12+ needs runtime BLUETOOTH_CONNECT/SCAN. On older versions these
    // resolve to granted immediately. Location is only needed pre-Android-12.
    final statuses = await [
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
    ].request();
    return statuses.values.every((s) => s.isGranted || s.isLimited);
  }

  /// Renders the off-screen receipt boundary to a PNG (+ its pixel size).
  Future<({Uint8List png, int w, int h})?> _capturePng() async {
    // Let the selected-size receipt paint at least one frame before capture.
    await WidgetsBinding.instance.endOfFrame;
    final boundary = _receiptKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    if (boundary == null) return null;
    final uiImage = await boundary.toImage(pixelRatio: 1);
    final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return null;
    return (
      png: byteData.buffer.asUint8List(),
      w: uiImage.width,
      h: uiImage.height,
    );
  }

  /// Option 1 — build a PDF and hand it to the OS print dialog (any printer,
  /// or save / share as PDF). No Bluetooth permission or printer selection.
  Future<void> _printPdf() async {
    setState(() => _capturing = true);
    try {
      final cap = await _capturePng();
      if (cap == null) {
        if (mounted) showCustomSnackBar(context, 'printing.render_failed'.tr());
        return;
      }
      final pdfBytes = await ReceiptPdfBuilder.build(
        pngBytes: cap.png,
        widthPx: cap.w,
        heightPx: cap.h,
        size: _size,
      );
      await Printing.layoutPdf(
        onLayout: (_) async => pdfBytes,
        name: 'invoice_${widget.invoice.invoiceNo}',
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) showCustomSnackBar(context, 'printing.print_failed'.tr());
    } finally {
      if (mounted) setState(() => _capturing = false);
    }
  }

  /// Option 2 — capture, convert to ESC/POS, print directly over Bluetooth.
  Future<void> _printBluetooth() async {
    final mac = _selectedMac;
    if (mac == null) return;
    setState(() => _capturing = true);
    try {
      final granted = await _ensurePermissions();
      if (!granted) {
        if (mounted) {
          showCustomSnackBar(context, 'printing.permission_denied'.tr());
        }
        return;
      }
      final cap = await _capturePng();
      final image = cap == null ? null : img.decodePng(cap.png);
      if (image == null) {
        if (mounted) showCustomSnackBar(context, 'printing.render_failed'.tr());
        return;
      }
      final bytes = await ReceiptBuilder.build(image, _size);
      if (!mounted) return;
      context.read<PrinterBloc>().add(PrintReceipt(mac: mac, bytes: bytes));
    } finally {
      if (mounted) setState(() => _capturing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';
    return Stack(
      children: [
        _sheetContent(context, isAr),
        // Off-screen render target — translated far away so it paints (needed
        // for toImage) without being visible or affecting layout.
        Positioned(
          left: 0,
          top: 0,
          child: Transform.translate(
            offset: const Offset(-100000, 0),
            child: RepaintBoundary(
              key: _receiptKey,
              child: ReceiptView(
                invoice: widget.invoice,
                size: _size,
                isAr: isAr,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sheetContent(BuildContext context, bool isAr) {
    return BlocConsumer<PrinterBloc, PrinterState>(
      listenWhen: (p, c) => p.printStatus != c.printStatus,
      listener: (context, state) {
        if (state.printStatus == Status.success) {
          showCustomSnackBar(context, 'printing.printed'.tr());
          Navigator.pop(context);
        } else if (state.printStatus == Status.failure) {
          showCustomSnackBar(
              context, state.errorMessage ?? 'printing.print_failed'.tr());
        }
      },
      builder: (context, state) {
        final busy = _capturing || state.printStatus == Status.loading;
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.grey.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Text('printing.title'.tr(),
                    style: AppTextTheme.titleSmallBold
                        .copyWith(color: AppColors.black)),
                SizedBox(height: 12.h),
                // Paper size selector
                Text('printing.paper_size'.tr(),
                    style: AppTextTheme.caption.copyWith(color: AppColors.grey)),
                SizedBox(height: 6.h),
                Row(
                  children: ReceiptPaperSize.values.map((s) {
                    final selected = s == _size;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: GestureDetector(
                          onTap: busy ? null : () => setState(() => _size = s),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.mainAppColor
                                  : AppColors.mainAppColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              s.labelKey.tr(),
                              style: AppTextTheme.captionBold.copyWith(
                                color: selected
                                    ? Colors.white
                                    : AppColors.mainAppColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16.h),
                // Printer list header + refresh
                Row(
                  children: [
                    Text('printing.select_printer'.tr(),
                        style: AppTextTheme.caption
                            .copyWith(color: AppColors.grey)),
                    const Spacer(),
                    IconButton(
                      onPressed: busy
                          ? null
                          : () => context
                              .read<PrinterBloc>()
                              .add(const LoadPairedDevices()),
                      icon: Icon(Icons.refresh,
                          size: 20.sp, color: AppColors.mainAppColor),
                    ),
                  ],
                ),
                _deviceList(context, state),
                SizedBox(height: 16.h),
                // Option 1 — PDF then system print dialog / share.
                SizedBox(
                  height: 48.h,
                  child: ElevatedButton.icon(
                    onPressed: busy ? null : _printPdf,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainAppColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r)),
                    ),
                    icon: const Icon(Icons.picture_as_pdf_outlined,
                        color: Colors.white),
                    label: Text(
                      'printing.pdf_print'.tr(),
                      style:
                          AppTextTheme.body2Bold.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                // Option 2 — direct Bluetooth thermal print.
                SizedBox(
                  height: 48.h,
                  child: OutlinedButton.icon(
                    onPressed:
                        (_selectedMac == null || busy) ? null : _printBluetooth,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.mainAppColor,
                      side: BorderSide(color: AppColors.mainAppColor),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r)),
                    ),
                    icon: busy
                        ? SizedBox(
                            width: 18.w,
                            height: 18.w,
                            child: CircularProgressIndicator(
                                color: AppColors.mainAppColor, strokeWidth: 2),
                          )
                        : const Icon(Icons.bluetooth),
                    label: Text(
                      busy
                          ? 'printing.printing'.tr()
                          : 'printing.bluetooth_print'.tr(),
                      style: AppTextTheme.body2Bold
                          .copyWith(color: AppColors.mainAppColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _deviceList(BuildContext context, PrinterState state) {
    if (state.devicesStatus == Status.loading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    if (state.devicesStatus == Status.failure) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Text(state.errorMessage ?? 'printing.no_bluetooth'.tr(),
            textAlign: TextAlign.center,
            style: AppTextTheme.caption.copyWith(color: AppColors.red)),
      );
    }
    if (state.devices.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Text('printing.no_printers'.tr(),
            textAlign: TextAlign.center,
            style: AppTextTheme.caption.copyWith(color: AppColors.grey)),
      );
    }
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 220.h),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: state.devices.length,
        separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade200),
        itemBuilder: (context, i) {
          final d = state.devices[i];
          final selected = d.macAdress == _selectedMac;
          return ListTile(
            dense: true,
            leading: Icon(Icons.print_outlined,
                color: selected ? AppColors.mainAppColor : AppColors.grey),
            title: Text(d.name.isNotEmpty ? d.name : d.macAdress,
                style: AppTextTheme.captionBold.copyWith(color: AppColors.black)),
            subtitle: Text(d.macAdress,
                style: AppTextTheme.labelSmall.copyWith(color: AppColors.grey)),
            trailing: selected
                ? Icon(Icons.check_circle, color: AppColors.mainAppColor)
                : null,
            onTap: () => setState(() => _selectedMac = d.macAdress),
          );
        },
      ),
    );
  }
}
