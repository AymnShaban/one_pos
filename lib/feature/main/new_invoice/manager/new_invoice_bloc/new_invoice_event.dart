part of '../../new_invoice_imports.dart';

abstract class NewInvoiceEvent extends Equatable {
  const NewInvoiceEvent();

  @override
  List<Object?> get props => [];
}

class LoadPayWays extends NewInvoiceEvent {
  const LoadPayWays();
}

class LoadLastInvoiceId extends NewInvoiceEvent {
  final int patternId;
  const LoadLastInvoiceId(this.patternId);

  @override
  List<Object?> get props => [patternId];
}

class SubmitInvoice extends NewInvoiceEvent {
  final CreateInvoiceRequest request;
  const SubmitInvoice(this.request);

  @override
  List<Object?> get props => [request];
}

class EditInvoice extends NewInvoiceEvent {
  final EditInvoiceRequest request;
  const EditInvoice(this.request);

  @override
  List<Object?> get props => [request];
}

class UpdatePatternId extends NewInvoiceEvent {
  final int patternId;
  const UpdatePatternId(this.patternId);

  @override
  List<Object?> get props => [patternId];
}

class UpdateBranchId extends NewInvoiceEvent {
  final int branchId;
  const UpdateBranchId(this.branchId);

  @override
  List<Object?> get props => [branchId];
}

class UpdateCurrency extends NewInvoiceEvent {
  final int currencyId;
  final double rate;
  const UpdateCurrency({required this.currencyId, required this.rate});

  @override
  List<Object?> get props => [currencyId, rate];
}

class CreateInvoiceFromSales extends NewInvoiceEvent {
  final List<ItemModel> basketItems;
  final int patternId;
  final int branchId;
  final int currencyId;
  final double rate;
  final int? customerId;
  final double totalValue;
  final String createdBy;

  const CreateInvoiceFromSales({
    required this.basketItems,
    required this.patternId,
    required this.branchId,
    required this.currencyId,
    required this.rate,
    required this.totalValue,
    required this.createdBy,
    this.customerId,
  });

  @override
  List<Object?> get props => [basketItems, patternId, branchId, currencyId, rate, customerId, totalValue, createdBy];
}