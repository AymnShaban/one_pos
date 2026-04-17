part of '../../invoice_collection_imports.dart';

abstract class InvoiceCollectionEvent extends Equatable {
  const InvoiceCollectionEvent();

  @override
  List<Object?> get props => [];
}

class LoadInvoiceCollectionData extends InvoiceCollectionEvent {
  final int branchId;
  final bool isPriceQuote;

  const LoadInvoiceCollectionData({
    required this.branchId,
    this.isPriceQuote = false,
  });

  @override
  List<Object?> get props => [branchId, isPriceQuote];
}

class LoadPatternsByBranch extends InvoiceCollectionEvent {
  final int branchId;
  final bool isPriceQuote;

  const LoadPatternsByBranch({
    required this.branchId,
    this.isPriceQuote = false,
  });

  @override
  List<Object?> get props => [branchId, isPriceQuote];
}

class SelectBranch extends InvoiceCollectionEvent {
  final int branchId;
  final bool isPriceQuote;

  const SelectBranch({
    required this.branchId,
    this.isPriceQuote = false,
  });

  @override
  List<Object?> get props => [branchId, isPriceQuote];
}

class SelectPattern extends InvoiceCollectionEvent {
  final int patternId;

  const SelectPattern(this.patternId);

  @override
  List<Object?> get props => [patternId];
}

class SelectCurrency extends InvoiceCollectionEvent {
  final int currencyId;
  final double rate;

  const SelectCurrency({
    required this.currencyId,
    required this.rate,
  });

  @override
  List<Object?> get props => [currencyId, rate];
}