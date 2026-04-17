part of '../../invoice_collection_imports.dart';

abstract class InvoiceCollectionEvent extends Equatable {
  const InvoiceCollectionEvent();

  @override
  List<Object?> get props => [];
}

class LoadCollectionSetupData extends InvoiceCollectionEvent {
  const LoadCollectionSetupData();
}

class CollectionBranchChanged extends InvoiceCollectionEvent {
  final int branchId;

  const CollectionBranchChanged(this.branchId);

  @override
  List<Object?> get props => [branchId];
}

class CollectionCurrencyChanged extends InvoiceCollectionEvent {
  final int currencyId;
  final double rate;

  const CollectionCurrencyChanged({
    required this.currencyId,
    required this.rate,
  });

  @override
  List<Object?> get props => [currencyId, rate];
}

class CollectionPayWayChanged extends InvoiceCollectionEvent {
  final int codePw;

  const CollectionPayWayChanged(this.codePw);

  @override
  List<Object?> get props => [codePw];
}

class CollectionBondTypeChanged extends InvoiceCollectionEvent {
  final int voucherType;
  final String bankName;

  const CollectionBondTypeChanged({
    required this.voucherType,
    required this.bankName,
  });

  @override
  List<Object?> get props => [voucherType];
}

class CollectionInvoiceLinked extends InvoiceCollectionEvent {
  final num invoiceId;
  final num invoiceNo;
  final double voucherValue;
  final String customerName;
  final num acId;

  const CollectionInvoiceLinked({
    required this.invoiceId,
    required this.invoiceNo,
    required this.voucherValue,
    required this.customerName,
    required this.acId,
  });

  @override
  List<Object?> get props => [invoiceId, invoiceNo];
}

class CollectionCustomerSearched extends InvoiceCollectionEvent {
  final num acId;
  final String acName;

  const CollectionCustomerSearched({
    required this.acId,
    required this.acName,
  });

  @override
  List<Object?> get props => [acId];
}

class SubmitCollection extends InvoiceCollectionEvent {
  final CollectionRequestModel request;

  const SubmitCollection(this.request);

  @override
  List<Object?> get props => [request];
}

class EditCollection extends InvoiceCollectionEvent {
  final CollectionRequestModel request;

  const EditCollection(this.request);

  @override
  List<Object?> get props => [request];
}