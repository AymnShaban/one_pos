part of '../../invoice_setup_imports.dart';

abstract class InvoiceSetupEvent extends Equatable {
  const InvoiceSetupEvent();

  @override
  List<Object?> get props => [];
}

class LoadInvoiceSetupData extends InvoiceSetupEvent {
  final int branchId;
  final bool isPriceQuote;

  const LoadInvoiceSetupData({
    required this.branchId,
    this.isPriceQuote = false,
  });

  @override
  List<Object?> get props => [branchId, isPriceQuote];
}

class LoadPatternsByBranch extends InvoiceSetupEvent {
  final int branchId;
  final bool isPriceQuote;

  const LoadPatternsByBranch({
    required this.branchId,
    this.isPriceQuote = false,
  });

  @override
  List<Object?> get props => [branchId, isPriceQuote];
}

class SelectBranch extends InvoiceSetupEvent {
  final int branchId;
  final bool isPriceQuote;

  const SelectBranch({
    required this.branchId,
    this.isPriceQuote = false,
  });

  @override
  List<Object?> get props => [branchId, isPriceQuote];
}

class SelectPattern extends InvoiceSetupEvent {
  final int patternId;

  const SelectPattern(this.patternId);

  @override
  List<Object?> get props => [patternId];
}

class SelectCurrency extends InvoiceSetupEvent {
  final int currencyId;
  final double rate;

  const SelectCurrency({
    required this.currencyId,
    required this.rate,
  });

  @override
  List<Object?> get props => [currencyId, rate];
}