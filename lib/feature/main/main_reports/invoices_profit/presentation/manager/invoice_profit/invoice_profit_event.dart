import '../../../invoice_profit_imports.dart';

abstract class InvoiceProfitEvent extends Equatable {
  const InvoiceProfitEvent();

  @override
  List<Object?> get props => [];
}

class LoadInvoiceProfitReport extends InvoiceProfitEvent {
  final BillRevenueRequestModel request;

  const LoadInvoiceProfitReport({
    required this.request,
  });

  @override
  List<Object?> get props => [request];
}

class ClearInvoiceProfitReport extends InvoiceProfitEvent {}