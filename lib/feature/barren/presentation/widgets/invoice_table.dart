import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/invoice_product.dart';
import 'invoice_item_row.dart';

/// Scrollable list of scanned products. Each row is a two-line card (see
/// [InvoiceItemRow]) so the column headers don't make sense here — every
/// cell self-labels.
class InvoiceTable extends StatelessWidget {
  final List<InvoiceProduct> products;
  final Function(String id) onDeleteProduct;
  final Function(String id, double realQuantity) onRealQuantityChanged;

  const InvoiceTable({
    super.key,
    required this.products,
    required this.onDeleteProduct,
    required this.onRealQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: products.isEmpty
          ? Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40.h),
                child: Text(
                  'no_products_to_export'.tr(),
                  style: TextStyle(fontSize: 16.sp, color: Colors.black38),
                ),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return InvoiceItemRow(
                  product: product,
                  onDelete: () => onDeleteProduct(product.id),
                  onRealQuantityChanged: (newQty) =>
                      onRealQuantityChanged(product.id, newQty),
                );
              },
            ),
    );
  }
}
