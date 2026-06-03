import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'invoice_product.g.dart';

/// A single stock-taking line: a scanned product enriched with the catalogue
/// data from the API (name, system stock) plus the user's physical count.
///
/// [stockQuantity] is what the server says is in stock at scan time; the
/// user types [realQuantity] (the count they physically did). The derived
/// [diff] is `realQuantity - stockQuantity` — positive = surplus, negative
/// = shortage — and drives the red/green colour cue in the UI.
@HiveType(typeId: 5)
class InvoiceProduct extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String barcode;

  /// Scanned count for this row (always 1 with the always-new-line policy);
  /// kept for backward compatibility and for the legacy Excel export sums.
  @HiveField(2)
  final double quantity;

  @HiveField(3)
  final int productId;
  @HiveField(4)
  final String productArName;
  @HiveField(5)
  final String productEnName;
  @HiveField(6)
  final num stockQuantity;
  @HiveField(7)
  final num realQuantity;

  const InvoiceProduct({
    required this.id,
    required this.barcode,
    required this.quantity,
    this.productId = 0,
    this.productArName = '',
    this.productEnName = '',
    this.stockQuantity = 0,
    this.realQuantity = 0,
  });

  /// `real - system`. Negative → shortage (red), positive → surplus (green).
  num get diff => realQuantity - stockQuantity;

  String displayName(bool isAr) {
    final primary = isAr ? productArName : productEnName;
    if (primary.trim().isNotEmpty) return primary;
    final fallback = isAr ? productEnName : productArName;
    return fallback.trim().isNotEmpty ? fallback : barcode;
  }

  InvoiceProduct copyWith({
    String? id,
    String? barcode,
    double? quantity,
    int? productId,
    String? productArName,
    String? productEnName,
    num? stockQuantity,
    num? realQuantity,
  }) {
    return InvoiceProduct(
      id: id ?? this.id,
      barcode: barcode ?? this.barcode,
      quantity: quantity ?? this.quantity,
      productId: productId ?? this.productId,
      productArName: productArName ?? this.productArName,
      productEnName: productEnName ?? this.productEnName,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      realQuantity: realQuantity ?? this.realQuantity,
    );
  }

  @override
  List<Object?> get props => [
        id,
        barcode,
        quantity,
        productId,
        productArName,
        productEnName,
        stockQuantity,
        realQuantity,
      ];
}
