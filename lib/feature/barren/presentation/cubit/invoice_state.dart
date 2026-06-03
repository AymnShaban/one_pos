import 'package:equatable/equatable.dart';
import '../../domain/entities/invoice_product.dart';

/// Base state for invoice management
abstract class InvoiceState extends Equatable {
  const InvoiceState();

  @override
  List<Object?> get props => [];
}

/// Initial empty invoice state
class InvoiceInitial extends InvoiceState {
  const InvoiceInitial();
}

/// Transient: an API barcode lookup is in flight.
class InvoiceSearching extends InvoiceState {
  const InvoiceSearching();
}

/// Invoice loaded with products
class InvoiceLoaded extends InvoiceState {
  final List<InvoiceProduct> products;

  const InvoiceLoaded({required this.products});

  int get totalItems => products.length;

  /// Sum of the user-entered physical counts — what shows on the summary.
  num get totalQuantity => products.fold<num>(0, (sum, p) => sum + p.realQuantity);

  @override
  List<Object?> get props => [products];
}

/// Excel export in progress
class InvoiceExporting extends InvoiceState {
  const InvoiceExporting();
}

/// Excel export completed successfully
class InvoiceExported extends InvoiceState {
  final String? filePath;

  const InvoiceExported({this.filePath});

  @override
  List<Object?> get props => [filePath];
}

/// Error state
class InvoiceError extends InvoiceState {
  final String message;

  const InvoiceError({required this.message});

  @override
  List<Object?> get props => [message];
}
