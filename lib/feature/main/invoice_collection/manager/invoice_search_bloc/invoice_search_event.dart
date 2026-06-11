part of '../../invoice_collection_imports.dart';

abstract class InvoiceSearchEvent extends Equatable {
  const InvoiceSearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchInvoicesByNumber extends InvoiceSearchEvent {
  final String invoiceNo;
  const SearchInvoicesByNumber(this.invoiceNo);

  @override
  List<Object?> get props => [invoiceNo];
}

class SearchInvoicesByName extends InvoiceSearchEvent {
  final String name;
  const SearchInvoicesByName(this.name);

  @override
  List<Object?> get props => [name];
}

class LoadAllInvoicesForCustomer extends InvoiceSearchEvent {
  /// Pass `-1` (the old cubit's convention) to ask the server for all
  /// invoices regardless of customer.
  final int customerId;
  const LoadAllInvoicesForCustomer(this.customerId);

  @override
  List<Object?> get props => [customerId];
}
