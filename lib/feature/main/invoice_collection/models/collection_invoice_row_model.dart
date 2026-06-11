part of '../invoice_collection_imports.dart';

/// One row in the invoice picker (the "البحث عن فاتورة" screen). Picking a
/// row pops back to the collection screen and feeds [CollectionInvoiceLinked]
/// so the collection form fills in the invoice id + no + customer + value.
class CollectionInvoiceRowModel extends Equatable {
  final num invoiceId;
  final num invoiceNo;
  final num customerId;
  final String customerArName;
  final String customerEnName;
  final double totalValue;
  final double remainder;

  const CollectionInvoiceRowModel({
    required this.invoiceId,
    required this.invoiceNo,
    required this.customerId,
    required this.customerArName,
    required this.customerEnName,
    required this.totalValue,
    required this.remainder,
  });

  factory CollectionInvoiceRowModel.fromJson(Map<String, dynamic> json) {
    return CollectionInvoiceRowModel(
      invoiceId: json['InvoiceID'] ?? 0,
      invoiceNo: json['InvoiceNo'] ?? 0,
      customerId: json['CustomerID'] ?? 0,
      customerArName: json['CustomerName'] ?? '',
      customerEnName: json['CustomerEnName'] ?? '',
      totalValue: (json['TotalValue'] ?? 0).toDouble(),
      remainder: (json['Remainder'] ?? 0).toDouble(),
    );
  }

  String displayName(bool isAr) {
    final primary = isAr ? customerArName : customerEnName;
    if (primary.trim().isNotEmpty) return primary;
    final fallback = isAr ? customerEnName : customerArName;
    return fallback.trim().isNotEmpty ? fallback : '#$invoiceNo';
  }

  @override
  List<Object?> get props => [invoiceId, invoiceNo];
}
