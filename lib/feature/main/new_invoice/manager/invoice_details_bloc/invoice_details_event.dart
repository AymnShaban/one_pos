part of '../../new_invoice_imports.dart';

abstract class InvoiceDetailsEvent extends Equatable {
  const InvoiceDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadInvoiceDetails extends InvoiceDetailsEvent {
  final int invoiceId;
  final int invoiceNo;

  const LoadInvoiceDetails({required this.invoiceId, required this.invoiceNo});

  @override
  List<Object?> get props => [invoiceId, invoiceNo];
}
