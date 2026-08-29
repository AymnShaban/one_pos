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

  @override
  Widget build(BuildContext context) {
    final width = size.dots.toDouble();

    return Container(
      width: width,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 8.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Section
          _buildHeader(),
          SizedBox(height: 6.h),
          _buildDashedDivider(),
          SizedBox(height: 6.h),

          // Invoice Info
          _buildInvoiceInfo(),
          SizedBox(height: 6.h),
          _buildDashedDivider(),
          SizedBox(height: 6.h),

          // Items Header
          _buildItemsHeader(),
          SizedBox(height: 4.h),
          _buildDashedDivider(),
          SizedBox(height: 4.h),

          // Items List
          ...invoice.items.asMap().entries.map((entry) =>
              _buildItemRow(entry.value, entry.key + 1)
          ),
          SizedBox(height: 4.h),
          _buildDashedDivider(),
          SizedBox(height: 6.h),

          // Totals Section
          _buildTotals(),
          SizedBox(height: 6.h),
          _buildDashedDivider(),
          SizedBox(height: 6.h),

          // Payment Method
          _buildPaymentMethod(),
          SizedBox(height: 6.h),
          _buildDashedDivider(),
          SizedBox(height: 6.h),

          // Footer
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    // Get company info from model or use defaults
    final companyName = invoice.companyBranchName ?? 'شركة ذاون';
    final branchAddress = 'حولي - أنابيب - شارع بن خلدون';
    final phoneNumber = '2222 4444';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        Icon(
          Icons.shopping_cart_outlined,
          size: 50.sp,
          color: Colors.black,
        ),
        SizedBox(width: 8.w),
        Column(
          children: [

            Text(
              companyName,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'للتجارة العامة',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              branchAddress,
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Tel: $phoneNumber',
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInvoiceInfo() {
    // Get invoice type from model
    final invoiceType = invoice.invoiceTypeId == 1 ? 'مبيعات' : 'مرتجع مبيعات';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'فاتورة ضريبة مبسطة',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'التاريخ: ${_formatDate(invoice.invoiceDate)}',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'الوقت: ${_formatTime(invoice.invoiceDate)}',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'رقم الفاتورة: INV-${invoice.invoiceNo.toString().padLeft(6, '0')}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'نوع الفاتورة: $invoiceType',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildItemsHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              'م',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'الصنف',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'الكمية',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'السعر',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'الخصم %',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'الإجمالي',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(InvoiceDetailsItem item, int index) {
    final itemName = item.displayName(isAr);

    // Format discount percentage
    final discountPercent = item.discount > 0
        ? '${(item.discount * 100).toStringAsFixed(0)}%'
        : '0%';

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              index.toString(),
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              itemName,
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              item.quantity.toString(),
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              item.price.toStringAsFixed(3),
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              discountPercent,
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              item.totalValue.toStringAsFixed(3),
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.black,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotals() {
    final totalItems = invoice.items.length;
    final totalQuantity = invoice.items.fold<num>(0, (sum, item) => sum + item.quantity);
    final subtotal = invoice.totalValue;
    final totalDiscount = invoice.totalDiscount;
    final totalAdditions = invoice.totalAddition;
    final finalTotal = invoice.finalValue;
    final currency = invoice.currencySymbol ?? 'د.ك.';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'إجمالي الأصناف:',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.black,
                ),
              ),
              Text(
                totalItems.toString(),
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'إجمالي الكمية:',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.black,
                ),
              ),
              Text(
                totalQuantity.toString(),
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المجموع الفرعي:',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.black,
                ),
              ),
              Text(
                subtotal.toStringAsFixed(3),
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'إجمالي الخصم:',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.black,
                ),
              ),
              Text(
                totalDiscount.toStringAsFixed(3),
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'إجمالي الإضافات:',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.black,
                ),
              ),
              Text(
                totalAdditions.toStringAsFixed(3),
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الإجمالي النهائي:',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                '$currency ${finalTotal.toStringAsFixed(3)}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          // Amount in words (Optional - if you want to show both)
          Text(
            _getAmountInWords(finalTotal),
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod() {
    // Get payment method from payWays
    final paymentMethod = invoice.payWays.isNotEmpty
        ? invoice.payWays.first.payWayName ?? 'نقدي'
        : 'نقدي';

    final amount = invoice.finalValue;
    final currency = invoice.currencySymbol ?? 'د.ك.';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'طريقة الدفع',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'طريقة الدفع: $paymentMethod',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.black87,
                ),
              ),
              Text(
                '$currency ${amount.toStringAsFixed(3)}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Text(
          'شكراً لتسوقكم معنا',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 2.h),
        Text(
          'للتوجه منتجات قابلة للإسترجاع أو الإستبدال',
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 2.h),
        Text(
          'للتواصل: 2222 4444',
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDashedDivider() {
    return DottedLine(
      direction: Axis.horizontal,
      lineLength: double.infinity,
      lineThickness: 1.0,
      dashLength: 4.0,
      dashColor: Colors.black,
      dashRadius: 0.0,
      dashGapLength: 4.0,
      dashGapColor: Colors.transparent,
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '2025/06/01';
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  String _formatTime(DateTime? date) {
    if (date == null) return '14:35:22';
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
  }

  // تحويل الأرقام إلى حروف (Optional)
  String _getAmountInWords(double amount) {
    // You can implement a proper Arabic number to words converter here
    // This is a simplified version
    final integerPart = amount.floor();
    final decimalPart = ((amount - integerPart) * 1000).round();

    // Basic implementation - you can use a package like 'num_to_words_arabic'
    // or implement your own converter
    return '(${_numberToArabicWords(integerPart)} دينار و ${_numberToArabicWords(decimalPart)} فلس)';
  }

  String _numberToArabicWords(int number) {
    // This is a placeholder - implement proper Arabic number to words conversion
    // Or use a package like: arabic_numbers or num_to_words_arabic
    return number.toString(); // Replace with actual conversion
  }
}
