import 'package:equatable/equatable.dart';
import 'invoice_product.dart';

/// Represents the complete invoice data
class InvoiceData extends Equatable {
  final List<InvoiceProduct> products;

  const InvoiceData({
    this.products = const [],
  });

  /// Get total number of unique items/products
  int get totalItems => products.length;

  /// Get total quantity across all products
  double get totalQuantity => products.fold(0.0, (sum, product) => sum + product.quantity);

  /// Check if invoice is empty
  bool get isEmpty => products.isEmpty;

  /// Create a copy with updated products
  InvoiceData copyWith({
    List<InvoiceProduct>? products,
  }) {
    return InvoiceData(
      products: products ?? this.products,
    );
  }

  @override
  List<Object?> get props => [products];
}
