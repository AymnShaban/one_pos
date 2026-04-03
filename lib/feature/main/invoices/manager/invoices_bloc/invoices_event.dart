part of '../../invoices_imports.dart';

abstract class InvoicesEvent extends Equatable {
  const InvoicesEvent();

  @override
  List<Object?> get props => [];
}

class FetchInvoices extends InvoicesEvent {
  const FetchInvoices();
}

class SearchInvoices extends InvoicesEvent {
  final String query;
  const SearchInvoices(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterInvoicesByStatus extends InvoicesEvent {
  final InvoiceStatus status;
  const FilterInvoicesByStatus(this.status);

  @override
  List<Object?> get props => [status];
}

class LoadMoreInvoices extends InvoicesEvent {
  const LoadMoreInvoices();
}

class DeleteInvoice extends InvoicesEvent {
  final String invoiceId;
  const DeleteInvoice(this.invoiceId);

  @override
  List<Object?> get props => [invoiceId];
}